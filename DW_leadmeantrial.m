clearvars -except Results;
DW_machine;

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/Processed_lead.mat']);

Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_lead.xlsx']);
cd([dionysis,'Users/dwang/VIM/datafiles/processed_data']);

fq = 2:2:200;
fs = 1000;
%

%1: not ref, avg first
clear signal;
for total_session_idx = 1:length(Results);
    clear signal
    disp(['processing',Session_info.Session_id{total_session_idx}])
    % wavtransform of time series to get frequency-time domain signals
    % use DW_fast
    signal(total_session_idx).Lead = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),Results(total_session_idx).Lead_LFP,'UniformOutput',0);
    % time X fq X ch, out trials
    
    %event index: iti-start, cue_pre, onset_word, offset_word, respectively
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.ITI_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,4) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
 %% first average, then normalize to z
 
    % -3 to 3 peri cue
    signal(total_session_idx).cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);
    
    signal(total_session_idx).avg_cue = mean(cell2mat(reshape(signal(total_session_idx).cue,[1,1,1,length(signal(total_session_idx).cue)])),4);
    
    signal(total_session_idx).base = signal(total_session_idx).avg_cue(3000-750:3000,:,:); %use both for cue and sp; -0.75s to cue
    
    signal(total_session_idx).z_cue = (signal(total_session_idx).avg_cue - repmat(mean(signal(total_session_idx).base,1),[length(signal(total_session_idx).avg_cue),1]))...
        ./repmat(std(signal(total_session_idx).base,0,1),[length(signal(total_session_idx).avg_cue),1]);
    
    % -3 to 3 peri speech
    signal(total_session_idx).avg_sp = mean(cell2mat(reshape(signal(total_session_idx).sp,[1,1,1,length(signal(total_session_idx).sp)])),4);
    

    signal(total_session_idx).z_sp = (signal(total_session_idx).avg_sp - repmat(mean(signal(total_session_idx).base,1),[length(signal(total_session_idx).avg_sp),1]))...
        ./repmat(std(signal(total_session_idx).base,0,1),[length(signal(total_session_idx).avg_sp),1]);
    
    mean_trial(total_session_idx).session = Session_info.Session_id(total_session_idx);
    mean_trial(total_session_idx).cue_avgfirst = signal(total_session_idx).z_cue;
    mean_trial(total_session_idx).sp_avgfirst = signal(total_session_idx).z_sp;
 %%   or first normalize to z, then average across trials
%     % get baseline for each trial in each session, 1s-precue as baseline
%     signal(total_session_idx).lead_base = cellfun(@(x,y) x(y-(1*fs):y,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,1)','UniformOutput',0);
%     
%     %convert signal to z-scored signal
%     signal(total_session_idx).z_val = cellfun(@(x,y) ...
%         (x-repmat(mean(y,1),[length(x),1])) ./  repmat(std(y,0,1),[length(x),1]),...
%         signal(total_session_idx).Lead,signal(total_session_idx).lead_base,...
%         'UniformOutput',0);
%     
%     %define peri-cue:-2.5s pre cue to 3s after cue
%     %define peri-speech: -2.5s pre-speechonset to +3s after speech onset
% 
%     
%     mean_trial(total_session_idx).session = Session_info.Session_id(total_session_idx);
%     
%     
%     
%     
%     mean_trial(total_session_idx).cue = mean(cell2mat(reshape(cellfun(@(x,y) x(y-2.5*fs:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,1)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Lead,2)])),4);
%     
%     mean_trial(total_session_idx).sp = mean(cell2mat(reshape(cellfun(@(x,y) x(y-2.5*fs:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,2)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Lead,2)])),4);
%     
%     
end

%2:ref, avg first
clear signal;
for total_session_idx = 1:length(Results);
    clear signal
    disp(['processing',Session_info.Session_id{total_session_idx}])
    % wavtransform of time series to get frequency-time domain signals
    % use DW_fast
    signal(total_session_idx).Lead = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    % time X fq X ch, out trials
    
    %event index: iti-start, cue_pre, onset_word, offset_word, respectively
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.ITI_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,4) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
 %% first average, then normalize to z
 
    % -3 to 3 peri cue
    signal(total_session_idx).cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);
    
    signal(total_session_idx).avg_cue = mean(cell2mat(reshape(signal(total_session_idx).cue,[1,1,1,length(signal(total_session_idx).cue)])),4);
    
    signal(total_session_idx).base = signal(total_session_idx).avg_cue(3000-750:3000,:,:); %use both for cue and sp; -0.75s to cue
    
    signal(total_session_idx).z_cue = (signal(total_session_idx).avg_cue - repmat(mean(signal(total_session_idx).base,1),[length(signal(total_session_idx).avg_cue),1]))...
        ./repmat(std(signal(total_session_idx).base,0,1),[length(signal(total_session_idx).avg_cue),1]);
    
    % -3 to 3 peri speech
    signal(total_session_idx).avg_sp = mean(cell2mat(reshape(signal(total_session_idx).sp,[1,1,1,length(signal(total_session_idx).sp)])),4);
    

    signal(total_session_idx).z_sp = (signal(total_session_idx).avg_sp - repmat(mean(signal(total_session_idx).base,1),[length(signal(total_session_idx).avg_sp),1]))...
        ./repmat(std(signal(total_session_idx).base,0,1),[length(signal(total_session_idx).avg_sp),1]);
    
    
    mean_trial(total_session_idx).cue_ref_avgfirst = signal(total_session_idx).z_cue;
    mean_trial(total_session_idx).sp_ref_avgfirst = signal(total_session_idx).z_sp;
 %%   or first normalize to z, then average across trials
%     % get baseline for each trial in each session, 1s-precue as baseline
%     signal(total_session_idx).lead_base = cellfun(@(x,y) x(y-(1*fs):y,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,1)','UniformOutput',0);
%     
%     %convert signal to z-scored signal
%     signal(total_session_idx).z_val = cellfun(@(x,y) ...
%         (x-repmat(mean(y,1),[length(x),1])) ./  repmat(std(y,0,1),[length(x),1]),...
%         signal(total_session_idx).Lead,signal(total_session_idx).lead_base,...
%         'UniformOutput',0);
%     
%     %define peri-cue:-2.5s pre cue to 3s after cue
%     %define peri-speech: -2.5s pre-speechonset to +3s after speech onset
% 
%     
%     mean_trial(total_session_idx).session = Session_info.Session_id(total_session_idx);
%     
%     
%     
%     
%     mean_trial(total_session_idx).cue = mean(cell2mat(reshape(cellfun(@(x,y) x(y-2.5*fs:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,1)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Lead,2)])),4);
%     
%     mean_trial(total_session_idx).sp = mean(cell2mat(reshape(cellfun(@(x,y) x(y-2.5*fs:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,2)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Lead,2)])),4);
%     
%     
end

%3:not ref, not avg first
clear signal;
for total_session_idx = 1:length(Results);
    clear signal
    disp(['processing',Session_info.Session_id{total_session_idx}])
    % wavtransform of time series to get frequency-time domain signals
    % use DW_fast
    signal(total_session_idx).Lead = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),Results(total_session_idx).Lead_LFP,'UniformOutput',0);
    % time X fq X ch, out trials
    
    %event index: iti-start, cue_pre, onset_word, offset_word, respectively
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.ITI_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,4) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
%  %% first average, then normalize to z
%  
%     % -3 to 3 peri cue
%     signal(total_session_idx).cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
%     signal(total_session_idx).sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);
%     
%     signal(total_session_idx).avg_cue = mean(cell2mat(reshape(signal(total_session_idx).cue,[1,1,1,length(signal(total_session_idx).cue)])),4);
%     
%     signal(total_session_idx).base = signal(total_session_idx).avg_cue(3000-750:3000,:,:); %use both for cue and sp; -0.75s to cue
%     
%     signal(total_session_idx).z_cue = (signal(total_session_idx).avg_cue - repmat(mean(signal(total_session_idx).base,1),[length(signal(total_session_idx).avg_cue),1]))...
%         ./repmat(std(signal(total_session_idx).base,0,1),[length(signal(total_session_idx).avg_cue),1]);
%     
%     % -3 to 3 peri speech
%     signal(total_session_idx).avg_sp = mean(cell2mat(reshape(signal(total_session_idx).sp,[1,1,1,length(signal(total_session_idx).sp)])),4);
%     
% 
%     signal(total_session_idx).z_sp = (signal(total_session_idx).avg_sp - repmat(mean(signal(total_session_idx).base,1),[length(signal(total_session_idx).avg_sp),1]))...
%         ./repmat(std(signal(total_session_idx).base,0,1),[length(signal(total_session_idx).avg_sp),1]);
%     
%     
%     mean_trial(total_session_idx).cue_ref_avgfirst = signal(total_session_idx).z_cue;
%     mean_trial(total_session_idx).sp_ref_avgfirst = signal(total_session_idx).z_sp;

 %%   or first normalize to z, then average across trials
    % get baseline for each trial in each session, 0.75s-precue as baseline
    signal(total_session_idx).lead_base = cellfun(@(x,y) x(y-(0.75*fs):y,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    
    %convert signal to z-scored signal
    signal(total_session_idx).z_val = cellfun(@(x,y) ...
        (x-repmat(mean(y,1),[length(x),1])) ./  repmat(std(y,0,1),[length(x),1]),...
        signal(total_session_idx).Lead,signal(total_session_idx).lead_base,...
        'UniformOutput',0);
    
    %define peri-cue:-3s pre cue to 3s after cue
    %define peri-speech: -3s pre-speechonset to +3s after speech onset
    mean_trial(total_session_idx).cue = mean(cell2mat(reshape(cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,2)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Lead,2)])),4);
    
    mean_trial(total_session_idx).sp = mean(cell2mat(reshape(cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,3)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Lead,2)])),4);
    
    
end


%4:ref, not avg first
clear signal;
for total_session_idx = 1:length(Results);
    clear signal
    disp(['processing',Session_info.Session_id{total_session_idx}])
    % wavtransform of time series to get frequency-time domain signals
    % use DW_fast
    signal(total_session_idx).Lead = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    % time X fq X ch, out trials
    
    %event index: iti-start, cue_pre, onset_word, offset_word, respectively
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.ITI_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,4) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
%  %% first average, then normalize to z
%  
%     % -3 to 3 peri cue
%     signal(total_session_idx).cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
%     signal(total_session_idx).sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);
%     
%     signal(total_session_idx).avg_cue = mean(cell2mat(reshape(signal(total_session_idx).cue,[1,1,1,length(signal(total_session_idx).cue)])),4);
%     
%     signal(total_session_idx).base = signal(total_session_idx).avg_cue(3000-750:3000,:,:); %use both for cue and sp; -0.75s to cue
%     
%     signal(total_session_idx).z_cue = (signal(total_session_idx).avg_cue - repmat(mean(signal(total_session_idx).base,1),[length(signal(total_session_idx).avg_cue),1]))...
%         ./repmat(std(signal(total_session_idx).base,0,1),[length(signal(total_session_idx).avg_cue),1]);
%     
%     % -3 to 3 peri speech
%     signal(total_session_idx).avg_sp = mean(cell2mat(reshape(signal(total_session_idx).sp,[1,1,1,length(signal(total_session_idx).sp)])),4);
%     
% 
%     signal(total_session_idx).z_sp = (signal(total_session_idx).avg_sp - repmat(mean(signal(total_session_idx).base,1),[length(signal(total_session_idx).avg_sp),1]))...
%         ./repmat(std(signal(total_session_idx).base,0,1),[length(signal(total_session_idx).avg_sp),1]);
%     
%     
%     mean_trial(total_session_idx).cue_ref_avgfirst = signal(total_session_idx).z_cue;
%     mean_trial(total_session_idx).sp_ref_avgfirst = signal(total_session_idx).z_sp;

 %%   or first normalize to z, then average across trials
    % get baseline for each trial in each session, 0.75s-precue as baseline
    signal(total_session_idx).lead_base = cellfun(@(x,y) x(y-(0.75*fs):y,:,:),signal(total_session_idx).Lead,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    
    %convert signal to z-scored signal
    signal(total_session_idx).z_val = cellfun(@(x,y) ...
        (x-repmat(mean(y,1),[length(x),1])) ./  repmat(std(y,0,1),[length(x),1]),...
        signal(total_session_idx).Lead,signal(total_session_idx).lead_base,...
        'UniformOutput',0);
    
    %define peri-cue:-3s pre cue to 3s after cue
    %define peri-speech: -3s pre-speechonset to +3s after speech onset
    mean_trial(total_session_idx).cue_ref = mean(cell2mat(reshape(cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,2)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Lead,2)])),4);
    
    mean_trial(total_session_idx).sp_ref = mean(cell2mat(reshape(cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,3)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Lead,2)])),4);
    
    
end

readme = {'4 different types of processing: unref+avgfirst; ref+avgfirst; unref+avglater; ref+avglater'};
save([dionysis,'Users/dwang/VIM/datafiles/processed_data/leadmeantrial_all.mat'],'mean_trial','readme','-v7.3');