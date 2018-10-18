% first created on 10/08/2018
% same as DW_wordnonword_generate_response_table except using paired-two
% sample t test

%specify machine
% DW_machine;
clear all; clc;
dionysis = '/Volumes/Nexus/';
dropbox = '/Users/Dengyu/Dropbox (Brain Modulation Lab)/';

% load in stat_table as a table reference
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

% band selection
band_selection = {'delta', 'theta', 'alpha','lowbeta','highbeta', 'beta', 'gamma', 'highgamma'};

fs = 1000;

speech_response_table = table();

% loop through the rows of stat_table
for row_idx = 1:height(stat_table)
    
    clearvars -except band_selection dionysis dropbox fs row_idx speech_response_table stat_table
    
    speech_response_table.contact_id(row_idx) = stat_table.contact_id(row_idx);
    speech_response_table.ith_session(row_idx) = stat_table.ith_session(row_idx);
    
    for band_id = 1:length(band_selection)
        
        band_name = band_selection{band_id};
        
        if length(speech_response_table.ith_session{row_idx}) > 1 % rows with two sessions
            load([dionysis ...
                'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/contact_'...
                num2str(speech_response_table.contact_id(row_idx)) '_session1_' band_name '_ref.mat']);
            epoch_oi1 = epoch_oi;
            z_oi1 = z_oi;
            load([dionysis ...
                'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/contact_'...
                num2str(speech_response_table.contact_id(row_idx)) '_session2_' band_name '_ref.mat']);
            
            epoch_oi2 = epoch_oi;
            z_oi2 = z_oi;
            
            epoch_oi = vertcat(epoch_oi1, epoch_oi2);
            z_oi = [z_oi1, z_oi2]; % get
            
        else % rows with one session
            data_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/contact_'...
                num2str(speech_response_table.contact_id(row_idx)) '_*' band_name '_ref.mat']);
            if length(data_dir) == 1
                load([data_dir.folder filesep data_dir.name]);
            else
                load([data_dir(speech_response_table.ith_session{row_idx}).folder ...
                    filesep data_dir(speech_response_table.ith_session{row_idx}).name]);
            end
        end % done loading data
        
        % Get baseline val for each trial, which is 1s pre cue
        
        base_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts - 1) * fs + 1)');
        base_ends = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs)');
        
        base_signal = cellfun(@(x, y, z) x(y:z),z_oi, base_starts, base_ends,'UniformOutput',0);
        
        base_val = cell2mat(cellfun(@(x) mean(x),base_signal,'UniformOutput',0))'; % ntotaltrials X 1;
        
        % distinguish between DBS4039 and other subjects
        period_selection = {'period1', 'period2', 'period3'};
        % period1 is 0.5s post-spon, period2 is -0.5-0.5s peri-spon, period3 is cueon to spoff
        % DBS4039: 1-1.5s post cueon, 0.5-1.5 post cueon, 0-1.5 post cueon, respectively
        clearvars roi_starts roi_ends;
        if ismember(speech_response_table.contact_id(row_idx), [13:18])
            
            roi_starts(1,:) = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + 1) * fs + 1)');
            roi_ends(1,:) = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + 1.5) * fs)');
            
            roi_starts(2,:) = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + 0.5) * fs + 1)');
            roi_ends(2,:) = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + 1.5) * fs)');
            
            roi_starts(3,:) = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs + 1)');
            roi_ends(3,:) = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + 1.5) * fs)');
        else
            roi_starts(1,:) = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs + 1)');
            roi_ends(1,:) = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 0.5) * fs)');
            
            roi_starts(2,:) = num2cell(round((epoch_oi.onset_word - epoch_oi.starts - 0.5) * fs + 1)');
            roi_ends(2,:) = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 0.5) * fs)');
            
            roi_starts(3,:) = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs + 1)');
            roi_ends(3,:) = num2cell(round((epoch_oi.offset_word - epoch_oi.starts) * fs)');
        end
        
        inclusion_selection = {'120', '60'};
        
        inclusion_solution = {[1:length(z_oi)],find(epoch_oi.trial_id <=60)'};
        
        for period_id = 1:length(period_selection)
            
            period_name = period_selection{period_id};
            starts_used = roi_starts(period_id,:); ends_used = roi_ends(period_id,:);
            for inclusion_id = 1:length(inclusion_selection)
                
                inclusion_name = inclusion_selection{inclusion_id};
                trials_included = inclusion_solution{inclusion_id};
                
                z_final = z_oi(trials_included);
                starts_final = starts_used(trials_included); ends_final = ends_used(trials_included);
                
                temp = cellfun(@(x,y,z) x(y:z),z_final, starts_final, ends_final,'UniformOutput',0);
                T_final = cell2mat(cellfun(@(x) mean(x), temp,'UniformOutput',0))';
                
                base_final = base_val(trials_included);
                
                %paired-sample ttest
                [~,p2] = ttest(T_final, base_final,'Tail','right');
                [~,p3] = ttest(T_final, base_final,'Tail','left');
                
                speech_response_table{row_idx, ['ref_' band_name '_' period_name '_' inclusion_name '_p']} = min(p2,p3);
                
                if min(p2,p3) > 0.05
                    speech_response_table{row_idx,['ref_' band_name '_' period_name '_' inclusion_name '_h']} = 0;
                elseif p2<p3
                    speech_response_table{row_idx,['ref_' band_name '_' period_name '_' inclusion_name '_h']} = 1;
                else
                    speech_response_table{row_idx,['ref_' band_name '_' period_name '_' inclusion_name '_h']} = -1;
                end
                
            end
        end
    end
end

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table_t.mat'],'speech_response_table','-v7.3');