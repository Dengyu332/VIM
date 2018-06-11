%follow DW_batch_check_badch.m
%loop through *_subcort.mat files, chunk raw session into trials, and visually inspect bad trials
% generate *_session*_subcort_trials_step1(_v2).mat (_v2 is 2s pre cue to 2s post spoff)
%% set machine
DW_machine;
%% loading packages
rmpath(genpath([dropbox,'Functions/Dengyu/git/fieldtrip']));
addpath([dropbox,'Functions/Dengyu/git/fieldtrip']);
ft_defaults;
bml_defaults;
%read in subject list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
Subject_list([2,4],:) =[]; % DBS4043 doesn't have subcortical recording, and DBS4039 not speech codede

%%
for Subject_idx = 1:height(Subject_list)
    
    Subject_id = cell2mat(Subject_list.Subject_id(Subject_idx));
    
    data_dir = dir(['/Users/Dengyu/Documents/Temp_data/v2/subcort/' Subject_id '_*_subcort.mat']);
    
    for which_session = 1:length(data_dir) % deal with one session at a time

        load([data_dir(which_session).folder filesep data_dir(which_session).name]);% load in data of session oi
        
        % load in annot table
        cue = bml_annot_read([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'annot/cue_presentation.txt']);
        coding = bml_annot_read([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'annot/coding.txt']);
        electrode =  bml_annot_read([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'annot/electrode.txt']);
        
        %re-order the coding table according to sessions and trials
        %This is to avoid possible chaos
        coding_reorder = sortrows(coding,{'session_id','trial_id'}); 
        coding_reorder.id = (1:size(coding_reorder,1))';
        
        %exclude trials whose onset or offset word timepoints are missing
        essential_time_needed = table2array(coding_reorder(:,{'onset_word','offset_word'}));
        absen_trial_idx = find(any(isnan(essential_time_needed),2)); % any of the four 2 points missing
        
        coding_reorder(absen_trial_idx,:) = []; % remove those
        coding_reorder.id = (1:size(coding_reorder,1))';
        
        % then merge coding and cue of session of interest

        coding_sessionoi = coding_reorder(coding_reorder.session_id == which_session,:);
        cue_sessionoi = cue(cue.session_id == which_session,:);
        
        % find trials in common
        common_trials = intersect(coding_sessionoi.trial_id,cue_sessionoi.trial_id);
        
        % choose intersected trials
        coding_sessionoi = coding_sessionoi(find(ismember(coding_sessionoi.trial_id,common_trials)),:);
        
        cue_sessionoi = cue_sessionoi(find(ismember(cue_sessionoi.trial_id,common_trials)),:);
        
        %combine
        epoch_oi=join(...
        coding_sessionoi,...
        cue_sessionoi(:,{'ITI_starts','stimulus_starts','trial_id','session_id'}),...
        'keys',{'session_id','trial_id'});
    
    
        epoch_oi = sortrows(epoch_oi,{'session_id','trial_id'}); %re-order the epoch1 table according to sessions and trials
        
        epoch_oi.starts = epoch_oi.stimulus_starts;
        epoch_oi.ends = epoch_oi.offset_word;
        epoch_oi = bml_annot_table(epoch_oi);
        epoch_oi = bml_annot_extend(epoch_oi,2,2); % a trial is here defined as  2s pre cue to 2s post speech offset
        
        
        epoch_used = epoch_oi;
        cfg=[];
        cfg.epoch = epoch_used;
        % cfg.t0='stimulus_starts'; align all trials to cue presentation
        D1=bml_redefinetrial(cfg,D);% chunk into trials
        
        epoch_oi.id = (1:size(epoch_oi,1))';
        
        %D1 and epoch_oi are a pair
        D1.epoch = epoch_oi;
        
%% visually inspect trials
        cfg=[];
        cfg.viewmode = 'vertical';
        ft_databrowser(cfg,D1);
        
        pause;
        close all;
        visobad_idx = input('Please enter a vector of bad trial: ');
        disp(['This is ' data_dir(which_session).name]);
        
        D1.badch = [];
        D1.visobad_idx = visobad_idx;
        D1.state = 'notch_filt,ds2 1khz,lpf_400, hpf_2, badch detected,badtrial visually inspected';
        
        D = D1;
        %% save
%         save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'subcort/'...
%             filesep data_dir(which_session).name(1:end-4) '_trials_step1_v2.mat'],'D','session_epoch','-v7.3');
        save(['/Users/Dengyu/Documents/Temp_data/v2/subcort/' data_dir(which_session).name(1:end-4) '_trials_step1.mat'],'D','session_epoch','-v7.3'); % save locally        
        
    end
end