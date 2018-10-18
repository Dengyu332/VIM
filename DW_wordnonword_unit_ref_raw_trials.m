% First created on 10/16/2018

% Generate for each contact (for contact having two sessions, generate one 
% file for one session) a badtrial-removed, ref raw trials with epoch

% follow DW_redefine_badtrial.m; takes in step4 data and contact_info_step2.mat
% generate files under WordVsNonword/UnitWordNonword_Response

%specify machine
DW_machine;
% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);
% ref only
ref_selection = {'ref'};

for contact_id = 1:length(contact_info)
    contact_id
    clearvars -except contact_id contact_info dionysis dropbox ref_selection;
    
    if length(contact_info(contact_id).session) == 1 % contacts which have only one session
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session) '_subcort_trials_step4.mat']);       
        
        % 1st: remove bad trials
        D1 = D;
        D1.trial(:,D1.badtrial_final) = [];
        D1.time(D1.badtrial_final) = [];
        D1.epoch(D1.badtrial_final,:) = [];
        
        % 2nd: find contact oi
        i_oi = find(strcmp(contact_info(contact_id).label,D1.label));
        
        % 3rd: extract data of contact oi and get D_used
        D_used = [];

        D_used.trial = cellfun(@(x) x(i_oi,:),D1.trial(2,:),'UniformOutput',0); % only ref, and contact_oi trials are extracted        
        epoch = D1.epoch;
        trials = D_used.trial;
        readme = 'badtrial-removed, ref raw trials with epoch';
        save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_level_raw_trials/'...
            'ref_contact_' num2str(contact_id)], 'trials', 'epoch', 'readme', '-v7.3');
    else % contacts which have two sessions
        % strategy: seperate the two sessions
        for session_id = contact_info(contact_id).session
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(session_id) '_subcort_trials_step4.mat']);
            
            % 1st: remove bad trials
            D1 = D;
            D1.trial(:,D1.badtrial_final) = [];
            D1.time(D1.badtrial_final) = [];
            D1.epoch(D1.badtrial_final,:) = [];

            % 2nd: find contact oi
            i_oi = find(strcmp(contact_info(contact_id).label,D1.label));

            % 3rd: extract data of contact oi and get D_used
            D_used = [];

            D_used.trial = cellfun(@(x) x(i_oi,:),D1.trial(2,:),'UniformOutput',0); % only ref, and contact_oi trials are extracted        
            epoch = D1.epoch;
            trials = D_used.trial;
            readme = 'badtrial-removed, ref raw trials with epoch';
            save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_level_raw_trials/'...
                'ref_contact_' num2str(contact_id) '_session' num2str(session_id)], 'trials', 'epoch', 'readme', '-v7.3');
        end
    end
end        