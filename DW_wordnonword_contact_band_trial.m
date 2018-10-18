% Created on 10/02/2018
% modified on 10/17/2018: add word/nonword trial_selection, annd add one
% data point to baseline and z (i.e, 1001 and 4001 data points, respectively)

% Aims to generate an average trial for each contact's each band (8), each
% locking selection (3), and either first 60 or entire 120 or word or
% nonword trials
% cue locking: -1.5 to 2.5; word locking: -2 to 2; vowel locking: -2 to 2

% load in VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat
% and VIM/datafiles/contact_loc/contact_info_step2.mat

% generated files are under VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity/

% specify machine to run
DW_machine;

% make sure use built-in filfilt and hilbert
rmpath(genpath([dropbox 'Functions/Dengyu/git/fieldtrip']));
rmpath(genpath([dropbox 'Functions/Dengyu/git/NPMK']));
rmpath(genpath([dropbox 'Functions/Dengyu/git/bml']));
rmpath(genpath([dropbox 'Functions/Dengyu/git/fieldtrip']));
rmpath(genpath('/Users/Dengyu/Downloads/spm12'));

% load in stat_table as a table reference, use the same row index
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

% load in contact_info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);
contact_info = struct2table(contact_info);

% band selection
band_selection = {'delta', 'theta', 'alpha','lowbeta','highbeta', 'beta', 'gamma', 'highgamma'};

% data sampling frequency
fs = 1000;

%filter load
load([dropbox,'Functions/Dengyu/Filter/bpFilt.mat']);

% use only ref data
ref_selection = {'ref'};

% loop through the rows of stat_table
for row_idx = 1:height(stat_table)
    
    clearvars -except alphaFilt band_selection beta1Filt beta2Filt betaFilt contact_info deltaFilt dionysis dropbox fs gammaFilt hgammaFilt ref_selection ...
        row_idx stat_table thetaFilt;
    
    contact_id = stat_table.contact_id(row_idx); % get contact_id
    
    % index of this contact in contact_info table
    contact_info_idx = find(contact_info.contact_id == contact_id);

    if length(contact_info.session{contact_info_idx}) == 1 % if this contact has only one session
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info.subject_id{contact_info_idx} '_session' num2str(contact_info.session{contact_info_idx}) '_subcort_trials_step4.mat']);
        
        % remove bad trials from trial, time and epoch
        D1 = D;
        D1.trial(:,D1.badtrial_final) = [];
        D1.time(D1.badtrial_final) = [];
        D1.epoch(D1.badtrial_final,:) = [];
        
        % find the channel of this contact
        which_ch = find(strcmp(contact_info.label{contact_info_idx},D1.label));
        
        D_used = [];
        
        D_used.trial = cellfun(@(x) x(which_ch,:),D1.trial(2,:),'UniformOutput',0); % ref only, ch_oi only
        D_used.epoch = D1.epoch;
        D_used.time = D1.time;
        
        clearvars D D1 which_ch;
        % get D_used for downstream analysis
        
    else % contact that has two sessions, should take up three rows {session1, session2, session 1 and 2 together}
        
        if length(stat_table.ith_session{row_idx}) == 1
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
                contact_info.subject_id{contact_info_idx} '_session' num2str(stat_table.ith_session{row_idx}) '_subcort_trials_step4.mat']);
            
            D1 = D;
            D1.trial(:,D1.badtrial_final) = [];
            D1.time(D1.badtrial_final) = [];
            D1.epoch(D1.badtrial_final,:) = [];
            
            which_ch = find(strcmp(contact_info.label{contact_info_idx},D1.label));
            
            D_used = [];
            
            D_used.trial = cellfun(@(x) x(which_ch,:),D1.trial(2,:),'UniformOutput',0); % ref only, ch_oi only
            D_used.epoch = D1.epoch;
            D_used.time = D1.time;   
            clearvars D D1 which_ch;
            
        else % combine session1 and session2 together
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
                contact_info.subject_id{contact_info_idx} '_session1_subcort_trials_step4.mat']);
            
            D1 = D;
            
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
                contact_info.subject_id{contact_info_idx} '_session2_subcort_trials_step4.mat']);
            D2 = D;
            
            D1.trial(:,D1.badtrial_final) = [];
            D1.time(D1.badtrial_final) = [];
            D1.epoch(D1.badtrial_final,:) = [];            
            
            D2.trial(:,D2.badtrial_final) = [];
            D2.time(D2.badtrial_final) = [];
            D2.epoch(D2.badtrial_final,:) = [];
            
            which_ch1 = find(strcmp(contact_info.label{contact_info_idx},D1.label));
            which_ch2 = find(strcmp(contact_info.label{contact_info_idx},D2.label));
            
            D_used = [];
            D_used.trial = [cellfun(@(x) x(which_ch1,:),D1.trial(2,:),'UniformOutput',0),cellfun(@(x) x(which_ch2,:),D2.trial(2,:),'UniformOutput',0)];
            D_used.epoch = [D1.epoch;D2.epoch];
            D_used.time = [D1.time, D2.time];
            
            clearvars D D1 D2 which_ch1 which_ch2
            
        end
    end
    
    clearvars signal
    
    % get signal for each band
    signal{1} = cellfun(@(x) abs(hilbert(filtfilt(deltaFilt,x')))',D_used.trial,'UniformOutput',0);
    signal{2} = cellfun(@(x) abs(hilbert(filtfilt(thetaFilt,x')))',D_used.trial,'UniformOutput',0);
    signal{3} = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x')))',D_used.trial,'UniformOutput',0);
    signal{4} = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x')))',D_used.trial,'UniformOutput',0);    
    signal{5} = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x')))',D_used.trial,'UniformOutput',0);
    signal{6} = cellfun(@(x) abs(hilbert(filtfilt(betaFilt,x')))',D_used.trial,'UniformOutput',0);
    signal{7} = cellfun(@(x) abs(hilbert(filtfilt(gammaFilt,x')))',D_used.trial,'UniformOutput',0);
    signal{8} = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x')))',D_used.trial,'UniformOutput',0);
    
    % trial inclusion selection
    inclusion_selection = {'120', '60', 'word', 'nonword'};
    inclusion_solution = {[1:length(D_used.trial)],find(D_used.epoch.trial_id <=60)'};
    inclusion_solution{3} = find(D_used.epoch.trial_id <=60 & mod(D_used.epoch.trial_id,2) == 0)';
    inclusion_solution{4} = find(D_used.epoch.trial_id <=60 & mod(D_used.epoch.trial_id,2) == 1)';
    
    %locking selection
    locking_selection = {'cue', 'sp', 'vowel'};
    
    % loop through bands
    for band_id = 1:length(band_selection)
        band_name = band_selection{band_id};
        
        % loop through inclusion selection
        for inclusion_id = 1:length(inclusion_selection)
            inclusion_name = inclusion_selection{inclusion_id};
            trials_included = inclusion_solution{inclusion_id};
            
            D_final = [];
            D_final.trial = signal{band_id}(trials_included);
            D_final.epoch = D_used.epoch(trials_included,:);
            D_final.time = D_used.time(trials_included);
            
            base_starts = num2cell(round((D_final.epoch.stimulus_starts - D_final.epoch.starts - 1) * fs)');
            base_ends = num2cell(round((D_final.epoch.stimulus_starts - D_final.epoch.starts) * fs)');
            
            bases = cellfun(@(x,y,z) x(y:z),D_final.trial, base_starts,base_ends,'UniformOutput',0);
            
            base = mean(cell2mat(bases')); % average base signal
            
            % cue centered, -1.5 to 2.5s
            
            roi_starts = num2cell(round((D_final.epoch.stimulus_starts - D_final.epoch.starts - 1.5) * fs)');
            roi_ends = num2cell(round((D_final.epoch.stimulus_starts - D_final.epoch.starts + 2.5) * fs)');
            
            datas = cellfun(@(x,y,z) x(y:z),D_final.trial,roi_starts,roi_ends,'UniformOutput',0);
            
            data = mean(cell2mat(datas')); % average trial
            
            z = (data - mean(base))  ./ std(base);
            
            if ~ismember(contact_id, [13:18]) % if is not DBS4039, should have average timing data
                avg_word_on = mean(D_final.epoch.onset_word - D_final.epoch.stimulus_starts);
                avg_vowel_on = mean(D_final.epoch.onset_vowel - D_final.epoch.stimulus_starts);
                avg_word_off = mean(D_final.epoch.offset_word - D_final.epoch.stimulus_starts);

                if length(stat_table.ith_session{row_idx}) == 1

                    save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity1/'...
                        'contact_' num2str(contact_id) '_session' num2str(stat_table.ith_session{row_idx})...
                        '_' band_name '_ref_cuect' '_' inclusion_name '.mat'],'z','avg_word_on','avg_vowel_on', 'avg_word_off');
                else
                    save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity1/'...
                        'contact_' num2str(contact_id) '_all_'...
                        band_name '_ref_cuect' '_' inclusion_name '.mat'],'z','avg_word_on','avg_vowel_on', 'avg_word_off');
                end
            else
                save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity1/'...
                    'contact_' num2str(contact_id) '_session' num2str(stat_table.ith_session{row_idx})...
                    '_' band_name '_ref_cuect' '_' inclusion_name '.mat'],'z');
            end
            
                    
                
            if ~ismember(contact_id, [13:18]) % if is not DBS4039, continue to get spct and vowel centered data
                
                    % sp centered, -2 to 2s
                roi_starts = num2cell(round((D_final.epoch.onset_word - D_final.epoch.starts - 2) * fs)');
                roi_ends = num2cell(round((D_final.epoch.onset_word - D_final.epoch.starts + 2) * fs)');

                datas = cellfun(@(x,y,z) x(y:z),D_final.trial,roi_starts,roi_ends,'UniformOutput',0);

                data = mean(cell2mat(datas'));

                z = (data - mean(base))  ./ std(base);

                avg_cue_on = mean(D_final.epoch.stimulus_starts - D_final.epoch.onset_word);
                avg_vowel_on = mean(D_final.epoch.onset_vowel - D_final.epoch.onset_word);
                avg_word_off = mean(D_final.epoch.offset_word - D_final.epoch.onset_word);
            
                if length(stat_table.ith_session{row_idx}) == 1

                    save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity1/'...
                        'contact_' num2str(contact_id) '_session' num2str(stat_table.ith_session{row_idx})...
                        '_' band_name '_ref_spct' '_' inclusion_name '.mat'],'z','avg_cue_on', 'avg_vowel_on', 'avg_word_off');
                else
                    save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity1/'...
                        'contact_' num2str(contact_id) '_all_'...
                        band_name '_ref_spct' '_' inclusion_name '.mat'],'z','avg_cue_on', 'avg_vowel_on', 'avg_word_off'); 
                end
                
                
                
                    % vowel onset centered, -2 to 2s
                roi_starts = num2cell(round((D_final.epoch.onset_vowel - D_final.epoch.starts - 2) * fs)');
                roi_ends = num2cell(round((D_final.epoch.onset_vowel - D_final.epoch.starts + 2) * fs)');

                datas = cellfun(@(x,y,z) x(y:z),D_final.trial,roi_starts,roi_ends,'UniformOutput',0);

                data = mean(cell2mat(datas'));

                z = (data - mean(base))  ./ std(base);

                avg_cue_on = mean(D_final.epoch.stimulus_starts - D_final.epoch.onset_vowel);
                avg_word_on = mean(D_final.epoch.onset_word - D_final.epoch.onset_vowel);
                avg_word_off = mean(D_final.epoch.offset_word - D_final.epoch.onset_vowel);
            
                if length(stat_table.ith_session{row_idx}) == 1

                    save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity1/'...
                        'contact_' num2str(contact_id) '_session' num2str(stat_table.ith_session{row_idx})...
                        '_' band_name '_ref_vowelct' '_' inclusion_name '.mat'],'z','avg_cue_on', 'avg_word_on', 'avg_word_off');
                else
                    save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity1/'...
                        'contact_' num2str(contact_id) '_all_'...
                        band_name '_ref_vowelct' '_' inclusion_name '.mat'],'z','avg_cue_on', 'avg_word_on', 'avg_word_off'); 
                end                
            end
        end
    end
end