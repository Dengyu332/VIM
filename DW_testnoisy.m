%

%bml package
bml_defaults;
ft_defaults;
% set machine
DW_machine;
%read in session info
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_testing.xlsx']);

%load in 200hz lpf
load([dropbox,'Functions/Dengyu/Filter/lpf_200hz.mat']);

%load in noisy session
total_session_idx = 2
patient_id = Session_info.Session_id{total_session_idx}(1:7); % get patient id
which_session = Session_info.Session_id{total_session_idx}(end); % get which session of this patient
which_session = str2double(which_session);
data_dir = dir([dionysis,'Electrophysiology_Data/DBS_Intraop_Recordings/',patient_id,'/Preprocessed Data/FieldTrip/*_ft_raw_session.mat']);
cd(data_dir.folder);
load([data_dir.folder,filesep,data_dir.name]); % load D.mat

%find channels of interest
Lead_Side = Session_info.Lead_Side(total_session_idx);

if strcmp('LR',Lead_Side);
    lead_ch = find(strcmp('dbs',cellfun(@(x) x(1:3),D.label,'UniformOutput',0)));
else
    lead_temp = find(strcmp('dbs',cellfun(@(x) x(1:3),D.label,'UniformOutput',0)));
    lead_ch = lead_temp(1:4);
end

Lead_Label = D.label(lead_ch);

%% test the effect of 200hz_lpf on the signal, pick one channel only
ch_tst = D.trial{which_session}(lead_ch(1),:);

ch_tst_ft = filtfilt(lpf_200hz,ch_tst);

%plot signal in time domain
figure; plot(D.time{which_session},ch_tst);hold on;plot(D.time{which_session},ch_tst_ft);

%plot signal in frequency domain
fs = 1000;
L = length(ch_tst);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(ch_tst,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(ch_tst_ft);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(ch_tst_ft,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));



%% cut session of interest into trials
    
cue = bml_annot_read('annot/cue_presentation.txt');
coding = bml_annot_read('annot/coding.txt');
session = bml_annot_read('annot/session.txt');
electrode = bml_annot_read('annot/electrode.txt');

% remove trials lacking time data, so first tidy coding mat file
    
coding_reorder = sortrows(coding, [size(coding,2),size(coding,2)-1]); %re-order the coding table according to sessions and trials
coding_reorder.id = [1:size(coding_reorder,1)]';
timepoints = table2array(coding_reorder(:,{'onset_word','onset_vowel','offset_vowel','offset_word'}));
absen_trial_idx = find(any(isnan(timepoints),2)); % any of the four time points missing
coding_reorder(absen_trial_idx,:) = []; % remove those
    
    % then merge coding and cue of session of interest
coding_oi = coding_reorder(coding_reorder.session_id == which_session,:);
cue_oi = cue(cue.session_id == which_session,:);
intersect(coding_oi.trial_id,cue_oi.trial_id);
coding_oi = coding_oi(find(ismember(coding_oi.trial_id,intersect(coding_oi.trial_id,cue_oi.trial_id))),:);
cue_oi = cue_oi(find(ismember(cue_oi.trial_id,intersect(coding_oi.trial_id,cue_oi.trial_id))),:);
    
% get epoch used to chunk session into trials, join only choose arrays
% present in both table
epoch_oi=join(...
coding_oi(:,{'onset_word','onset_vowel','offset_vowel','offset_word','phoneticCode','word','err_cons1','err_vowel','err_cons2',...
'unveil','comment','trial_id','session_id'}),...
cue_oi(:,{'stimulus_starts','trial_id','session_id'}),...
'keys',{'session_id','trial_id'});

epoch_oi = sortrows(epoch_oi, [3,2]); %re-order the epoch1 table according to sessions and trials
epoch_oi.starts = epoch_oi.stimulus_starts;
epoch_oi.ends = epoch_oi.offset_word;
epoch_oi = bml_annot_table(epoch_oi);
epoch_oi = bml_annot_extend(epoch_oi,3,3); % a trial is here defined as  3s pre cue to +3s post speech offset
epoch_used = epoch_oi;
    
cfg=[];
cfg.epoch = epoch_used;
% cfg.t0='stimulus_starts'; align all trials to cue presentation
D1=bml_redefinetrial(cfg,D);% get the data in trials

%% no
fq = 2:2:200;
fs = 1000;

signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x(lead_ch,:),fs, 7)),D1.trial,'UniformOutput',0);

all_sg = signal{1}(:,:,1);
all_sg = all_sg(:);
min(all_sg)
median(all_sg)
prctile(all_sg,90)

for i = 1:10:size(signal,2);
    figure (i);
    imagesc(D1.time{i}, fq, signal{i}(:,:,1)');set(gca, 'YDir', 'Normal');
    colormap(jet);caxis([0,1.916197295414823e+03]);
end



