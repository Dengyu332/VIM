% First created on 10/18/2018
% aims to make sure that the session1 and session2 data of a contact is
% really from the same "channel"
% method: take ft_raw_session file to check

addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/fieldtrip');
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/NPMK/NPMK');
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/bml');
ft_defaults;
bml_defaults;
format long

%%
SUBJECT='DBS4053';
DATE=datestr(now,'yyyymmdd');

PATH_DATA='/Volumes/Nexus/DBS';
PATH_SUBJECT=['/Volumes/Nexus/DBS' filesep SUBJECT '/Preprocessed Data/FieldTrip'];
cd(PATH_SUBJECT)

coding    = bml_annot_read('annot/coding.txt');
coding    = coding(~ismissing(coding.ends),:);

load('/Volumes/Nexus/DBS/DBS4053/Preprocessed Data/FieldTrip/DBS4053_ft_raw_session_new.mat');
D_raw = D;

clearvars D DATE loaded_epoch

load('/Volumes/Nexus/Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/DBS4053_session1_subcort_trials_step4.mat');
D1 = D;

load('/Volumes/Nexus/Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/DBS4053_session2_subcort_trials_step4.mat');
D2 = D;

% compare coding with D1.epoch and D2.epoch

cfg=[];
cfg.epoch = D1.epoch;
D_raw_1 =bml_redefinetrial(cfg,D_raw);% chunk into trials

cfg=[];
cfg.epoch = D2.epoch;
D_raw_2 =bml_redefinetrial(cfg,D_raw);% chunk into trials

D1_new.trial = cellfun(@(x) x(1:8,:),D_raw_1.trial, 'UniformOutput',0);
D2_new.trial = cellfun(@(x) x(1:8,:),D_raw_2.trial, 'UniformOutput',0);

% CAR

avg_trial_l = cellfun(@(x) mean(x(1:4,:),1),D1_new.trial,'UniformOutput',0); % get an average trial for first 4 channels
avg_trial_r = cellfun(@(x) mean(x(5:8,:),1),D1_new.trial,'UniformOutput',0); % get an average trial for last 4 channels

ref_trial_l = cellfun(@(x,y) x(1:4,:)-y,D1_new.trial,avg_trial_l,'UniformOutput',0); % common average referencing
ref_trial_r = cellfun(@(x,y) x(5:8,:)-y,D1_new.trial,avg_trial_r,'UniformOutput',0); % common average referencing

D1_new.trial(2,:) = cellfun(@(x,y) [x;y],ref_trial_l,ref_trial_r,'UniformOutput',0); %merge


avg_trial_l = cellfun(@(x) mean(x(1:4,:),1),D2_new.trial,'UniformOutput',0); % get an average trial for first 4 channels
avg_trial_r = cellfun(@(x) mean(x(5:8,:),1),D2_new.trial,'UniformOutput',0); % get an average trial for last 4 channels

ref_trial_l = cellfun(@(x,y) x(1:4,:)-y,D2_new.trial,avg_trial_l,'UniformOutput',0); % common average referencing
ref_trial_r = cellfun(@(x,y) x(5:8,:)-y,D2_new.trial,avg_trial_r,'UniformOutput',0); % common average referencing

D2_new.trial(2,:) = cellfun(@(x,y) [x;y],ref_trial_l,ref_trial_r,'UniformOutput',0); %merge

fs = 1000; fq = 2:2:200;

% specify contact_id you want to look at
signal1 = cellfun(@(x) abs(DW_fast_wavtransform(fq, x(1,:),fs, 7)),D1_new.trial(2,:),'UniformOutput',0);

signal2 = cellfun(@(x) abs(DW_fast_wavtransform(fq, x(1,:),fs, 7)),D2_new.trial(2,:),'UniformOutput',0);

epoch1 = D1.epoch; epoch2 = D2.epoch;
signal_all = [signal1,signal2];
epoch_all = [epoch1;epoch2];


bases1 = cellfun(@(x) x(1000:2000,:),signal1,'UniformOutput',0);
bases2 = cellfun(@(x) x(1000:2000,:),signal2,'UniformOutput',0);
bases_all = cellfun(@(x) x(1000:2000,:),signal_all,'UniformOutput',0);

roi_starts1 = num2cell(round((epoch1.onset_word - epoch1.starts - 2) * fs))';
roi_ends1 = num2cell(round((epoch1.onset_word - epoch1.starts + 2) * fs))';

roi_starts2 = num2cell(round((epoch2.onset_word - epoch2.starts - 2) * fs))';
roi_ends2 = num2cell(round((epoch2.onset_word - epoch2.starts + 2) * fs))';

roi_starts_all = num2cell(round((epoch_all.onset_word - epoch_all.starts - 2) * fs))';
roi_ends_all = num2cell(round((epoch_all.onset_word - epoch_all.starts + 2) * fs))';

signal1_oi = cellfun(@(x,y,z) x(y:z,:),signal1,roi_starts1,roi_ends1,'UniformOutput',0);
signal2_oi = cellfun(@(x,y,z) x(y:z,:),signal2,roi_starts2,roi_ends2,'UniformOutput',0);
signal_all_oi = cellfun(@(x,y,z) x(y:z,:),signal_all,roi_starts_all,roi_ends_all,'UniformOutput',0);

base1_one = mean(cell2mat(reshape(bases1,[1 1 size(bases1,2)])),3);
base2_one = mean(cell2mat(reshape(bases2,[1 1 size(bases2,2)])),3);
base_all_one = mean(cell2mat(reshape(bases_all,[1 1 size(bases_all,2)])),3);

signal1_one = mean(cell2mat(reshape(signal1_oi,[1 1 size(signal1_oi,2)])),3);
signal2_one = mean(cell2mat(reshape(signal2_oi,[1 1 size(signal2_oi,2)])),3);
signal_all_one = mean(cell2mat(reshape(signal_all_oi,[1 1 size(signal_all_oi,2)])),3);

%%%%%%
signal1_normall = (signal1_one - repmat(mean(base_all_one, 1),[length(signal1_one),1])) ...
    ./ repmat(std(base_all_one,0,1),[length(signal1_one),1]);

signal2_normall = (signal2_one - repmat(mean(base_all_one, 1),[length(signal2_one),1])) ...
    ./ repmat(std(base_all_one,0,1),[length(signal2_one),1]);

signal_all_normall = (signal_all_one - repmat(mean(base_all_one, 1),[length(signal_all_one),1])) ...
    ./ repmat(std(base_all_one,0,1),[length(signal_all_one),1]);

%%%%%%%%%%
signal1_norm1 = (signal1_one - repmat(mean(base1_one, 1),[length(signal1_one),1])) ...
    ./ repmat(std(base1_one,0,1),[length(signal1_one),1]);

signal2_norm1 = (signal2_one - repmat(mean(base1_one, 1),[length(signal2_one),1])) ...
    ./ repmat(std(base1_one,0,1),[length(signal2_one),1]);

signal_all_norm1 = (signal_all_one - repmat(mean(base1_one, 1),[length(signal_all_one),1])) ...
    ./ repmat(std(base1_one,0,1),[length(signal_all_one),1]);

%%%%%%%
signal1_norm2 = (signal1_one - repmat(mean(base2_one, 1),[length(signal1_one),1])) ...
    ./ repmat(std(base2_one,0,1),[length(signal1_one),1]);

signal2_norm2 = (signal2_one - repmat(mean(base2_one, 1),[length(signal2_one),1])) ...
    ./ repmat(std(base2_one,0,1),[length(signal2_one),1]);

signal_all_norm2 = (signal_all_one - repmat(mean(base2_one, 1),[length(signal_all_one),1])) ...
    ./ repmat(std(base2_one,0,1),[length(signal_all_one),1]);



figure (1)
t=linspace(-2,2,size(signal_all_normall,1));
imagesc(t, fq, signal_all_normall(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;


figure (2)

t=linspace(-2,2,size(signal1_norm1,1));
imagesc(t, fq, signal1_norm1(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

figure (3)

t=linspace(-2,2,size(signal2_norm2,1));
imagesc(t, fq, signal2_norm2(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;