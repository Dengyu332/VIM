% first created on 10/17/2018

% Aims to generate files as well as figures for each contact session with
% different locking property and different trial selection

% takes in files under VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_level_raw_trials/
% generate files under VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_spectrogram/
% generate figures under VIM/Results/New/v2/WordVsNonword/contact_spectrogram/

% specs 
DW_machine;
fs = 1000; fq = 2:2:200;
% one2one correspondence, each file is a raw trials of this contact_session
% with bad trials removed, 123 files in total
data_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_level_raw_trials/*.mat']);

% locking matrix
trial_selection = {'word', 'nonword', '60','120'}; % four trial_selection
locking_selection = {'cue','sp'};

for unit_idx = 1:length(data_dir)
    clearvars -except data_dir dionysis dropbox fq fs locking_selection trial_selection unit_idx
    load([data_dir(unit_idx).folder filesep data_dir(unit_idx).name]);
    
    % transformation
    signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),trials,'UniformOutput',0);
    % time X fq
    
    % define the trials in each trial_selection group
    trial_idx_lists{1} = find(mod(epoch.trial_id,2) == 0 & epoch.trial_id <=60)';
    trial_idx_lists{2} = find(mod(epoch.trial_id,2) == 1 & epoch.trial_id <=60)';
    trial_idx_lists{3} = find(epoch.trial_id <=60)';
    trial_idx_lists{4} = 1:height(epoch);
    
    % loop through trial_selection
    for group_id = 1:length(trial_selection)
        group_name = trial_selection{group_id};
        trial_idx_used = trial_idx_lists{group_id};
        % select signals and epochs of this group
        signal_oi = signal(trial_idx_used);
        epoch_oi = epoch(trial_idx_used,:);

        bases_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts - 1) * fs)');
        bases_ends = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs)');
        
        bases = cellfun(@(x,y,z) x(y:z,:),signal_oi,bases_starts,bases_ends,'UniformOutput',0); % 1 X numtrials
        
        mean_base = mean(cell2mat(reshape(bases,[1 1 size(bases,2)])),3);
        
        clearvars roi_starts roi_ends timing;
        if ~any(strcmp(data_dir(unit_idx).name(13:14), {'13','14','15','16','17','18'})) % if is not contact 13:18
            
            % cue centered, -1.5 to 2.5
            roi_starts(1,:) = num2cell(round((epoch_oi.stimulus_starts -  epoch_oi.starts - 1.5) * fs)');
            roi_ends(1,:) = num2cell(round((epoch_oi.stimulus_starts -  epoch_oi.starts + 2.5) * fs)');
            
            % sp centered, -2 to 2
            roi_starts(2,:) = num2cell(round((epoch_oi.onset_word -  epoch_oi.starts - 2) * fs)');
            roi_ends(2,:) = num2cell(round((epoch_oi.onset_word -  epoch_oi.starts + 2) * fs)');
            
            timing{1} = [mean(epoch_oi.onset_word - epoch_oi.stimulus_starts), mean(epoch_oi.offset_word - epoch_oi.stimulus_starts)];
            timing{2} = [mean(epoch_oi.stimulus_starts - epoch_oi.onset_word), mean(epoch_oi.offset_word - epoch_oi.onset_word)];
            
            t_starts = [-1.5, -2]; t_ends = [2.5, 2]; % time axes selection
            
            for locking_id = 1:length(locking_selection)
                locking_name = locking_selection{locking_id};
                
                data_roi = cellfun(@(x,y,z) x(y:z,:),signal_oi, roi_starts(locking_id,:), roi_ends(locking_id,:),'UniformOutput',0);
                
                mean_data = mean(cell2mat(reshape(data_roi,[1 1 size(data_roi,2)])),3);
                
                data_final = (mean_data - repmat(mean(mean_base, 1),[length(mean_data),1])) ...
                    ./ repmat(std(mean_base,0,1),[length(mean_data),1]);
                
                timing_oi = timing{locking_id};
                readme = 'normalized to baseline, which is 1s precue';
                % save data_final & timing_oi
                save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_spectrogram/'...
                    data_dir(unit_idx).name(1:end-4) '_' group_name '_' locking_name '.mat'], 'data_final', 'timing_oi', 'readme');
                
                % plot spectrogram and save
                t=linspace(t_starts(locking_id),t_ends(locking_id),4001);
                
                figure; colormap(jet)
                imagesc(t, fq, data_final(:,:)');set(gca, 'YDir', 'Normal');
                caxis([-10,10]); box on;
                
                hold on; plot([timing_oi(1),timing_oi(1)],ylim,'k--');
                plot([0,0],ylim,'k--'); 
                plot([timing_oi(2),timing_oi(2)],ylim,'k--');

                xlabel('Time (s)'); % x-axis label
                ylabel('Frequency (Hz)'); % y-axis label

                saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/WordVsNonword/contact_spectrogram/'...
                    data_dir(unit_idx).name(1:end-4) '_' group_name '_' locking_name]);
                close all;
            end
            
        else % 13-18, has only cue and no timing data
            
            roi_starts = num2cell(round((epoch_oi.stimulus_starts -  epoch_oi.starts - 1.5) * fs)');
            roi_ends = num2cell(round((epoch_oi.stimulus_starts -  epoch_oi.starts + 2.5) * fs)');
            
            data_roi = cellfun(@(x,y,z) x(y:z,:),signal_oi, roi_starts, roi_ends,'UniformOutput',0);
            mean_data = mean(cell2mat(reshape(data_roi,[1 1 size(data_roi,2)])),3);    
                
            data_final = (mean_data - repmat(mean(mean_base, 1),[length(mean_data),1])) ...
                ./ repmat(std(mean_base,0,1),[length(mean_data),1]);                
                
            readme = 'normalized to baseline, which is 1s precue';        
            save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_spectrogram/'...
                data_dir(unit_idx).name(1:end-4) '_' group_name '_cue.mat'], 'data_final', 'readme');
            
            t=linspace(-1.5,2.5,4001);

            figure; colormap(jet)
            imagesc(t, fq, data_final(:,:)');set(gca, 'YDir', 'Normal');
            caxis([-10,10]); box on;

            hold on;

            xlabel('Time (s)'); % x-axis label
            ylabel('Frequency (Hz)'); % y-axis label

            saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/WordVsNonword/contact_spectrogram/'...
                data_dir(unit_idx).name(1:end-4) '_' group_name '_cue']);
            close all;            
        end
    end
end     