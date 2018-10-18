% First created on 10/14/2018
% aims to generate a representative figure of contact50 session1
% ref word vs. nonword spectrogram
% generate spect_final.fig under /VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg

% parameters setup
DW_machine;
fq = 2:2:200; fs = 1000;

% load in contact_info table
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);
contact_info = struct2table(contact_info);

% contact50 session1
idx_oi = find(contact_info.contact_id == 50);
% load in file_oi
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/'...
    contact_info.subject_id{idx_oi} '_session1_subcort_trials_step4.mat']);

% remove bad trials from trial, time and epoch
D1 = D;
D1.trial(:,D1.badtrial_final) = [];
D1.time(D1.badtrial_final) = [];
D1.epoch(D1.badtrial_final,:) = [];

label_oi = contact_info.label{idx_oi}; which_row = find(strcmp(label_oi,D1.label));
% get ref trials of contact 50
trials_oi = cellfun(@(x) x(which_row,:),D1.trial(2,:),'UniformOutput',0);
epoch_oi = D1.epoch;

% trials_oi and epoch_oi is used downstream
clearvars -except dionysis dropbox trials_oi epoch_oi fq fs

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

OverallBase_word_n = (OverallTrial_word - repmat(mean(OverallBase_word, 1),[length(OverallTrial_word),1])) ...
    ./ repmat(std(OverallBase_word,0,1),[length(OverallTrial_word),1]);

OverallBase_nonword_n = (OverallTrial_nonword - repmat(mean(OverallBase_nonword, 1),[length(OverallTrial_nonword),1])) ...
    ./ repmat(std(OverallBase_nonword,0,1),[length(OverallTrial_nonword),1]);



%%%%%
% OverallBase_all = mean(cell2mat(reshape(bases,[1 1 size(bases,2)])),3);
% OverallTrial_all = mean(cell2mat(reshape(signal_oi,[1 1 size(signal_oi,2)])),3);
% 
% 
% OverallTrial_all_n = (OverallTrial_all - repmat(mean(OverallBase_all, 1),[length(OverallTrial_all),1])) ...
%     ./ repmat(std(OverallBase_all,0,1),[length(OverallTrial_all),1]);

%%%%%%

Diff = OverallBase_nonword_n - OverallBase_word_n;

% select region_oi
Diff_r = Diff(1001:3000,:);

figure; colormap(jet)

t=linspace(-1,1,size(Diff_r,1));
imagesc(t, fq, Diff_r(:,:)');set(gca, 'YDir', 'Normal');

caxis([-13,13]); box on;

set(gca,'XTick',[-1 -0.5 0 0.5 1]);

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg/spect_final.fig'])