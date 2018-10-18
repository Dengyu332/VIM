% Created on 10/10
% focus on highgamma, 0.5s post sp
% quantify word trials and nonword trials response activity, respectively
% statistical method: paired-two sample ttest resulting in t-stat

% get word_nonword_response_table

DW_machine;

band_name = 'highgamma';
period_name = 'period2'; % 0.5s post sp (1-1.5 post cue for DBS4039)
ref_name  = 'ref';
fs = 1000;

% use as reference
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

word_nonword_response_table = stat_table(:,1:4);
for row_idx = 1:height(word_nonword_response_table)
    
    clearvars -except band_name dionysis dropbox fs period_name ref_name row_idx  stat_table word_nonword_response_table
    
    contact_id = word_nonword_response_table.contact_id(row_idx);
    session = word_nonword_response_table.ith_session{row_idx}; % matrix
    data_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_*highgamma_ref.mat']);
    if length(data_dir) == 1 % one-session contact
        load([data_dir.folder filesep data_dir.name])
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
    end
    
    base_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts - 1) * fs + 1)');
    base_ends = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs)');
    
    bases = cellfun(@(x,y,z) x(y:z),z_oi,base_starts,base_ends,'UniformOutput',0);
    
    % get trials
    if ~ismember(contact_id, [13:18])
        trials_starts = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs + 1)');
        trials_ends = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 0.5) * fs)');
        
    else
        trials_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + 1) * fs + 1)');
        trials_ends = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts + 1.5) * fs)');
    end
    
    trials = cellfun(@(x,y,z) x(y:z),z_oi,trials_starts,trials_ends,'UniformOutput',0);
    
    word_idx = find(epoch_oi.trial_id <= 60 & (~mod(epoch_oi.trial_id,2)));
    nonword_idx = find(epoch_oi.trial_id <= 60 & (mod(epoch_oi.trial_id,2)));   
    
    word_trials = trials(word_idx); word_bases = bases(word_idx);
    nonword_trials = trials(nonword_idx); nonword_bases = bases(nonword_idx);
    
    word_trials_means = cell2mat(cellfun(@(x) mean(x),word_trials,'UniformOutput',0))';
    word_bases_means = cell2mat(cellfun(@(x) mean(x),word_bases,'UniformOutput',0))';
    nonword_trials_means = cell2mat(cellfun(@(x) mean(x),nonword_trials,'UniformOutput',0))';
    nonword_bases_means = cell2mat(cellfun(@(x) mean(x),nonword_bases,'UniformOutput',0))';
    
     [~,~,~,stat]= ttest(word_trials_means , word_bases_means);
     word_nonword_response_table.word(row_idx) = stat.tstat;
     
     [~,~,~,stat]= ttest(nonword_trials_means , nonword_bases_means);
     word_nonword_response_table.nonword(row_idx) = stat.tstat;
end

readme = 'ref_highgamma_period2 only (0.5s post sp), word trial and nonword trial response, respectively; paired-ttest, giving tstat';
save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/word_nonword_response_table.mat'],'word_nonword_response_table','readme');