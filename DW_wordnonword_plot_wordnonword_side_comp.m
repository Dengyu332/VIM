% Created on 10/16/2018

% Aims to generate figures of comparison between highgamma (lowbeta) left and right word/nonword responsiveness

% 8 chunks, corresponding to hg lead_left, hg lead_right, 
% hg SigUplead_left, hg SigUplead_right,
% lowbeta lead_left, lowbeta lead_right, lowbeta SigDownlead_left, lowbeta
% SigDownlead_right


% The main concern of this script is that, trials are grand averaged and then normalized to common baseline, which was, finally, thought
% to be error-prone, it's more plausible to first normalize to each
% session's own baseline, then average across sessions and contacts

% second concern is that didn't tear apart session1 and session2 and plot
% separately

% generate figures under VIM/Results/New/v2/WordVsNonword/selectivity_interim

% specify machine
DW_machine;
fs = 1000;
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


zGrand = [];
epochGrand = table();

for idx = lead_left_list
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_session' num2str(session_id) '_highgamma_ref.mat']);
    epoch_used = epoch_oi(:,{'id','starts','ends','onset_word','offset_word','onset_vowel','offset_vowel','ITI_starts','stimulus_starts','trial_id'});
    
    zGrand = [zGrand, z_oi]; epochGrand = [epochGrand;epoch_used];
end

bases_starts = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts - 1) * fs)');
bases_ends = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts) * fs)');
basesGrand = cellfun(@(x,y,z) x(y:z),zGrand,bases_starts,bases_ends,'UniformOutput',0);

roi_starts = num2cell(round((epochGrand.onset_word - epochGrand.starts - 2) * fs)');
roi_ends = num2cell(round((epochGrand.onset_word - epochGrand.starts + 2) * fs)');
trialsGrand = cellfun(@(x,y,z) x(y:z),zGrand,roi_starts,roi_ends,'UniformOutput',0);

word_idxs = find(mod(epochGrand.trial_id,2)==0 & epochGrand.trial_id<=60); % word indexs
nonword_idxs = find(mod(epochGrand.trial_id,2)==1 & epochGrand.trial_id<=60); % nonword indexs

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = trialsGrand(word_idxs); nonword_trials = trialsGrand(nonword_idxs);
word_bases = basesGrand(word_idxs); nonword_bases = basesGrand(nonword_idxs);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));
word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% Normalize to base
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
figure; plot(smooth(word_tn,200)); hold on; plot(smooth(nonword_tn,200));

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

figure; plot(word_tns); hold on; plot(nonword_tns)

%%%%%% end of chunk 1


zGrand = [];
epochGrand = table();

for idx = lead_right_list
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_highgamma_ref.mat']);
    epoch_used = epoch_oi(:,{'id','starts','ends','onset_word','offset_word','onset_vowel','offset_vowel','ITI_starts','stimulus_starts','trial_id'});
    
    zGrand = [zGrand, z_oi]; epochGrand = [epochGrand;epoch_used];
end

bases_starts = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts - 1) * fs)');
bases_ends = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts) * fs)');
basesGrand = cellfun(@(x,y,z) x(y:z),zGrand,bases_starts,bases_ends,'UniformOutput',0);

roi_starts = num2cell(round((epochGrand.onset_word - epochGrand.starts - 2) * fs)');
roi_ends = num2cell(round((epochGrand.onset_word - epochGrand.starts + 2) * fs)');
trialsGrand = cellfun(@(x,y,z) x(y:z),zGrand,roi_starts,roi_ends,'UniformOutput',0);

word_idxs = find(mod(epochGrand.trial_id,2)==0 & epochGrand.trial_id<=60); % word indexs
nonword_idxs = find(mod(epochGrand.trial_id,2)==1 & epochGrand.trial_id<=60); % nonword indexs

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = trialsGrand(word_idxs); nonword_trials = trialsGrand(nonword_idxs);
word_bases = basesGrand(word_idxs); nonword_bases = basesGrand(nonword_idxs);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));
word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% Normalize to base
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
figure; plot(smooth(word_tn,200)); hold on; plot(smooth(nonword_tn,200));

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

figure; plot(word_tns); hold on; plot(nonword_tns)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find 
lead_left_list = setdiff(find(strcmp(speech_response_table.side,'left')),1:39)';
lead_right_list = setdiff(find(strcmp(speech_response_table.side,'right')),1:39)';

SigUp_list = find(speech_response_table.ref_highgamma_period2_120_p * height(speech_response_table) < 0.05 & speech_response_table.ref_highgamma_period2_120_h == 1);

SigUpLeadLeft = intersect(lead_left_list, SigUp_list)'; SigUpLeadRight = intersect(lead_right_list, SigUp_list)';



zGrand = [];
epochGrand = table();

for idx = SigUpLeadLeft
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_session' num2str(session_id) '_highgamma_ref.mat']);
    epoch_used = epoch_oi(:,{'id','starts','ends','onset_word','offset_word','onset_vowel','offset_vowel','ITI_starts','stimulus_starts','trial_id'});
    
    zGrand = [zGrand, z_oi]; epochGrand = [epochGrand;epoch_used];
end

bases_starts = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts - 1) * fs)');
bases_ends = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts) * fs)');
basesGrand = cellfun(@(x,y,z) x(y:z),zGrand,bases_starts,bases_ends,'UniformOutput',0);

roi_starts = num2cell(round((epochGrand.onset_word - epochGrand.starts - 2) * fs)');
roi_ends = num2cell(round((epochGrand.onset_word - epochGrand.starts + 2) * fs)');
trialsGrand = cellfun(@(x,y,z) x(y:z),zGrand,roi_starts,roi_ends,'UniformOutput',0);

word_idxs = find(mod(epochGrand.trial_id,2)==0 & epochGrand.trial_id<=60); % word indexs
nonword_idxs = find(mod(epochGrand.trial_id,2)==1 & epochGrand.trial_id<=60); % nonword indexs

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = trialsGrand(word_idxs); nonword_trials = trialsGrand(nonword_idxs);
word_bases = basesGrand(word_idxs); nonword_bases = basesGrand(nonword_idxs);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));
word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% Normalize to base
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
figure; plot(-2:0.001:2, smoothdata(word_tn,'movmean', 200)); hold on; plot(-2:0.001:2,smoothdata(nonword_tn,'movmean',200));

figure (1); h_ax = gca;
set(h_ax,'XTick',-2:0.5:2);
set(h_ax,'box','on');
set(h_ax,'TickLength',[0.005,0.005]);
xlabel(h_ax,'Time Relative to Speech Onset (s)');
ylabel(h_ax,'High Gamma z-score');
ylim([-1 8]);

period2_line = plot([0,0.5],[7.5,7.5],'k-','LineWidth',3);

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

% figure; plot(word_tns); hold on; plot(nonword_tns)






%%%%%%%%%%%%



zGrand = [];
epochGrand = table();

for idx = SigUpLeadRight
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_highgamma_ref.mat']);
    epoch_used = epoch_oi(:,{'id','starts','ends','onset_word','offset_word','onset_vowel','offset_vowel','ITI_starts','stimulus_starts','trial_id'});
    
    zGrand = [zGrand, z_oi]; epochGrand = [epochGrand;epoch_used];
end

bases_starts = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts - 1) * fs)');
bases_ends = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts) * fs)');
basesGrand = cellfun(@(x,y,z) x(y:z),zGrand,bases_starts,bases_ends,'UniformOutput',0);

roi_starts = num2cell(round((epochGrand.onset_word - epochGrand.starts - 2) * fs)');
roi_ends = num2cell(round((epochGrand.onset_word - epochGrand.starts + 2) * fs)');
trialsGrand = cellfun(@(x,y,z) x(y:z),zGrand,roi_starts,roi_ends,'UniformOutput',0);

word_idxs = find(mod(epochGrand.trial_id,2)==0 & epochGrand.trial_id<=60); % word indexs
nonword_idxs = find(mod(epochGrand.trial_id,2)==1 & epochGrand.trial_id<=60); % nonword indexs

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = trialsGrand(word_idxs); nonword_trials = trialsGrand(nonword_idxs);
word_bases = basesGrand(word_idxs); nonword_bases = basesGrand(nonword_idxs);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));
word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% Normalize to base
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
figure; plot(smooth(word_tn,200)); hold on; plot(smooth(nonword_tn,200));

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

figure; plot(word_tns); hold on; plot(nonword_tns)





%%%%%%%%%%%% lowbeta

% find lead_left_idx
lead_left_list = setdiff(find(strcmp(speech_response_table.side,'left')),1:39)';
lead_right_list = setdiff(find(strcmp(speech_response_table.side,'right')),1:39)';



zGrand = [];
epochGrand = table();

for idx = lead_left_list
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_session' num2str(session_id) '_lowbeta_ref.mat']);
    epoch_used = epoch_oi(:,{'id','starts','ends','onset_word','offset_word','onset_vowel','offset_vowel','ITI_starts','stimulus_starts','trial_id'});
    
    zGrand = [zGrand, z_oi]; epochGrand = [epochGrand;epoch_used];
end

bases_starts = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts - 1) * fs)');
bases_ends = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts) * fs)');
basesGrand = cellfun(@(x,y,z) x(y:z),zGrand,bases_starts,bases_ends,'UniformOutput',0);

roi_starts = num2cell(round((epochGrand.onset_word - epochGrand.starts - 2) * fs)');
roi_ends = num2cell(round((epochGrand.onset_word - epochGrand.starts + 2) * fs)');
trialsGrand = cellfun(@(x,y,z) x(y:z),zGrand,roi_starts,roi_ends,'UniformOutput',0);

word_idxs = find(mod(epochGrand.trial_id,2)==0 & epochGrand.trial_id<=60); % word indexs
nonword_idxs = find(mod(epochGrand.trial_id,2)==1 & epochGrand.trial_id<=60); % nonword indexs

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = trialsGrand(word_idxs); nonword_trials = trialsGrand(nonword_idxs);
word_bases = basesGrand(word_idxs); nonword_bases = basesGrand(nonword_idxs);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));
word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% Normalize to base
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
figure; plot(-2:0.001:2, smoothdata(word_tn,'movmean', 200)); hold on; plot(-2:0.001:2,smoothdata(nonword_tn,'movmean',200));

figure (1); h_ax = gca;
set(h_ax,'XTick',-2:0.5:2);
set(h_ax,'box','on');
set(h_ax,'TickLength',[0.005,0.005]);
xlabel(h_ax,'Time Relative to Speech Onset (s)');
ylabel(h_ax,'High Gamma z-score');
ylim([-1 8]);

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

% figure; plot(word_tns); hold on; plot(nonword_tns)




%%%%%%%%%%%%


zGrand = [];
epochGrand = table();

for idx = lead_right_list
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_lowbeta_ref.mat']);
    epoch_used = epoch_oi(:,{'id','starts','ends','onset_word','offset_word','onset_vowel','offset_vowel','ITI_starts','stimulus_starts','trial_id'});
    
    zGrand = [zGrand, z_oi]; epochGrand = [epochGrand;epoch_used];
end

bases_starts = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts - 1) * fs)');
bases_ends = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts) * fs)');
basesGrand = cellfun(@(x,y,z) x(y:z),zGrand,bases_starts,bases_ends,'UniformOutput',0);

roi_starts = num2cell(round((epochGrand.onset_word - epochGrand.starts - 2) * fs)');
roi_ends = num2cell(round((epochGrand.onset_word - epochGrand.starts + 2) * fs)');
trialsGrand = cellfun(@(x,y,z) x(y:z),zGrand,roi_starts,roi_ends,'UniformOutput',0);

word_idxs = find(mod(epochGrand.trial_id,2)==0 & epochGrand.trial_id<=60); % word indexs
nonword_idxs = find(mod(epochGrand.trial_id,2)==1 & epochGrand.trial_id<=60); % nonword indexs

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = trialsGrand(word_idxs); nonword_trials = trialsGrand(nonword_idxs);
word_bases = basesGrand(word_idxs); nonword_bases = basesGrand(nonword_idxs);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));
word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% Normalize to base
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
figure; plot(smooth(word_tn,200)); hold on; plot(smooth(nonword_tn,200));

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

figure; plot(word_tns); hold on; plot(nonword_tns)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find 
lead_left_list = setdiff(find(strcmp(speech_response_table.side,'left')),1:39)';
lead_right_list = setdiff(find(strcmp(speech_response_table.side,'right')),1:39)';

SigDown_list = find(speech_response_table.ref_lowbeta_period2_120_p * height(speech_response_table) < 0.05 & speech_response_table.ref_lowbeta_period2_120_h == -1);

SigDownLeadLeft = intersect(lead_left_list, SigDown_list)'; SigDownLeadRight = intersect(lead_right_list, SigDown_list)';


zGrand = [];
epochGrand = table();

for idx = SigDownLeadLeft
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_session' num2str(session_id) '_lowbeta_ref.mat']);
    epoch_used = epoch_oi(:,{'id','starts','ends','onset_word','offset_word','onset_vowel','offset_vowel','ITI_starts','stimulus_starts','trial_id'});
    
    zGrand = [zGrand, z_oi]; epochGrand = [epochGrand;epoch_used];
end

bases_starts = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts - 1) * fs)');
bases_ends = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts) * fs)');
basesGrand = cellfun(@(x,y,z) x(y:z),zGrand,bases_starts,bases_ends,'UniformOutput',0);

roi_starts = num2cell(round((epochGrand.onset_word - epochGrand.starts - 2) * fs)');
roi_ends = num2cell(round((epochGrand.onset_word - epochGrand.starts + 2) * fs)');
trialsGrand = cellfun(@(x,y,z) x(y:z),zGrand,roi_starts,roi_ends,'UniformOutput',0);

word_idxs = find(mod(epochGrand.trial_id,2)==0 & epochGrand.trial_id<=60); % word indexs
nonword_idxs = find(mod(epochGrand.trial_id,2)==1 & epochGrand.trial_id<=60); % nonword indexs

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = trialsGrand(word_idxs); nonword_trials = trialsGrand(nonword_idxs);
word_bases = basesGrand(word_idxs); nonword_bases = basesGrand(nonword_idxs);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));
word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% Normalize to base
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
figure; plot(smooth(word_tn,200)); hold on; plot(smooth(nonword_tn,200));

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

figure; plot(word_tns); hold on; plot(nonword_tns)






%%%%%%%%%%%%

zGrand = [];
epochGrand = table();

for idx = SigDownLeadRight
    contact_id = speech_response_table.contact_id(idx);
    session_id = speech_response_table.ith_session{idx}; % num
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_lowbeta_ref.mat']);
    epoch_used = epoch_oi(:,{'id','starts','ends','onset_word','offset_word','onset_vowel','offset_vowel','ITI_starts','stimulus_starts','trial_id'});
    
    zGrand = [zGrand, z_oi]; epochGrand = [epochGrand;epoch_used];
end

bases_starts = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts - 1) * fs)');
bases_ends = num2cell(round((epochGrand.stimulus_starts - epochGrand.starts) * fs)');
basesGrand = cellfun(@(x,y,z) x(y:z),zGrand,bases_starts,bases_ends,'UniformOutput',0);

roi_starts = num2cell(round((epochGrand.onset_word - epochGrand.starts - 2) * fs)');
roi_ends = num2cell(round((epochGrand.onset_word - epochGrand.starts + 2) * fs)');
trialsGrand = cellfun(@(x,y,z) x(y:z),zGrand,roi_starts,roi_ends,'UniformOutput',0);

word_idxs = find(mod(epochGrand.trial_id,2)==0 & epochGrand.trial_id<=60); % word indexs
nonword_idxs = find(mod(epochGrand.trial_id,2)==1 & epochGrand.trial_id<=60); % nonword indexs

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = trialsGrand(word_idxs); nonword_trials = trialsGrand(nonword_idxs);
word_bases = basesGrand(word_idxs); nonword_bases = basesGrand(nonword_idxs);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));
word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% Normalize to base
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
figure; plot(smooth(word_tn,200)); hold on; plot(smooth(nonword_tn,200));

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

figure; plot(word_tns); hold on; plot(nonword_tns)