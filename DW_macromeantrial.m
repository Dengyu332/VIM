clearvars -except Results;

DW_machine;

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/Processed_all2.mat']);

Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info.xlsx']);
cd([dionysis,'Users/dwang/VIM/datafiles/processed_data']);

fq = 2:2:200;
fs = 1000;
%
macro_idx = find(strcmp(Session_info.MER,'Y'))';
clear signal mean_trial;
for total_session_idx = macro_idx;
    clear signal
    disp(['processing',Session_info.Session_id{total_session_idx}])
    % wavtransform of time series to get frequency-time domain signals
    % use DW_fast
    signal(total_session_idx).Macro = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),Results(total_session_idx).Macro_LFP,'UniformOutput',0);
    % time X fq X ch, out trials
    
    %event index
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
    
    % get baseline for each trial in each session, 1s-precue as baseline
    signal(total_session_idx).macro_base = cellfun(@(x,y) x(y-(1*fs):y,:,:),signal(total_session_idx).Macro,signal(total_session_idx).event_idx(:,1)','UniformOutput',0);
    
    %convert signal to z-scored signal
    signal(total_session_idx).z_val = cellfun(@(x,y) ...
        (x-repmat(mean(y,1),[length(x),1])) ./  repmat(std(y,0,1),[length(x),1]),...
        signal(total_session_idx).Macro,signal(total_session_idx).macro_base,...
        'UniformOutput',0);
    
    %define peri-cue:-2.5s pre cue to 3s after cue
    %define peri-speech: -2.5s pre-speechonset to +3s after speech onset

    
    mean_trial(total_session_idx).session = Session_info.Session_id(total_session_idx);
    
    
    
    
    mean_trial(total_session_idx).cue = mean(cell2mat(reshape(cellfun(@(x,y) x(y-2.5*fs:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,1)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Macro,2)])),4);
    
    mean_trial(total_session_idx).sp = mean(cell2mat(reshape(cellfun(@(x,y) x(y-2.5*fs:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,2)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Macro,2)])),4);
    
    
end
save([dionysis,'Users/dwang/VIM/datafiles/processed_data/macro_mean_trial_nocar.mat'],'mean_trial','-v7.3');