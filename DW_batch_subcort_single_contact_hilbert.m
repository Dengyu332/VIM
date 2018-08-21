% first create 07/26/2018
%% follow DW_batch_CAR; takes in step3 data files
% generate band activity for each contact, each band, either ref or unref
% contact_i_alpha/lowbeta/highbeta/highgamma_ref/unref_cuect/spct.mat

%specify machine
DW_machine;

% remove fieldtrip package to make sure that we use built-in filtfilt and hilbert 
rmpath(genpath([dropbox 'Functions/Dengyu/git/fieldtrip']));



% data sampling frequency
fs = 1000;

%filter load
load([dropbox,'Functions/Dengyu/Filter/bpFilt.mat']);

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% band selection and ref selection
band_selection = {'alpha','lowbeta','highbeta','highgamma'};

ref_selection = {'unref','ref'};

% loop through contacts
for contact_id = 1:length(contact_info)
    
    contact_id
    clearvars -except alphaFilt band_selection beta1Filt beta2Filt Choice contact_id  contact_info ...
        deltaFilt dionysis dropbox fs gammaFilt hgammaFilt ref_selection thetaFilt;
    
    if ismember(contact_id,[13:18])  % treat DBS4039 seperately
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session) '_subcort_trials_step3.mat']);
        
        D1 = D;
        D1.trial(:,D1.badtrial_final) = [];
        D1.time(D1.badtrial_final) = [];
        D1.epoch(D1.badtrial_final,:) = [];
        
        i_oi = find(strcmp(contact_info(contact_id).label,D1.label));
        
        D_used = [];
        
        D_used.trial = cellfun(@(x) x(i_oi,:),D1.trial,'UniformOutput',0);
        
        D_used.epoch = D1.epoch;
        
        D_used.time = D1.time;
        
        
        clearvars D D1 D2 i1_oi i2_oi
        
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
                
                % get baseline, which is define as 1s precue
                clearvars roi_starts roi_ends base1 base;
                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                
                base1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                base = mean(cell2mat(reshape(base1,[1,1,size(base1,2)])),3);
                
                % cue centered, -1.5 to 2.5
                
                clearvars roi_starts roi_ends data_1 data_oi z avg_word_on avg_word_off readme;

                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1.5 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) + 2.5 * fs)';
                
                data_1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                data_oi = mean(cell2mat(reshape(data_1,[1,1,size(data_1,2)])),3);
                
                z = (data_oi - mean(base))  / std(base);

                
                readme = [ref_name,', cue centered, -1.5 to 2.5 peri cue onset, 1s prior to cue as baseline'];
                
                save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/' 'contact_' num2str(contact_id) '_' band_name '_' ref_name '_cuect.mat'],'z','readme');

            end
        end        
        
        
        
        
        
        
    else % ordinary contacts
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
            
        else % contacts which have two sessions
            
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session(1)) '_subcort_trials_step3.mat']);
            D1 = D;
            
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session(2)) '_subcort_trials_step3.mat']);
            D2 = D;
            
            % 1st: remove bad trials
            
            D1.trial(:,D1.badtrial_final) = [];
            D1.time(D1.badtrial_final) = [];
            D1.epoch(D1.badtrial_final,:) = [];            
            
            D2.trial(:,D2.badtrial_final) = [];
            D2.time(D2.badtrial_final) = [];
            D2.epoch(D2.badtrial_final,:) = [];    
            
            % 2nd: find contact oi
            
            i1_oi = find(strcmp(contact_info(contact_id).label,D1.label));

            i2_oi = find(strcmp(contact_info(contact_id).label,D2.label));
            
            % 3rd: extract data of contact oi and get D_used
            D_used = [];
            
            D_used.trial = [cellfun(@(x) x(i1_oi,:),D1.trial,'UniformOutput',0),cellfun(@(x) x(i2_oi,:),D2.trial,'UniformOutput',0)];
            
            D_used.epoch = [D1.epoch;D2.epoch];
            
            D_used.time = [D1.time, D2.time];
        end % D_used got
        
        clearvars D D1 D2 i1_oi i2_oi
        
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
                
                % get baseline, which is define as 1s precue
                clearvars roi_starts roi_ends base1 base;
                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                
                base1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                base = mean(cell2mat(reshape(base1,[1,1,size(base1,2)])),3);
                
                % cue centered, -1.5 to 2.5
                
                clearvars roi_starts roi_ends data_1 data_oi z avg_word_on avg_word_off readme;

                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1.5 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) + 2.5 * fs)';
                
                data_1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                data_oi = mean(cell2mat(reshape(data_1,[1,1,size(data_1,2)])),3);
                
                z = (data_oi - mean(base))  / std(base);
                
                avg_word_on = mean(D_used.epoch.onset_word - D_used.epoch.stimulus_starts);
                avg_word_off = mean(D_used.epoch.offset_word - D_used.epoch.stimulus_starts);
                
                readme = [ref_name,', cue centered, -1.5 to 2.5 peri cue onset, 1s prior to cue as baseline'];
                
                save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/' 'contact_' num2str(contact_id) '_' band_name '_' ref_name '_cuect.mat'],'z','avg_word_on','avg_word_off','readme');
                
                % sp centered, -2 to 2s
                
                clearvars roi_starts roi_ends data_1 data_oi z avg_word_on avg_word_off avg_cue readme;

                roi_starts = num2cell(round(fs*(D_used.epoch.onset_word - D_used.epoch.starts)) - 2 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.onset_word - D_used.epoch.starts)) + 2 * fs)';
                
                data_1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                data_oi = mean(cell2mat(reshape(data_1,[1,1,size(data_1,2)])),3);
                
                z = (data_oi - mean(base))  / std(base);
                
                avg_cue = mean(D_used.epoch.stimulus_starts - D_used.epoch.onset_word);
                avg_word_off = mean(D_used.epoch.offset_word - D_used.epoch.onset_word);
                
                readme = [ref_name,', sp centered, -2 to 2 peri word onset, 1s prior to cue as baseline'];
                
                save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/' 'contact_' num2str(contact_id) '_' band_name '_' ref_name '_spct.mat'],'z','avg_cue','avg_word_off','readme');
                
            end
        end
    end
end