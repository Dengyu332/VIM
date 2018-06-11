%follow DW_batch_finalize_badtrial_ecog
%common average referencing across all contacts
%generate step3
%% set machine
DW_machine;

%read in subject list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
Subject_list([2],:) =[]; % DBS4039 no ecog

for Subject_idx = 1:height(Subject_list)
    
    Subject_id = cell2mat(Subject_list.Subject_id(Subject_idx));
    
    data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'ecog/*_step2.mat']);
    
    for which_session = 1:length(data_dir) % deal with one session at a time

        load([data_dir(which_session).folder filesep data_dir(which_session).name]);% load in data of step2 session oi
        
        mean_trial = cellfun(@(x) mean(x,1),D.trial,'UniformOutput',0); % get an average trial for each trial
        
        D.trial(2,:) = cellfun(@(x,y) x-y,D.trial,mean_trial,'UniformOutput',0); % common average referencing
        
        D.state = [D.state, ', CAR across all channels, put at second row'];
        
        save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'ecog/'...
        data_dir(which_session).name(1:end-5) '3.mat'],'D','session_epoch','-v7.3');    

    end
end