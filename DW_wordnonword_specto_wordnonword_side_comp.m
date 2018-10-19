% created on 10/16/2018
% generate spectrogram comparing word vs. nonword selectiviy between left
% and right

% four chunks: lead_left, lead_right, hgSigUp_lead_left and
% hgSigUp_lead_right

% Main concerns: 1. normalize after grand average using grand baseline; 2.
% didn't tear session 1 and session2 of left side apart

% generate figures under VIM/Results/New/v2/WordVsNonword/selectivity_interim

% parameters setup
DW_machine;
fq = 2:2:200; fs = 1000;

% load in contact_info table
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);
contact_info = struct2table(contact_info);

% load in speech_response_table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table.mat']);
% remove combined-session rows
unique_contact = unique(speech_response_table.contact_id);
hasi = 0;
discard_idx = [];
for i = 1:length(unique_contact)
    contact_i = unique_contact(i);
    temp = find(speech_response_table.contact_id == contact_i);
    if length(temp) == 1
    else
        hasi = hasi + 1;
    discard_idx(hasi) =  temp(3);
    end
end
speech_response_table(discard_idx,:) = [];

% find lead_left_idx
lead_left_list = setdiff(find(strcmp(speech_response_table.side,'left')),1:39)';
lead_right_list = setdiff(find(strcmp(speech_response_table.side,'right')),1:39)';

% left first
trialWord = [];
trialNonword = [];
baseWord = [];
baseNonword = [];
counter = 0;
for idx = lead_left_list
    clearvars -except baseNonword baseWord contact_info counter dionysis dropbox fq fs idx lead_left_list lead_right_list speech_response_table ...
        trialNonword trialWord;
    
    counter = counter + 1;
    subject_id = speech_response_table.subject_id{idx}; % str
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    label = contact_info.label{find(contact_info.contact_id == contact_id)}; % str
    % load in data
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
    subject_id '_session' num2str(session_id) '_subcort_trials_step4.mat']);
    % remove bad trials from trial, time and epoch
    D1 = D;
    D1.trial(:,D1.badtrial_final) = [];
    D1.time(D1.badtrial_final) = [];
    D1.epoch(D1.badtrial_final,:) = [];
    which_row = find(strcmp(label,D1.label));
    trials_oi = cellfun(@(x) x(which_row,:),D1.trial(2,:),'UniformOutput',0);
    epoch_oi = D1.epoch;
    signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),trials_oi,'UniformOutput',0);
    % each cell is time X fq
    
    bases_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts - 1) * fs + 1))';
    bases_ends =  num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs))';

    % spct, -2 to 2
    roi_starts = num2cell(round((epoch_oi.onset_word - epoch_oi.starts - 2) * fs + 1))';
    roi_ends = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 2) * fs))';

    % get bases and signal_oi

    bases = cellfun(@(x,y,z) x(y:z,:),signal,bases_starts,bases_ends,'UniformOutput',0);
    signal_oi = cellfun(@(x,y,z) x(y:z,:),signal,roi_starts,roi_ends,'UniformOutput',0);

    % distinguish between word and nonword trials, starting from here
    word_idx =  find(mod(epoch_oi.trial_id,2)==0 & epoch_oi.trial_id<=60); % word index
    nonword_idx = find(mod(epoch_oi.trial_id,2)~=0 & epoch_oi.trial_id<=60); %nonword index

    % get average base and trial for word trials and nonword trials, respectively
    bases_word = bases(word_idx); trials_word = signal_oi(word_idx);
    bases_nonword = bases(nonword_idx); trials_nonword = signal_oi(nonword_idx);    

    OverallBase_word = mean(cell2mat(reshape(bases_word,[1 1 size(bases_word,2)])),3);
    OverallTrial_word = mean(cell2mat(reshape(trials_word,[1 1 size(trials_word,2)])),3);

    OverallBase_nonword = mean(cell2mat(reshape(bases_nonword,[1 1 size(bases_nonword,2)])),3);
    OverallTrial_nonword = mean(cell2mat(reshape(trials_nonword,[1 1 size(trials_nonword,2)])),3);
    
    trialWord{counter} = OverallTrial_word; trialNonword{counter} = OverallTrial_nonword;
    baseWord{counter} = OverallBase_word; baseNonword{counter} = OverallBase_nonword;
end 

trialWord_One = mean(cell2mat(reshape(trialWord,[1 1 size(trialWord,2)])),3);
baseWord_One = mean(cell2mat(reshape(baseWord,[1 1 size(baseWord,2)])),3);

trialNonword_One = mean(cell2mat(reshape(trialNonword,[1 1 size(trialNonword,2)])),3);
baseNonword_One = mean(cell2mat(reshape(baseNonword,[1 1 size(baseNonword,2)])),3);

word_final = (trialWord_One - repmat(mean(baseWord_One, 1),[length(trialWord_One),1])) ...
    ./ repmat(std(baseWord_One,0,1),[length(trialWord_One),1]);

nonword_final = (trialNonword_One - repmat(mean(baseNonword_One, 1),[length(trialNonword_One),1])) ...
    ./ repmat(std(baseNonword_One,0,1),[length(trialNonword_One),1]);

Diff = nonword_final - word_final;

figure; colormap(jet)

t=linspace(-2,2,size(Diff,1));
imagesc(t, fq, Diff(:,:)');set(gca, 'YDir', 'Normal');

caxis([-15,15]); box on;


%%%%%%%%%%%%%% then right

trialWord = [];
trialNonword = [];
baseWord = [];
baseNonword = [];
counter = 0;
for idx = lead_right_list
    clearvars -except baseNonword baseWord contact_info counter dionysis dropbox fq fs idx lead_left_list lead_right_list speech_response_table ...
        trialNonword trialWord;
    
    counter = counter + 1;
    subject_id = speech_response_table.subject_id{idx}; % str
    contact_id = speech_response_table.contact_id(idx);
    session_id = 2; % only session2 has right-side contacts 
    label = contact_info.label{find(contact_info.contact_id == contact_id)}; % str
    % load in data
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
    subject_id '_session' num2str(session_id) '_subcort_trials_step4.mat']);
    % remove bad trials from trial, time and epoch
    D1 = D;
    D1.trial(:,D1.badtrial_final) = [];
    D1.time(D1.badtrial_final) = [];
    D1.epoch(D1.badtrial_final,:) = [];
    which_row = find(strcmp(label,D1.label));
    trials_oi = cellfun(@(x) x(which_row,:),D1.trial(2,:),'UniformOutput',0);
    epoch_oi = D1.epoch;
    signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),trials_oi,'UniformOutput',0);
    % each cell is time X fq
    
    bases_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts - 1) * fs + 1))';
    bases_ends =  num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs))';

    % spct, -2 to 2
    roi_starts = num2cell(round((epoch_oi.onset_word - epoch_oi.starts - 2) * fs + 1))';
    roi_ends = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 2) * fs))';

    % get bases and signal_oi

    bases = cellfun(@(x,y,z) x(y:z,:),signal,bases_starts,bases_ends,'UniformOutput',0);
    signal_oi = cellfun(@(x,y,z) x(y:z,:),signal,roi_starts,roi_ends,'UniformOutput',0);

    % distinguish between word and nonword trials, starting from here
    word_idx =  find(mod(epoch_oi.trial_id,2)==0 & epoch_oi.trial_id<=60); % word index
    nonword_idx = find(mod(epoch_oi.trial_id,2)~=0 & epoch_oi.trial_id<=60); %nonword index

    % get average base and trial for word trials and nonword trials, respectively
    bases_word = bases(word_idx); trials_word = signal_oi(word_idx);
    bases_nonword = bases(nonword_idx); trials_nonword = signal_oi(nonword_idx);    

    OverallBase_word = mean(cell2mat(reshape(bases_word,[1 1 size(bases_word,2)])),3);
    OverallTrial_word = mean(cell2mat(reshape(trials_word,[1 1 size(trials_word,2)])),3);

    OverallBase_nonword = mean(cell2mat(reshape(bases_nonword,[1 1 size(bases_nonword,2)])),3);
    OverallTrial_nonword = mean(cell2mat(reshape(trials_nonword,[1 1 size(trials_nonword,2)])),3);
    
    trialWord{counter} = OverallTrial_word; trialNonword{counter} = OverallTrial_nonword;
    baseWord{counter} = OverallBase_word; baseNonword{counter} = OverallBase_nonword;
end 

trialWord_One = mean(cell2mat(reshape(trialWord,[1 1 size(trialWord,2)])),3);
baseWord_One = mean(cell2mat(reshape(baseWord,[1 1 size(baseWord,2)])),3);

trialNonword_One = mean(cell2mat(reshape(trialNonword,[1 1 size(trialNonword,2)])),3);
baseNonword_One = mean(cell2mat(reshape(baseNonword,[1 1 size(baseNonword,2)])),3);

word_final = (trialWord_One - repmat(mean(baseWord_One, 1),[length(trialWord_One),1])) ...
    ./ repmat(std(baseWord_One,0,1),[length(trialWord_One),1]);

nonword_final = (trialNonword_One - repmat(mean(baseNonword_One, 1),[length(trialNonword_One),1])) ...
    ./ repmat(std(baseNonword_One,0,1),[length(trialNonword_One),1]);

Diff = nonword_final - word_final;

figure; colormap(jet)

t=linspace(-2,2,size(Diff,1));
imagesc(t, fq, Diff(:,:)');set(gca, 'YDir', 'Normal');

caxis([-15,15]); box on;




%%%%%% SigUp

lead_left_list = setdiff(find(strcmp(speech_response_table.side,'left')),1:39)';
lead_right_list = setdiff(find(strcmp(speech_response_table.side,'right')),1:39)';

SigUp_list = find(speech_response_table.ref_highgamma_period2_120_p * height(speech_response_table) < 0.05 & speech_response_table.ref_highgamma_period2_120_h == 1);
SigUpLeadLeft = intersect(lead_left_list, SigUp_list)'; SigUpLeadRight = intersect(lead_right_list, SigUp_list)';

% left first
trialWord = [];
trialNonword = [];
baseWord = [];
baseNonword = [];
counter = 0;
for idx = SigUpLeadLeft
    clearvars -except baseNonword baseWord contact_info counter dionysis dropbox fq fs idx lead_left_list lead_right_list speech_response_table ...
        trialNonword trialWord SigUp_list SigUpLeadLeft SigUpLeadRight
    
    counter = counter + 1;
    subject_id = speech_response_table.subject_id{idx}; % str
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    label = contact_info.label{find(contact_info.contact_id == contact_id)}; % str
    % load in data
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
    subject_id '_session' num2str(session_id) '_subcort_trials_step4.mat']);
    % remove bad trials from trial, time and epoch
    D1 = D;
    D1.trial(:,D1.badtrial_final) = [];
    D1.time(D1.badtrial_final) = [];
    D1.epoch(D1.badtrial_final,:) = [];
    which_row = find(strcmp(label,D1.label));
    trials_oi = cellfun(@(x) x(which_row,:),D1.trial(2,:),'UniformOutput',0);
    epoch_oi = D1.epoch;
    signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),trials_oi,'UniformOutput',0);
    % each cell is time X fq
    
    bases_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts - 1) * fs + 1))';
    bases_ends =  num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs))';

    % spct, -2 to 2
    roi_starts = num2cell(round((epoch_oi.onset_word - epoch_oi.starts - 2) * fs + 1))';
    roi_ends = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 2) * fs))';

    % get bases and signal_oi

    bases = cellfun(@(x,y,z) x(y:z,:),signal,bases_starts,bases_ends,'UniformOutput',0);
    signal_oi = cellfun(@(x,y,z) x(y:z,:),signal,roi_starts,roi_ends,'UniformOutput',0);

    % distinguish between word and nonword trials, starting from here
    word_idx =  find(mod(epoch_oi.trial_id,2)==0 & epoch_oi.trial_id<=60); % word index
    nonword_idx = find(mod(epoch_oi.trial_id,2)~=0 & epoch_oi.trial_id<=60); %nonword index

    % get average base and trial for word trials and nonword trials, respectively
    bases_word = bases(word_idx); trials_word = signal_oi(word_idx);
    bases_nonword = bases(nonword_idx); trials_nonword = signal_oi(nonword_idx);    

    OverallBase_word = mean(cell2mat(reshape(bases_word,[1 1 size(bases_word,2)])),3);
    OverallTrial_word = mean(cell2mat(reshape(trials_word,[1 1 size(trials_word,2)])),3);

    OverallBase_nonword = mean(cell2mat(reshape(bases_nonword,[1 1 size(bases_nonword,2)])),3);
    OverallTrial_nonword = mean(cell2mat(reshape(trials_nonword,[1 1 size(trials_nonword,2)])),3);
    
    trialWord{counter} = OverallTrial_word; trialNonword{counter} = OverallTrial_nonword;
    baseWord{counter} = OverallBase_word; baseNonword{counter} = OverallBase_nonword;
end 

trialWord_One = mean(cell2mat(reshape(trialWord,[1 1 size(trialWord,2)])),3);
baseWord_One = mean(cell2mat(reshape(baseWord,[1 1 size(baseWord,2)])),3);

trialNonword_One = mean(cell2mat(reshape(trialNonword,[1 1 size(trialNonword,2)])),3);
baseNonword_One = mean(cell2mat(reshape(baseNonword,[1 1 size(baseNonword,2)])),3);

word_final = (trialWord_One - repmat(mean(baseWord_One, 1),[length(trialWord_One),1])) ...
    ./ repmat(std(baseWord_One,0,1),[length(trialWord_One),1]);

nonword_final = (trialNonword_One - repmat(mean(baseNonword_One, 1),[length(trialNonword_One),1])) ...
    ./ repmat(std(baseNonword_One,0,1),[length(trialNonword_One),1]);

Diff = nonword_final - word_final;

figure; colormap(jet)

t=linspace(-2,2,size(Diff,1));
imagesc(t, fq, Diff(:,:)');set(gca, 'YDir', 'Normal');

caxis([-15,15]); box on;


%%%%%%%%%%%%%% then right

trialWord = [];
trialNonword = [];
baseWord = [];
baseNonword = [];
counter = 0;
for idx = SigUpLeadRight
    clearvars -except baseNonword baseWord contact_info counter dionysis dropbox fq fs idx lead_left_list lead_right_list speech_response_table ...
        trialNonword trialWord SigUp_list SigUpLeadLeft SigUpLeadRight;
    
    counter = counter + 1;
    subject_id = speech_response_table.subject_id{idx}; % str
    contact_id = speech_response_table.contact_id(idx);
    session_id = 2; % only session2 has right-side contacts 
    label = contact_info.label{find(contact_info.contact_id == contact_id)}; % str
    % load in data
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
    subject_id '_session' num2str(session_id) '_subcort_trials_step4.mat']);
    % remove bad trials from trial, time and epoch
    D1 = D;
    D1.trial(:,D1.badtrial_final) = [];
    D1.time(D1.badtrial_final) = [];
    D1.epoch(D1.badtrial_final,:) = [];
    which_row = find(strcmp(label,D1.label));
    trials_oi = cellfun(@(x) x(which_row,:),D1.trial(2,:),'UniformOutput',0);
    epoch_oi = D1.epoch;
    signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),trials_oi,'UniformOutput',0);
    % each cell is time X fq
    
    bases_starts = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts - 1) * fs + 1))';
    bases_ends =  num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs))';

    % spct, -2 to 2
    roi_starts = num2cell(round((epoch_oi.onset_word - epoch_oi.starts - 2) * fs + 1))';
    roi_ends = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 2) * fs))';

    % get bases and signal_oi

    bases = cellfun(@(x,y,z) x(y:z,:),signal,bases_starts,bases_ends,'UniformOutput',0);
    signal_oi = cellfun(@(x,y,z) x(y:z,:),signal,roi_starts,roi_ends,'UniformOutput',0);

    % distinguish between word and nonword trials, starting from here
    word_idx =  find(mod(epoch_oi.trial_id,2)==0 & epoch_oi.trial_id<=60); % word index
    nonword_idx = find(mod(epoch_oi.trial_id,2)~=0 & epoch_oi.trial_id<=60); %nonword index

    % get average base and trial for word trials and nonword trials, respectively
    bases_word = bases(word_idx); trials_word = signal_oi(word_idx);
    bases_nonword = bases(nonword_idx); trials_nonword = signal_oi(nonword_idx);    

    OverallBase_word = mean(cell2mat(reshape(bases_word,[1 1 size(bases_word,2)])),3);
    OverallTrial_word = mean(cell2mat(reshape(trials_word,[1 1 size(trials_word,2)])),3);

    OverallBase_nonword = mean(cell2mat(reshape(bases_nonword,[1 1 size(bases_nonword,2)])),3);
    OverallTrial_nonword = mean(cell2mat(reshape(trials_nonword,[1 1 size(trials_nonword,2)])),3);
    
    trialWord{counter} = OverallTrial_word; trialNonword{counter} = OverallTrial_nonword;
    baseWord{counter} = OverallBase_word; baseNonword{counter} = OverallBase_nonword;
end 

trialWord_One = mean(cell2mat(reshape(trialWord,[1 1 size(trialWord,2)])),3);
baseWord_One = mean(cell2mat(reshape(baseWord,[1 1 size(baseWord,2)])),3);

trialNonword_One = mean(cell2mat(reshape(trialNonword,[1 1 size(trialNonword,2)])),3);
baseNonword_One = mean(cell2mat(reshape(baseNonword,[1 1 size(baseNonword,2)])),3);

word_final = (trialWord_One - repmat(mean(baseWord_One, 1),[length(trialWord_One),1])) ...
    ./ repmat(std(baseWord_One,0,1),[length(trialWord_One),1]);

nonword_final = (trialNonword_One - repmat(mean(baseNonword_One, 1),[length(trialNonword_One),1])) ...
    ./ repmat(std(baseNonword_One,0,1),[length(trialNonword_One),1]);

Diff = nonword_final - word_final;

figure; colormap(jet)

t=linspace(-2,2,size(Diff,1));
imagesc(t, fq, Diff(:,:)');set(gca, 'YDir', 'Normal');

caxis([-15,15]); box on;