% first created on 09/28/2018
% modified on 10/02/2018: add beta band (12-30 Hz)

% This script is for WordVsNonword analysis
% This script is adapted from DW_batch_subcort_single_contact_hilb_pertrial.m

% Generate for each contact (for contact having two
% sessions, generate one file for one session) a badtrial-removed, normalized, trial-base
% band activity, ref only

% follow DW_redefine_badtrial.m; takes in step4 data and contact_info_step2.mat
% generate contact_i_bandselection_refselection.mat under Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity

%specify machine
DW_machine;

% make sure use matlab built-in filtfilt and hilbert function
rmpath(genpath([dropbox 'Functions/Dengyu/git/fieldtrip']));
rmpath(genpath([dropbox 'Functions/Dengyu/git/NPMK']));
rmpath(genpath([dropbox 'Functions/Dengyu/git/bml']));
rmpath(genpath([dropbox 'Functions/Dengyu/git/fieldtrip']));
rmpath(genpath('/Users/Dengyu/Downloads/spm12'));

% data sampling frequency
fs = 1000;

%filter load
load([dropbox,'Functions/Dengyu/Filter/bpFilt.mat']);

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% band selection and ref selection
band_selection = {'delta', 'theta', 'alpha','lowbeta','highbeta','beta', 'gamma', 'highgamma'};
ref_selection = {'ref'};

% loop through contact
for contact_id = 1:length(contact_info)

    contact_id
    clearvars -except alphaFilt band_selection beta1Filt beta2Filt betaFilt contact_id contact_info ...
        deltaFilt dionysis dropbox fs gammaFilt hgammaFilt ref_selection thetaFilt;
    
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

        D_used.epoch = D1.epoch;
        D_used.time = D1.time;
        
        % get frequency bands signals
        
        clearvars signal
        
        signal{1} = cellfun(@(x) abs(hilbert(filtfilt(deltaFilt,x')))',D_used.trial,'UniformOutput',0);
        signal{2} = cellfun(@(x) abs(hilbert(filtfilt(thetaFilt,x')))',D_used.trial,'UniformOutput',0);
        signal{3} = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x')))',D_used.trial,'UniformOutput',0);
        signal{4} = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x')))',D_used.trial,'UniformOutput',0);
        signal{5} = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x')))',D_used.trial,'UniformOutput',0);
        signal{6} = cellfun(@(x) abs(hilbert(filtfilt(betaFilt,x')))',D_used.trial,'UniformOutput',0);        
        signal{7} = cellfun(@(x) abs(hilbert(filtfilt(gammaFilt,x')))',D_used.trial,'UniformOutput',0);
        signal{8} = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x')))',D_used.trial,'UniformOutput',0);
        
        % loop through bands
        for band_id = 1:8
            band_name = band_selection{band_id};
            
            % use only ref data         
            for ref_id = 1
                
                ref_name = ref_selection{ref_id};

                % get the baseline for each trial (1s precue)
                % DBS4039: -2 precue - 3s post cue; others: -2 precue - 2
                % post speech off
                
                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1 * fs + 1)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                
                base1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id},roi_starts,roi_ends,'UniformOutput',0);
                
                % convert each trial to z-scored signal, using baseline
                % just specified
                z_oi = cellfun(@(x,y) (y - mean(x)) ./ std(x,0,2),base1,signal{band_id},'UniformOutput',0);
                
                % z_oi represent the normalized activity of each trial for contact_i
                % band_name, ref_name
                
                epoch_oi = D_used.epoch;
                time_oi = D_used.time;
                readme = 'z_oi contains trials normalized to precue 1s baseline; timing parameters in epoch_oi';
                % z_oi, epoch_oi and time_oi are what we want, so store
                % them
                
                save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
                    'contact_' num2str(contact_id) '_' band_name '_' ref_name], 'z_oi', 'epoch_oi', 'time_oi', 'readme', '-v7.3');
            end
        end
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

            D_used.epoch = D1.epoch;
            D_used.time = D1.time;        
            
            % get frequency bands signals

            clearvars signal

            signal{1} = cellfun(@(x) abs(hilbert(filtfilt(deltaFilt,x')))',D_used.trial,'UniformOutput',0);
            signal{2} = cellfun(@(x) abs(hilbert(filtfilt(thetaFilt,x')))',D_used.trial,'UniformOutput',0);
            signal{3} = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x')))',D_used.trial,'UniformOutput',0);
            signal{4} = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x')))',D_used.trial,'UniformOutput',0);
            signal{5} = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x')))',D_used.trial,'UniformOutput',0);
            signal{6} = cellfun(@(x) abs(hilbert(filtfilt(betaFilt,x')))',D_used.trial,'UniformOutput',0);            
            signal{7} = cellfun(@(x) abs(hilbert(filtfilt(gammaFilt,x')))',D_used.trial,'UniformOutput',0);
            signal{8} = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x')))',D_used.trial,'UniformOutput',0);
            
            % loop through bands
            for band_id = 1:8
                band_name = band_selection{band_id};

                % loop through ref and unref            
                for ref_id = 1
                    ref_name = ref_selection{ref_id};
                    
                    % get the baseline for each trial (1s precue)
                    % DBS4039: -2 precue - 3s post cue; others: -2 precue - 2
                    % post speech off

                    roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1 * fs + 1)';
                    roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';

                    base1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id},roi_starts,roi_ends,'UniformOutput',0);        
        
                    % convert each trial to z-scored signal, using baseline
                    % just specified
                    z_oi = cellfun(@(x,y) (y - mean(x)) ./ std(x,0,2),base1,signal{band_id},'UniformOutput',0);                
                    % z_oi represent the normalized activity of each trial for contact_i
                   
                    % band_name, ref_name
                    epoch_oi = D_used.epoch;
                    time_oi = D_used.time;
                    readme = 'z_oi contains trials normalized to precue 1s baseline; timing parameters in epoch_oi';
                        % z_oi, epoch_oi and time_oi are what we want, so store
                        % them

                        save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
                            'contact_' num2str(contact_id) '_' 'session' num2str(session_id) '_' band_name '_' ref_name], 'z_oi', 'epoch_oi', 'time_oi', 'readme', '-v7.3');
                end
            end
        end
    end
end                    