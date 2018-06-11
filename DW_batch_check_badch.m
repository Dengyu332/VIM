% follow DW_batch_tidy_ft_raw.m
% loop through all patient's *_subcort.mat files and inspect bad channels
% visually
%generate D.badch field

%use together with DW_check_raw_spectro.m

% set machine
DW_machine;
%% loading packages
rmpath(genpath([dropbox,'Functions/Dengyu/git/fieldtrip']));
addpath([dropbox,'Functions/Dengyu/git/fieldtrip']);
ft_defaults;
bml_defaults;
% %read in subject list
% Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
% Subject_list(4,:) =[]; % DBS4043 doesn't have subcortical recording
% 
% 
% for Subject_idx = 1:height(Subject_list)
%     Subject_id = cell2mat(Subject_list.Subject_id(Subject_idx));
%     
%     data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'subcort/*_subcort.mat']);
%     
%     for which_session = 1:length(data_dir) % deal with one session at a time
%         load([data_dir(which_session).folder filesep data_dir(which_session).name]);
%         
%         cfg=[];
%         cfg.viewmode = 'vertical';
%         cfg.continuous = 'yes';
%         cfg.blocksize = 30;
%         ft_databrowser(cfg,D);
%         
%         
%         badch = input('Bad channel indexes:');
%         
%         close all;
%         
%         D.badch = badch;
%         D.state = 'notch_filt,ds2 1khz,lpf_400, hpf_2, badch detected';
%         save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'subcort/'...
%             filesep data_dir(which_session).name],'D','session_epoch','-v7.3');
%     end
% end

%data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/*_subcort.mat']);
data_dir = dir('/Users/Dengyu/Documents/Temp_data/v2/subcort/*_subcort.mat');

for total_session_idx = 1:length(data_dir)
    load([data_dir(total_session_idx).folder filesep data_dir(total_session_idx).name]);
    
%     cfg=[];
%     cfg.viewmode = 'vertical';
%     cfg.continuous = 'yes';
%     cfg.blocksize = 30;
%     ft_databrowser(cfg,D);
%     
%     disp(data_dir(total_session_idx).name);
%     
%     badch = input('Bad channel indexes:');
    badch = [];
    
    close all
    D.badch = badch;
    D.state = 'notch_filt,ds2 1khz,lpf_400, hpf_2, badch detected';
%     save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort'...
%     filesep data_dir(total_session_idx).name],'D','session_epoch','-v7.3');

    save(['/Users/Dengyu/Documents/Temp_data/v2/subcort'...
    filesep data_dir(total_session_idx).name],'D','session_epoch','-v7.3');
end  