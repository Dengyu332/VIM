% follow DW_batch_check_badch.m
% deal with DBS4039 specifically, chunk raw session into trials, and visually inspect bad trials
% generate *_session*_subcort_trials_step1.mat
%% set machine
DW_machine;
%% loading packages
rmpath(genpath([dropbox,'Functions/Dengyu/git/fieldtrip']));
addpath([dropbox,'Functions/Dengyu/git/fieldtrip']);
ft_defaults;
bml_defaults;
%
Subject_id = 'DBS4039';
%%
data_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' Subject_id '_*_subcort.mat']);
    
for which_session = 1:length(data_dir) % deal with one session at a time

    load([data_dir(which_session).folder filesep data_dir(which_session).name]);% load in data of session oi

    % load in annot table
    cue = bml_annot_read([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v1/' Subject_id filesep 'annot/cue_presentation.txt']);
    
    % no coding table for DBS4039
    %coding = bml_annot_read([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'annot/coding.txt']);
    
    electrode =  bml_annot_read([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v1/' Subject_id filesep 'annot/electrode.txt']);
    
    cue = cue(cue.session_id == which_session,:); % session of interest
    
    epoch_oi= cue(:,{'id','starts','ends','duration','ITI_starts','ITI_ends','alert_ends','stimulus_starts','session_id','trial_id','word'});


    epoch_oi = sortrows(epoch_oi,{'session_id','trial_id'}); %re-order the epoch1 table according to sessions and trials

    epoch_oi.starts = epoch_oi.stimulus_starts;
    epoch_oi.ends = epoch_oi.stimulus_starts;
    epoch_oi = bml_annot_table(epoch_oi);
    
    epoch_oi = bml_annot_extend(epoch_oi,2,3); % a trial is here defined as  2s pre cue to 3s post cue


    epoch_used = epoch_oi;
    cfg=[];
    cfg.epoch = epoch_used;
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
    D1.state = 'notch_filt,ds2 1khz,lpf_400, hpf_2, badch detected,badtrial visually inspected; trials defined as -2 pre-cue to +3 post cue';
    D = D1;
    %% save

    save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' data_dir(which_session).name(1:end-4) '_trials_step1.mat'],'D','session_epoch','-v7.3');      
end   