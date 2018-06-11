%upstream script: DW_process.m; parellel script: DW_leadmeantrial.m

clearvars -except Results;
DW_machine;

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/Processed_lead.mat']);
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_lead.xlsx']);
%filter load
load([dropbox,'Functions/Dengyu/Filter/bpFilt.mat']);

cd([dionysis,'Users/dwang/VIM/datafiles/processed_data']);
fs = 1000;

clear signal mean_trial

for total_session_idx = 1:length(Results);
    clear signal
    disp(['processing',Session_info.Session_id{total_session_idx}])
    %x' because function applys to the first dimension
    % time X ch, out trials
    signal(total_session_idx).Lead_delta = cellfun(@(x) abs(hilbert(filtfilt(deltaFilt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_hg = cellfun(@(x) abs(hilbert(filtfilt(hg150_filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_hg = cellfun(@(x) abs(hilbert(filtfilt(hg150_filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_hg = cellfun(@(x) abs(hilbert(filtfilt(hg150_filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_hg = cellfun(@(x) abs(hilbert(filtfilt(hg150_filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_hg = cellfun(@(x) abs(hilbert(filtfilt(hg150_filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_hg = cellfun(@(x) abs(hilbert(filtfilt(hg150_filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);

    signal(total_session_idx).Lead_b2 = cellfun(@(x) abs(hilbert(filtfilt(beta2_filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    
    %event index: iti-start, cue_pre, onset_word, offset_word, respectively
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.ITI_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,4) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
 %% first average, then normalize to z
 
    % -3 to 3 peri cue; -3 to 3 peri speech
    signal(total_session_idx).hg_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Lead_hg,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).hg_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Lead_hg,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);
    
    signal(total_session_idx).hb_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Lead_hb,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).hb_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Lead_hb,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);    
    
    
    
    signal(total_session_idx).avg_hg_cue = mean(cell2mat(reshape(signal(total_session_idx).hg_cue,[1,1,length(signal(total_session_idx).hg_cue)])),3);
    signal(total_session_idx).avg_hb_cue = mean(cell2mat(reshape(signal(total_session_idx).hb_cue,[1,1,length(signal(total_session_idx).hb_cue)])),3);
       
    signal(total_session_idx).hg_base = signal(total_session_idx).avg_hg_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue
    signal(total_session_idx).hb_base = signal(total_session_idx).avg_hb_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue
    
    signal(total_session_idx).avg_hg_sp = mean(cell2mat(reshape(signal(total_session_idx).hg_sp,[1,1,length(signal(total_session_idx).hg_sp)])),3);
    signal(total_session_idx).avg_hb_sp = mean(cell2mat(reshape(signal(total_session_idx).hb_sp,[1,1,length(signal(total_session_idx).hb_sp)])),3);
    
    signal(total_session_idx).z_hg_cue = (signal(total_session_idx).avg_hg_cue - repmat(mean(signal(total_session_idx).hg_base,1),[length(signal(total_session_idx).avg_hg_cue),1]))...
        ./repmat(std(signal(total_session_idx).hg_base,0,1),[length(signal(total_session_idx).avg_hg_cue),1]);
    
    signal(total_session_idx).z_hg_sp = (signal(total_session_idx).avg_hg_sp - repmat(mean(signal(total_session_idx).hg_base,1),[length(signal(total_session_idx).avg_hg_sp),1]))...
        ./repmat(std(signal(total_session_idx).hg_base,0,1),[length(signal(total_session_idx).avg_hg_sp),1]);
    
    signal(total_session_idx).z_hb_cue = (signal(total_session_idx).avg_hb_cue - repmat(mean(signal(total_session_idx).hb_base,1),[length(signal(total_session_idx).avg_hb_cue),1]))...
        ./repmat(std(signal(total_session_idx).hb_base,0,1),[length(signal(total_session_idx).avg_hb_cue),1]);
    
    signal(total_session_idx).z_hb_sp = (signal(total_session_idx).avg_hb_sp - repmat(mean(signal(total_session_idx).hb_base,1),[length(signal(total_session_idx).avg_hb_sp),1]))...
        ./repmat(std(signal(total_session_idx).hb_base,0,1),[length(signal(total_session_idx).avg_hb_sp),1]);    
    
    mean_trial(total_session_idx).session = Session_info.Session_id(total_session_idx);
    mean_trial(total_session_idx).hg_cue_ref_avgfirst = signal(total_session_idx).z_hg_cue;
    mean_trial(total_session_idx).hg_sp_ref_avgfirst = signal(total_session_idx).z_hg_sp;
    mean_trial(total_session_idx).hb_cue_ref_avgfirst = signal(total_session_idx).z_hb_cue;
    mean_trial(total_session_idx).hb_sp_ref_avgfirst = signal(total_session_idx).z_hb_sp;    
end

readme = 'ref+avgfirst, hg(70-150) + hb(20-30)';
save([dionysis,'Users/dwang/VIM/datafiles/processed_data/leadmeantrial_hghb.mat'],'mean_trial','readme','-v7.3');