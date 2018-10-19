% Created on 10/18/2018

% test if the session difference of left lead contacts has some relation to
% baseline difference

% manually specify which contact we want to look at

DW_machine; fs = 1000; fq = 2:2:200;

load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_level_raw_trials/ref_contact_64_session1.mat']);
trials1 = trials; epoch1 = epoch;

load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_level_raw_trials/ref_contact_64_session2.mat']);
trials2 = trials; epoch2 = epoch;

signal1 = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),trials1,'UniformOutput',0);
signal2 = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),trials2,'UniformOutput',0);

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

t=linspace(-2,2,size(signal1_normall,1));
imagesc(t, fq, signal1_normall(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

figure (2)

t=linspace(-2,2,size(signal2_normall,1));
imagesc(t, fq, signal2_normall(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

figure (3)
t=linspace(-2,2,size(signal_all_normall,1));
imagesc(t, fq, signal_all_normall(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

%%%%%%%%%%%
figure (4)

t=linspace(-2,2,size(signal1_norm1,1));
imagesc(t, fq, signal1_norm1(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

figure (5)

t=linspace(-2,2,size(signal2_norm1,1));
imagesc(t, fq, signal2_norm1(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

figure (6)
t=linspace(-2,2,size(signal_all_norm1,1));
imagesc(t, fq, signal_all_norm1(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

%%%%%%%%%%%
figure (7)

t=linspace(-2,2,size(signal1_norm2,1));
imagesc(t, fq, signal1_norm2(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

figure (8)

t=linspace(-2,2,size(signal2_norm2,1));
imagesc(t, fq, signal2_norm2(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;

figure (9)
t=linspace(-2,2,size(signal_all_norm2,1));
imagesc(t, fq, signal_all_norm2(:,:)');set(gca, 'YDir', 'Normal');
caxis([-15,15]); box on;