%follow DW_batch_deftrials_ecog
%generate step2
%% set machine
DW_machine;

fs = 1000;
%read in subject list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
Subject_list([2],:) =[]; % DBS4039 no ecog

for Subject_idx = 1:height(Subject_list)
    
    Subject_id = cell2mat(Subject_list.Subject_id(Subject_idx));
    
    data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'ecog/*_step1.mat']);
    
    for which_session = 1:length(data_dir) % deal with one session at a time

        load([data_dir(which_session).folder filesep data_dir(which_session).name]);% load in data of step1 session oi
        
        D1 = D;
        ideal_length = round((D1.epoch.ends - D1.epoch.starts)*fs);
        actual_length = cell2mat(cellfun(@(x) length(x),D1.time,'UniformOutput',0))';
        partialtrial_idx = find(ideal_length> actual_length + 2); % identify partial trial
        badtrial_final = partialtrial_idx;
        
        D.badtrial_final = badtrial_final;
        
        D.state = [D.state,', badtrials are only partial trials'];
        
        save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'ecog/'...
        data_dir(which_session).name(1:end-5) '2.mat'],'D','session_epoch','-v7.3');    
       
        
    end
end