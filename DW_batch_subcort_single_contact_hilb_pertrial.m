% first created on 08/26/2018
% inspect on 09/13/2018
% this script is used to generate for each contact (for contact having two
% sessions, generate one file for one session) a normalized, trial-base
% band activity, either ref or unref.

% follow DW_batch_CAR.m; takes in step3 data and contact_info_step2.mat
% generate contact_i_bandselection_refselection.mat under
% 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_pertrial_band_activity/'

%specify machine
DW_machine;

rmpath(genpath([dropbox 'Functions/Dengyu/git/fieldtrip']));
rmpath(genpath('/Users/Dengyu/Downloads/spm12'));
% make sure use matlab built-in filtfilt and hilbert function



% data sampling frequency
fs = 1000;

%filter load
load([dropbox,'Functions/Dengyu/Filter/bpFilt.mat']);

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% band selection and ref selection
band_selection = {'alpha','lowbeta','highbeta','highgamma'};
ref_selection = {'unref','ref'};

% loop through contact
for contact_id = 1:length(contact_info)

    contact_id
    clearvars -except alphaFilt band_selection beta1Filt beta2Filt Choice contact_id  contact_info ...
        deltaFilt dionysis dropbox fs gammaFilt hgammaFilt ref_selection thetaFilt;
    
    if length(contact_info(contact_id).session) == 1 % contacts which have only one session
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session) '_subcort_trials_step3.mat']);        
        
        % 1st: remove bad trials
        D1 = D;
        D1.trial(:,D1.badtrial_final) = [];
        D1.time(D1.badtrial_final) = [];
        D1.epoch(D1.badtrial_final,:) = [];
        
        % 2nd: find contact oi
        i_oi = find(strcmp(contact_info(contact_id).label,D1.label));
        
        % 3rd: extract data of contact oi and get D_used
        D_used = [];

        D_used.trial = cellfun(@(x) x(i_oi,:),D1.trial,'UniformOutput',0);

        D_used.epoch = D1.epoch;
        D_used.time = D1.time;
        
        % get frequency bands signals
        
        clearvars signal
        
        signal{1} = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x')))',D_used.trial,'UniformOutput',0);
        signal{2} = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x')))',D_used.trial,'UniformOutput',0);
        signal{3} = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x')))',D_used.trial,'UniformOutput',0);
        signal{4} = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x')))',D_used.trial,'UniformOutput',0);
        
        % loop through bands
        for band_id = 1:4
            band_name = band_selection{band_id};
            
            % loop through ref and unref            
            for ref_id = 1:2
                
                ref_name = ref_selection{ref_id};
                
                % so data oi is signal{band_id}(ref_id,:)
                
                % get the baseline for each trial (1s precue)
                % DBS4039: -2 precue - 3s post cue; others: -2 precue - 2
                % post speech off
                
                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                
                base1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                % convert each trial to z-scored signal, using baseline
                % just specified
                z_oi = cellfun(@(x,y) (y - mean(x)) ./ std(x,0,2),base1,signal{band_id}(ref_id,:),'UniformOutput',0);
                
                % z_oi represent the normalized activity of each trial for contact_i
                % band_name, ref_name
                
                epoch_oi = D_used.epoch;
                time_oi = D_used.time;
                readme = 'z_oi contains trials normalized to precue 1s baseline; timing parameters in epoch_oi';
                % z_oi, epoch_oi and time_oi are what we want, so store
                % them
                
                save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_pertrial_band_activity/'...
                    'contact_' num2str(contact_id) '_' band_name '_' ref_name], 'z_oi', 'epoch_oi', 'time_oi', 'readme', '-v7.3');
            end
        end
    else % contacts which have two sessions
        % strategy: seperate the two sessions
        
        for session_id = contact_info(contact_id).session
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(session_id) '_subcort_trials_step3.mat']);
            
            % 1st: remove bad trials
            D1 = D;
            D1.trial(:,D1.badtrial_final) = [];
            D1.time(D1.badtrial_final) = [];
            D1.epoch(D1.badtrial_final,:) = [];

            % 2nd: find contact oi
            i_oi = find(strcmp(contact_info(contact_id).label,D1.label));

            % 3rd: extract data of contact oi and get D_used
            D_used = [];

            D_used.trial = cellfun(@(x) x(i_oi,:),D1.trial,'UniformOutput',0);

            D_used.epoch = D1.epoch;
            D_used.time = D1.time;        
            
            % get frequency bands signals

            clearvars signal

            signal{1} = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x')))',D_used.trial,'UniformOutput',0);
            signal{2} = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x')))',D_used.trial,'UniformOutput',0);
            signal{3} = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x')))',D_used.trial,'UniformOutput',0);
            signal{4} = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x')))',D_used.trial,'UniformOutput',0);
            
            % loop through bands
            for band_id = 1:4
                band_name = band_selection{band_id};

                % loop through ref and unref            
                for ref_id = 1:2
                    ref_name = ref_selection{ref_id};
                    
                    % get the baseline for each trial (1s precue)
                    % DBS4039: -2 precue - 3s post cue; others: -2 precue - 2
                    % post speech off

                    roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1 * fs)';
                    roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';

                    base1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);        
        
                    % convert each trial to z-scored signal, using baseline
                    % just specified
                    z_oi = cellfun(@(x,y) (y - mean(x)) ./ std(x,0,2),base1,signal{band_id}(ref_id,:),'UniformOutput',0);                
                    % z_oi represent the normalized activity of each trial for contact_i
                   
                    % band_name, ref_name
                    epoch_oi = D_used.epoch;
                    time_oi = D_used.time;
                    readme = 'z_oi contains trials normalized to precue 1s baseline; timing parameters in epoch_oi';
                        % z_oi, epoch_oi and time_oi are what we want, so store
                        % them

                        save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_pertrial_band_activity/'...
                            'contact_' num2str(contact_id) '_' 'session' num2str(session_id) '_' band_name '_' ref_name], 'z_oi', 'epoch_oi', 'time_oi', 'readme', '-v7.3');
                end
            end
        end
    end
end                    