%This script group all thalamic pilot patients (except one orphan) electrophysiological data,filtering, chuncking,
%rejecting bad trials for each channel and common average referencing

% load bml packages
bml_defaults;
ft_defaults;
%fs
fs = 1000;
% set machine
DW_machine;
%read in session info
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_new.xlsx']);

% process one session at a time
for total_session_idx = 1:height(Session_info)
    clearvars -except dionysis dropbox Session_info total_session_idx Results fs;
    disp(['processing ',Session_info.Session_id{total_session_idx}]);
    patient_id = Session_info.Session_id{total_session_idx}(1:7); % get patient id
    which_session = Session_info.Session_id{total_session_idx}(end); % get which session of this patient
    which_session = str2double(which_session);
    data_dir = dir([dionysis,'Electrophysiology_Data/DBS_Intraop_Recordings/',...
        patient_id,'/Preprocessed Data/FieldTrip/*_ft_raw_session.mat']);
    cd(data_dir.folder);
    load([data_dir.folder,filesep,data_dir.name]); % load D.mat
    
    %load info tables
    cue = bml_annot_read('annot/cue_presentation.txt');
    coding = bml_annot_read('annot/coding.txt');
    electrode =  bml_annot_read('annot/electrode.txt');
    session = bml_annot_read('annot/session.txt');
    
    %% Filtering
    
    
    %% D contains all sessions for one patient, choose session of interest and cut session of interest into trials

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
    coding_oi,...
    cue_oi(:,{'ITI_starts','stimulus_starts','trial_id','session_id'}),...
    'keys',{'session_id','trial_id'});

    epoch_oi = sortrows(epoch_oi, [size(epoch_oi,2)-2,size(epoch_oi,2)-3]); %re-order the epoch1 table according to sessions and trials
    
    epoch_oi.starts = epoch_oi.stimulus_starts;
    epoch_oi.ends = epoch_oi.offset_word;
    epoch_oi = bml_annot_table(epoch_oi);
    epoch_oi = bml_annot_extend(epoch_oi,3,3); % a trial is here defined as  3s pre cue to +3s post speech offset
    epoch_used = epoch_oi;
    
    cfg=[];
    cfg.epoch = epoch_used;
    % cfg.t0='stimulus_starts'; align all trials to cue presentation
    D1=bml_redefinetrial(cfg,D);% get the data in trials
    
        
    D1_backup =D1;
    
    % so D1 is session of intersest, chunked, and contains
    % trial, time and label
    
    %% select channels of interest for this session
    %ecog
    ecog_ch = find(strcmp('ecog',cellfun(@(x) x(1:4),D1.label,'UniformOutput',0)));
    ECoG_Side = Session_info.ECoG_Side(total_session_idx);
    
    ECoG_Label = D1.label(ecog_ch);
    
    %lead
    Lead_Side = Session_info.Lead_Side(total_session_idx);
    
    if strcmp('LR',Lead_Side);
        lead_ch = find(strcmp('dbs',cellfun(@(x) x(1:3),D1.label,'UniformOutput',0)));
    else
        lead_temp = find(strcmp('dbs',cellfun(@(x) x(1:3),D1.label,'UniformOutput',0)));
        lead_ch = lead_temp(1:4);
    end
    Lead_Label = D1.label(lead_ch);
    
    %macro
    if strcmp('Y',Session_info.MER(total_session_idx));
        Macro_Side = ECoG_Side;
        Macro_ch = find(strcmp('macro',cellfun(@(x) x(1:5),D1.label,'UniformOutput',0)));
        Macro_Label = D1.label(Macro_ch);
    else
        Macro_Side = [];
        Macro_ch = [];
        Macro_Label = [];
    end
    
    % select channels oi
    D1.trial_oi = cellfun(@(x) x([ecog_ch;lead_ch;Macro_ch],:),D1.trial,'UniformOutput',0);
    ch_used = [ecog_ch;lead_ch;Macro_ch];
    label_used = D1.label(ch_used);
    %% reject bad channels and respecify channels
%     sp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts)*fs));
%     sp_center_trials_i =cellfun(@(x,y) x(:,y-3*fs:y+3*fs),D1.trial_oi_pre(1:end-1),sp_idx(1:end-1)','UniformOutput',0);
%     sp_mean_i = mean(cell2mat(reshape(sp_center_trials_i,[1,1,length(sp_center_trials_i)])),3);
%     
%     for i = 1:size(sp_mean_i,1);
%         figure (i); plot(sp_mean_i(i,:));
%     end
%     
%     judge = input('please enter bad channel figure index (if non []):');
%     close all;
%     
%     ch_used(judge) = [];
%     label_used(judge) = [];
%     
%     D1.trial_oi = cellfun(@(x) x(ch_used,:),D1.trial,'UniformOutput',0);
%     
%     clear ecog_ch ECoG_Label lead_ch Lead_Label
%     ecog_ch = ch_used(find(strcmp('ecog',cellfun(@(x) x(1:4),label_used,'UniformOutput',0))));
%     ECoG_Label = label_used(find(strcmp('ecog',cellfun(@(x) x(1:4),label_used,'UniformOutput',0))));
%     lead_ch = ch_used(find(strcmp('dbs',cellfun(@(x) x(1:3),label_used,'UniformOutput',0))));
%     Lead_Label = label_used(find(strcmp('dbs',cellfun(@(x) x(1:3),label_used,'UniformOutput',0))));
%     
%     if ~isempty(Macro_ch);
%         clear Macro_ch Macro_Label
%         Macro_ch = ch_used(find(strcmp('macro',cellfun(@(x) x(1:5),label_used,'UniformOutput',0))));
%         Macro_Label = label_used(find(strcmp('macro',cellfun(@(x) x(1:5),label_used,'UniformOutput',0))));
%     end
%  
    %% reject bad trials
    D1.maxdiff=cellfun(@(x) max(abs(diff(x,1,2)),[],2),D1.trial_oi,'Uni',0); %maximum single sample difference in each trial
    D1.maxdiff = cat(2,D1.maxdiff{:});
    D1.maxdiff_m = mean(D1.maxdiff,2); % mean max diff for each channel
    D1.maxdiff_s = std(D1.maxdiff,0,2); % std max diff for each channel


    D1.meandiff = cellfun(@(x) nanmean(abs(diff(x,1,2)),2),D1.trial_oi,'Uni',0); % mean diff in each sample
    D1.meandiff = cat(2,D1.meandiff{:});
    D1.meandiff_m = mean(D1.meandiff,2); % mean mean diff for each channel
    D1.meandiff_s = std(D1.meandiff,0,2); % std mean diff for each channel

    D1.maxval = cellfun(@(x) max(x,[],2),D1.trial_oi,'Uni',0);
    D1.maxval= cat(2,D1.maxval{:});
    D1.maxval_m = mean(D1.maxval,2); % mean max val for each channel
    D1.maxval_s = std(D1.maxval,0,2); % std max val for each channel

    D1.minval = cellfun(@(x) min(x,[],2),D1.trial_oi,'Uni',0);
    D1.minval= cat(2,D1.minval{:});
    D1.minval_m = mean(D1.minval,2); % mean min val for each channel
    D1.minval_s = std(D1.minval,0,2); % std min val for each channel

    D1.mean = cellfun(@(x) mean(x,2),D1.trial_oi,'Uni',0);
    D1.mean = cat(2,D1.mean{:});
    D1.mean_m = mean(D1.mean,2); % mean range for each channel
    D1.mean_s = std(D1.mean,0,2); % std range for each channel


    D1.range = cellfun(@(x) range(x,2),D1.trial_oi,'Uni',0);
    D1.range = cat(2,D1.range{:});
    D1.range_m = mean(D1.range,2); % mean min val for each channel
    D1.range_s = std(D1.range,0,2); % std min val for each channel


    % exclusion criteria: measures deviate more than 5 sigma or
    % maxdiff/meandiff > 30
    artifact = [];
    for i = 1:size(D1.trial_oi{1},1);
        artifact{i}= unique([find(D1.maxdiff(i,:)>D1.maxdiff_m(i)+5*D1.maxdiff_s(i) | D1.maxdiff(i,:)<D1.maxdiff_m(i)-5*D1.maxdiff_s(i)) ...
        find(D1.meandiff(i,:)>D1.meandiff_m(i)+5*D1.meandiff_s(i) | D1.meandiff(i,:)<D1.meandiff_m(i)-5*D1.meandiff_s(i)) ...
        find(D1.maxval(i,:)>D1.maxval_m(i)+5*D1.maxval_s(i) | D1.maxval(i,:)<D1.maxval_m(i)-5*D1.maxval_s(i)) ...
        find(D1.minval(i,:)>D1.minval_m(i)+5*D1.minval_s(i) | D1.minval(i,:)<D1.minval_m(i)-5*D1.minval_s(i)) ...
        find(D1.mean(i,:)>D1.mean_m(i)+5*D1.mean_s(i) | D1.mean(i,:)<D1.mean_m(i)-5*D1.mean_s(i)) ...
        find(D1.range(i,:)>D1.range_m(i)+5*D1.range_s(i) | D1.range(i,:)<D1.range_m(i)-5*D1.range_s(i)) ...
        find(D1.maxdiff(i,:)./D1.meandiff(i,:) > 30)]);
    end
    
    candidates = unique(cell2mat(artifact)); 
    
    count_badtrials = histc(cell2mat(artifact),candidates);
    
    candi_indx = find(count_badtrials > ceil(size(D1.trial_oi{1},1)/10)); % trials whose bad channels > 1/10 total channels are bad trials
    
    bad_trials = candidates(candi_indx);% bad trials are discarded
    
    %% also we need to discard trials that don't satisfy -3 to 3 peri speech onset
    sp_idx = round((epoch_oi.onset_word - epoch_oi.starts)*fs);
    tr_length= cell2mat(cellfun(@(x) length(x),D1.time,'UniformOutput',0))';
    
    crti1 = find(tr_length<sp_idx+3*fs);
    disp(['trials that does not have post_sponset 3s:',num2str(crti1)]);
    
    crti2= find(sp_idx<3*fs);
    disp(['trials whose speech onset idx timepoint less than 3s:',num2str(crti2)]);
    
    crti3 = find(sp_idx>tr_length);
    disp(['trials whose speech onset idx greater than trial length:',num2str(crti3)]);
    
    % also discard trials less than 6780 for filter purpose: subject to
    % change;
    crti4 = find(tr_length<=6780);
    
    %% combine badtrials with short trials and get trials to be discarded
    discarded_trials = unique([bad_trials,crti1,crti2,crti3,crti4']);
    
    %% remove discarded trial from epoch table
    epoch_oi(discarded_trials,:) = [];
    epoch_prify = epoch_oi;
    epoch_prify.id = [1:height(epoch_prify)]';
    
    %% remove discarded trial from trial list in D1
    D1.trial(discarded_trials) = [];
    %% get channels oi for each type, and do Common average referencing by connector (CARBC).   
    ECoG_LFP = cellfun(@(x) x(ecog_ch,:),D1.trial,'UniformOutput',0);

    
    % CARBC for ECOG
    connector_idx = [];
    for i = 1:length(ECoG_Label);
        connector_i = electrode.connector(find(strcmp(electrode.electrode,ECoG_Label{i})));
        connector_idx = [connector_idx,connector_i];
    end
    
    connector_num = unique(connector_idx);
    
    for i = 1:length(connector_num);
        bundle_i = find(connector_idx == connector_num(i));
        sep_ECoG(i,:) = cellfun(@(x) x(bundle_i,:) - mean(x(bundle_i,:),1),ECoG_LFP,'UniformOutput',0);
    end
    
    
    for i = 1: size(sep_ECoG,2);
        ECoG_LFP_ref{1,i} = cell2mat(sep_ECoG(:,i));
    end
    
    %lead
    Lead_LFP = cellfun(@(x) x(lead_ch,:),D1.trial,'UniformOutput',0);

    
    % CAR for lead lfp
    connector_idx = [];
    for i = 1:length(Lead_Label);
        connector_i = electrode.connector(find(strcmp(electrode.electrode,Lead_Label{i})));
        connector_idx = [connector_idx,connector_i];
    end
    
    connector_num = unique(connector_idx);
    
    for i = 1:length(connector_num);
        bundle_i = find(connector_idx == connector_num(i));
        sep_lead(i,:) = cellfun(@(x) x(bundle_i,:) - mean(x(bundle_i,:),1),Lead_LFP,'UniformOutput',0);
    end
    
    
    for i = 1: size(sep_lead,2);
        Lead_LFP_ref{1,i} = cell2mat(sep_lead(:,i));
    end

    % Macro_LFP and Macro_LFP_ref
    Macro_LFP = cellfun(@(x) x(Macro_ch,:),D1.trial,'UniformOutput',0);
    
    if cell2mat(cellfun(@(x) isempty(x),Macro_LFP,'UniformOutput',0))
        
        Macro_LFP = [];
        Macro_LFP_ref = [];
    else
        Macro_LFP_ref = cellfun(@(x) x - mean(x,1),Macro_LFP,'UniformOutput',0);
    end
    
    %% add audio
    audio = cellfun(@(x) x(end-1:end,:),D1.trial,'UniformOutput',0);
   
    audio_label = D1.label(end-1:end);
%% add time
    D1.time(discarded_trials) = [];
    time = D1.time;
 %%   finalize
    Results(total_session_idx).session = Session_info.Session_id(total_session_idx);
    Results(total_session_idx).ECoG = ECoG_LFP; % ecog unref
    Results(total_session_idx).ECoG_ref = ECoG_LFP_ref; % ref_ecog
    Results(total_session_idx).Lead_LFP = Lead_LFP; %Lead unref 
    Results(total_session_idx).Lead_LFP_ref = Lead_LFP_ref; % Lead_LFP_ref
    Results(total_session_idx).Macro_LFP = Macro_LFP; % non_ref
    Results(total_session_idx).Macro_LFP_ref = Macro_LFP_ref; %ref
    Results(total_session_idx).annot.fs = D1.hdr.Fs;
    Results(total_session_idx).annot.ECoG_Side = ECoG_Side;
    Results(total_session_idx).annot.Lead_Side = Lead_Side;
    Results(total_session_idx).annot.Macro_Side = Macro_Side;
    Results(total_session_idx).annot.ECoG_Label = ECoG_Label;
    Results(total_session_idx).annot.Lead_Label = Lead_Label;
    Results(total_session_idx).annot.Macro_Label = Macro_Label;
    Results(total_session_idx).annot.audio_label = audio_label;
    if strcmp('Y',Session_info.MER(total_session_idx));
        
        Results(total_session_idx).annot.depth = session.depth(which_session);
    else
        Results(total_session_idx).annot.depth = [];
    end
    
    Results(total_session_idx).annot.coding = epoch_prify;
    Results(total_session_idx).annot.time = time;
end

readme = {'bad_trial rejected, not software filtered, all patients'};

save([dionysis,'Users/dwang/VIM/datafiles/processed_data/','Processed_all.mat'],'Results','readme','-v7.3');

cd([dionysis,'Users/dwang/VIM/datafiles/processed_data']);