%follow DW_batch_check_coding
%This script loops through all thalamic pilot patients
%ft_raw_session_new.mat data,pick out subcortical recording and ecog recording separately, 
%and divide data by session (also remove fuitle channels of the session)
% generate *_session*_subcort.mat and *_session*_ecog.mat files

% set machine
DW_machine;
%% loading packages
rmpath(genpath([dropbox,'Functions/Dengyu/git/fieldtrip']));
addpath([dropbox,'Functions/Dengyu/git/fieldtrip']);
ft_defaults;
bml_defaults;
%read in subject list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);

%     mkdir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/','subcort']);
%     mkdir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/','ecog']);

for Subject_idx = 1:height(Subject_list) % loop through all the thalamic pilot subjects
    
    Subject_id = cell2mat(Subject_list.Subject_id(Subject_idx));
    

    
    
    data_dir = dir([dionysis,'DBS/',...
    Subject_id,'/Preprocessed Data/FieldTrip/*_ft_raw_session_new.mat']); % direct to source data

    load([data_dir.folder,filesep,data_dir.name]); % load D.mat
    
    for which_session = 1:length(D.trial); % deal with one session at a time
        ecog_ch_idx = find(strcmp('ecog',cellfun(@(x) x(1:4),D.label,'UniformOutput',0))); % ecog channels
        
        lead_ch_idx = find(strcmp('dbs',cellfun(@(x) x(1:3),D.label,'UniformOutput',0))); % lead channels
        
        if length(lead_ch_idx) >4 && which_session == 1 % for left side, remove null 'right side' lead contacts
            lead_ch_idx = lead_ch_idx(1:4);
        end
        
        macro_ch_idx = find(strcmp('macro',cellfun(@(x) x(1:5),D.label,'UniformOutput',0))); % macro channels
        
        
        % first get ecog
        %test if there is ecog
        if isempty(ecog_ch_idx)
        else % only generate D_ecog if there are ecog channels
            
            D_ecog.label = D.label(ecog_ch_idx);% extract ecog
            D_ecog.time(1) = D.time(which_session);
            D_ecog.trial{1} = D.trial{which_session}(ecog_ch_idx,:); 
            D_ecog.cfg = D.cfg; % just copy
            
            %make hdr for D_ecog
            hdr = [];
            hdr.Fs=1000;
            hdr.nChans=length(D_ecog.label);
            hdr.nSamples=sum(cellfun(@(x)size(x,2),D_ecog.trial));
            hdr.nSamplesPre=0;
            hdr.nTrials=length(D_ecog.trial);
            hdr.label=D_ecog.label;
            hdr.chantype=split(D_ecog.label,'_');
            hdr.chantype=hdr.chantype(:,1);
            hdr.chanunit=repmat({'uV'},size(D_ecog.trial{1},1),1);
            
            D_ecog.hdr = hdr;
            % done with D_ecog
            
            D_ecog.side = 'L';
            if strcmp('DBS4040',Subject_id)
                D_ecog.side = 'R';
            elseif (any(strcmp(Subject_list.Subject_id(7:13),Subject_id))) && (which_session == 2)
                D_ecog.side = 'L';
            end
                
            
            
            % save
            D_backup = D;
            D =D_ecog;
            session_epoch = loaded_epoch(which_session,:);
%             save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/ecog/'...
%                 Subject_id '_session' num2str(which_session) '_ecog.mat'],'D','session_epoch','-v7.3')
            save(['/Users/Dengyu/Documents/Temp_data/v2/ecog/' ...
                Subject_id '_session' num2str(which_session) '_ecog.mat'],'D','session_epoch','-v7.3');
            
            D = D_backup;
        end
        
        % subcortical channels
        if isempty([lead_ch_idx;macro_ch_idx])
        else
            D_subcortical.label = D.label([lead_ch_idx;macro_ch_idx]);% extract subcortical signal
            D_subcortical.time(1) = D.time(which_session);
            D_subcortical.trial{1} = D.trial{which_session}([lead_ch_idx;macro_ch_idx],:);
            D_subcortical.cfg = D.cfg; % just copy
            
            %make hdr for D_subcortical
            hdr = [];
            hdr.Fs=1000;
            hdr.nChans=length(D_subcortical.label);
            hdr.nSamples=sum(cellfun(@(x)size(x,2),D_subcortical.trial));
            hdr.nSamplesPre=0;
            hdr.nTrials=length(D_subcortical.trial);
            hdr.label=D_subcortical.label;
            hdr.chantype=split(D_subcortical.label,'_');
            hdr.chantype=hdr.chantype(:,1);
            hdr.chanunit=repmat({'uV'},size(D_subcortical.trial{1},1),1);
           
            D_subcortical.hdr = hdr;
            % done with D_subcortical
            
            D_backup = D;
            D =D_subcortical;
            session_epoch = loaded_epoch(which_session,:);
%             save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
%                 Subject_id '_session' num2str(which_session) '_subcort.mat'],'D','session_epoch','-v7.3')
            save(['/Users/Dengyu/Documents/Temp_data/v2/subcort/' ...
                Subject_id '_session' num2str(which_session) '_subcort.mat'],'D','session_epoch','-v7.3');
            
            D = D_backup;
        end
        clearvars -except Choice dionysis dropbox Subject_list Subject_idx Subject_id D which_session loaded_epoch data_dir;
        
    end
end