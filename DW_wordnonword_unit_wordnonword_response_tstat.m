% First created on 10/14/2018
% for each band & period combination, generate a table of word response
% tstat and nonword response tstat, respectively, for each unit

% takes in files under'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'
% use stat_table as template table
% generate 24 tables under VIM/datafiles/preprocessed_new/v2/WordVsNonword/UnitWordNonword_Response

% specify machine & define band and period selection
DW_machine;
band_selection = {'delta', 'theta', 'alpha','lowbeta','highbeta', 'beta', 'gamma', 'highgamma'};
period_selection = {'period1', 'period2', 'period3'};

% three possible periods
t_starts = [-0.5 0 -0.5]; t_ends = [0 0.5 0.5]; % relative to onset_word
t4039_starts = [0.5 1 0.5]; t4039_ends = [1 1.5 1.5]; % relative to cue onset, for DBS4039

ref_name  = 'ref';
fs = 1000;

% use stat_table as template table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

% loop through bands
for band_id = 1:length(band_selection)
    band_name = band_selection{band_id};
    % loop through periods
    for period_id = 1:length(period_selection)
        period_name = period_selection{period_id};
        
        % init table
        word_nonword_response_table = stat_table(:,1:4);
        
        % loop through units
        for row_idx = 1:height(word_nonword_response_table)
            clearvars -except band_id band_name band_selection dionysis dropbox fs period_id period_name period_selection ...
                ref_name stat_table t4039_ends t4039_starts t_ends t_starts word_nonword_response_table row_idx;
            contact_id = word_nonword_response_table.contact_id(row_idx);
            session = word_nonword_response_table.ith_session{row_idx}; % matrix
            
            % load in possible files of this contact & this band and ref
            data_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
                'contact_' num2str(contact_id) '_*' band_name '_ref.mat']);
            if length(data_dir) == 1 % one-session contact
                load([data_dir.folder filesep data_dir.name]);              
            else % two-session contact
                if length(session) == 1 % not combine two sessions
                    load([data_dir(session).folder filesep data_dir(session).name])
                else % combine two sessions
                    load([data_dir(1).folder filesep data_dir(1).name]) % session1
                    z1 = z_oi; epoch1 = epoch_oi;
                    load([data_dir(2).folder filesep data_dir(2).name]) % session2
                    z2 = z_oi; epoch2 = epoch_oi;
                    z_oi = [z1,z2]; epoch_oi = [epoch1;epoch2];
                    clearvars z1 z2 epoch1 epoch2
                end
            end % get z_oi and epoch_oi
            
            base_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts - 1) * fs + 1)');
            base_ends = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs)');
            bases = cellfun(@(x,y,z) x(y:z),z_oi,base_starts,base_ends,'UniformOutput',0);   
            
            % get trial region of interest 
            if ~ismember(contact_id, [13:18]) % not DBS4039
                trials_starts = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + t_starts(period_id)) * fs + 1)');
                trials_ends = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + t_ends(period_id)) * fs)');
            else
                trials_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + t4039_starts(period_id)) * fs + 1)');
                trials_ends = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + t4039_ends(period_id)) * fs)');
            end            
            trials = cellfun(@(x,y,z) x(y:z),z_oi,trials_starts,trials_ends,'UniformOutput',0);
            
            word_idx = find(epoch_oi.trial_id <= 60 & (~mod(epoch_oi.trial_id,2)));
            nonword_idx = find(epoch_oi.trial_id <= 60 & (mod(epoch_oi.trial_id,2)));   

            word_trials = trials(word_idx); word_bases = bases(word_idx);
            nonword_trials = trials(nonword_idx); nonword_bases = bases(nonword_idx);
            
            % get one value for each trial
            word_trials_means = cell2mat(cellfun(@(x) mean(x),word_trials,'UniformOutput',0))';
            word_bases_means = cell2mat(cellfun(@(x) mean(x),word_bases,'UniformOutput',0))';
            nonword_trials_means = cell2mat(cellfun(@(x) mean(x),nonword_trials,'UniformOutput',0))';
            nonword_bases_means = cell2mat(cellfun(@(x) mean(x),nonword_bases,'UniformOutput',0))';  
            
            [~,~,~,stat]= ttest(word_trials_means , word_bases_means);
            word_nonword_response_table.word(row_idx) = stat.tstat;

            [~,~,~,stat]= ttest(nonword_trials_means , nonword_bases_means);
            word_nonword_response_table.nonword(row_idx) = stat.tstat;
        end
        readme = ['ref_' band_name '_' period_name ', table of word vs. base and nonword vs base tstat, respectively, for each unit'];
        save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/UnitWordNonword_Response/' ...
            'ref_' band_name '_' period_name '.mat'],'word_nonword_response_table','readme');
    end
end