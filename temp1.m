% demo of processing steps with ft_raw_session.mat

% take DBS2001 as an example
load('/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/DBS2001_ft_raw_session.mat');

% step 1, tear apart subcortical and cortical channels, create a file that
% includes only audio and ecog channels, for each session

for which_session = 1:length(D.trial) % deal with one session at a time
    clearvars ecog_ch_idx audio_ch_idx select_ch_idx D_select D_backup
    ecog_ch_idx = find(strcmp('ecog',cellfun(@(x) x(1:4),D.label,'UniformOutput',0))); % ecog channels
    audio_ch_idx(1,:) = find(strcmp('audio_p',D.label)); audio_ch_idx(2,:) = find(strcmp('envaudio_p',D.label)); % audio channels
    select_ch_idx = [ecog_ch_idx;audio_ch_idx];
    

    D_select.label = D.label(select_ch_idx);% extract ecog and audio
    D_select.time(1) = D.time(which_session);
    D_select.trial{1} = D.trial{which_session}(select_ch_idx,:); 
    D_select.cfg = D.cfg; % just copy
    
    %make hdr for D_select
    hdr = [];
    hdr.Fs=1000;
    hdr.nChans=length(D_select.label);
    hdr.nSamples=sum(cellfun(@(x)size(x,2),D_select.trial));
    hdr.nSamplesPre=0;
    hdr.nTrials=length(D_select.trial);
    hdr.label=D_select.label;
    hdr.chantype=split(D_select.label,'_');
    hdr.chantype=hdr.chantype(:,1);
    hdr.chanunit=[repmat({'uV'},size(D_select.trial{1},1)-2,1);{'au';'au'}];
            
    D_select.hdr = hdr;    
    
    % save
    D_backup = D;
    D =D_select;
    session_epoch = loaded_epoch(which_session,:);

    save(['/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/demo/DBS2001_session' num2str(which_session) '_ecog.mat']...
        ,'D','session_epoch','-v7.3');
    D = D_backup;
end 
% end step 1, get DBS2001_sessionX_ecog.mat

clear all;

% step 2: loop through DBS2001_sessionX_ecog.mat to inspect bad channels
% visually, add D.badch field for each file
rmpath(genpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/fieldtrip'));
rmpath(genpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/bml'));
rmpath(genpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/NPMK'));
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/fieldtrip');
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/bml');
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/NPMK/NPMK');
ft_defaults;
bml_defaults;
data_dir = dir('/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/demo/*.mat');

for total_session_idx = 1:length(data_dir)
    load([data_dir(total_session_idx).folder filesep data_dir(total_session_idx).name]);
    
    cfg=[];
    cfg.viewmode = 'vertical';
    cfg.continuous = 'yes';
    cfg.blocksize = 30;
    ft_databrowser(cfg,D);
    
    disp(data_dir(total_session_idx).name);
    
    badch = input('Bad channel indexes:');

    
    close all
    D.badch = [];
    D.state = 'downsampled to 1khz, badch detected';


    save(['/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/demo/'...
    data_dir(total_session_idx).name(1:end-4) '_step1.mat'],'D','session_epoch','-v7.3');
end
% end step 2, get DBS2001_sessionX_ecog_step1.mat

% step 3, filter out line noise, hpf and lpf
% continue with DBS2001_session1_ecog_step1.mat only
clear all;

load('/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/demo/DBS2001_session1_ecog_step1.mat');
%load in 2hz_hp filter and 400hz_lp filter
load('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/Filter/lpf_400_60at');
load('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/Filter/hpf_2_45at');

% remove line noise using unpowerline2 function (/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/Filter/unpowerline2.m)
temp_up = unpowerline2(D.trial{1}',D.hdr.Fs,1); % unpowerline, takes in timeXchannel data

temp_up_lpfilt = filtfilt(lpf_400,temp_up); % lpf
temp_up_lpfilt_hpfilt = filtfilt(hpf_2,temp_up_lpfilt); % hpf

D.trial{1} = temp_up_lpfilt_hpfilt';

D.state = [D.state, ', unpowerlined, lpf at 400 and hpf at 2'];

save(['/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/demo/'...
'DBS2001_session1_ecog_step2.mat'],'D','session_epoch','-v7.3');

% end step 3, get DBS2001_session1_ecog_step2.mat

% step 4: cut session data into trials
clear all;

rmpath(genpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/fieldtrip'));
rmpath(genpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/bml'));
rmpath(genpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/NPMK'));
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/fieldtrip');
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/bml');
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/NPMK/NPMK');
ft_defaults;
bml_defaults;

load('/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/demo/DBS2001_session1_ecog_step2.mat');

% load in annot table
cue = bml_annot_read('/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/annot/cue_presentation.txt');
coding = bml_annot_read('/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/annot/coding.txt');

%re-order the coding table according to sessions and trials
%This is to avoid possible chaos
coding_reorder = sortrows(coding,{'session_id','trial_id'}); 
coding_reorder.id = (1:size(coding_reorder,1))';

%exclude trials whose onset or offset word timepoints are missing
essential_time_needed = table2array(coding_reorder(:,{'onset_word','offset_word'}));
absen_trial_idx = find(any(isnan(essential_time_needed),2)); % any of the 2 points missing

coding_reorder(absen_trial_idx,:) = []; % remove those
coding_reorder.id = (1:size(coding_reorder,1))';

% then merge coding and cue of session of interest
which_session = 1;
coding_sessionoi = coding_reorder(coding_reorder.session_id == which_session,:);
cue_sessionoi = cue(cue.session_id == which_session,:);

% find trials in common
common_trials = intersect(coding_sessionoi.trial_id,cue_sessionoi.trial_id);

% choose intersected trials
coding_sessionoi = coding_sessionoi(find(ismember(coding_sessionoi.trial_id,common_trials)),:);

cue_sessionoi = cue_sessionoi(find(ismember(cue_sessionoi.trial_id,common_trials)),:);

%combine
epoch_oi=join(...
coding_sessionoi,...
cue_sessionoi(:,{'ITI_starts','stimulus_starts','trial_id','session_id'}),...
'keys',{'session_id','trial_id'});


epoch_oi = sortrows(epoch_oi,{'session_id','trial_id'}); %re-order the epoch1 table according to sessions and trials

epoch_oi.starts = epoch_oi.stimulus_starts;
epoch_oi.ends = epoch_oi.offset_word;
epoch_oi = bml_annot_table(epoch_oi);
epoch_oi = bml_annot_extend(epoch_oi,2,2); % a trial is here defined as  2s pre cue to 2s post speech offset


epoch_used = epoch_oi;
cfg=[];
cfg.epoch = epoch_used;
% cfg.t0='stimulus_starts'; align all trials to cue presentation
D1=bml_redefinetrial(cfg,D);% chunk into trials

epoch_oi.id = (1:size(epoch_oi,1))';

%D1 and epoch_oi are a pair
D1.epoch = epoch_oi;
D = D1;
%
save(['/Volumes/Nexus/DBS/DBS2001/Preprocessed Data/FieldTrip/demo/'...
'DBS2001_session1_ecog_step3.mat'],'D','session_epoch','-v7.3');
% end step 4, get DBS2001_session1_ecog_step3.mat