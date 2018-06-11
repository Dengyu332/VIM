clearvars -except Results;

DW_machine;

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/Processed_all.mat']);
%filter load
load([dropbox,'Functions/Dengyu/Filter/bpFilt.mat']);


Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info.xlsx']);
cd([dionysis,'Users/dwang/VIM/datafiles/processed_data']);

fs = 1000;
%
macro_idx = find(strcmp(Session_info.MER,'Y'))';
clear signal mean_trial;
for total_session_idx = macro_idx;
    clear signal
    disp(['processing',Session_info.Session_id{total_session_idx}])
    %x' because function applys to the first dimension
    % time X ch, out trials
    signal(total_session_idx).Macro_delta = cellfun(@(x) abs(hilbert(filtfilt(deltaFilt,x'))),Results(total_session_idx).Macro_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Macro_theta = cellfun(@(x) abs(hilbert(filtfilt(thetaFilt,x'))),Results(total_session_idx).Macro_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Macro_alpha = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x'))),Results(total_session_idx).Macro_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Macro_b1 = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x'))),Results(total_session_idx).Macro_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Macro_b2 = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x'))),Results(total_session_idx).Macro_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Macro_gamma = cellfun(@(x) abs(hilbert(filtfilt(gammaFilt,x'))),Results(total_session_idx).Macro_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Macro_hg = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x'))),Results(total_session_idx).Macro_LFP_ref,'UniformOutput',0);
    
    %event index: iti-start, cue_pre, onset_word, offset_word, respectively
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.ITI_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,4) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
    %% first average, then normalize
    % -3 to 3 peri cue; -3 to 3 peri speech
    signal(total_session_idx).delta_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_delta,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).delta_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_delta,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);    
    
    signal(total_session_idx).theta_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_theta,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).theta_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_theta,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);    
    
    signal(total_session_idx).alpha_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_alpha,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).alpha_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_alpha,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);    
    
    signal(total_session_idx).b1_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_b1,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).b1_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_b1,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);
    
    signal(total_session_idx).b2_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_b2,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).b2_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_b2,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);    
    
    signal(total_session_idx).gamma_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_gamma,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).gamma_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_gamma,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);    

    signal(total_session_idx).hg_cue = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_hg,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
    signal(total_session_idx).hg_sp = cellfun(@(x,y) x(y-(3*fs)+1:y+3*fs,:),signal(total_session_idx).Macro_hg,signal(total_session_idx).event_idx(:,3)','UniformOutput',0);    
    
    
    
    signal(total_session_idx).avg_delta_cue = mean(cell2mat(reshape(signal(total_session_idx).delta_cue,[1,1,length(signal(total_session_idx).delta_cue)])),3);
    signal(total_session_idx).avg_theta_cue = mean(cell2mat(reshape(signal(total_session_idx).theta_cue,[1,1,length(signal(total_session_idx).theta_cue)])),3);
    signal(total_session_idx).avg_alpha_cue = mean(cell2mat(reshape(signal(total_session_idx).alpha_cue,[1,1,length(signal(total_session_idx).alpha_cue)])),3);
    signal(total_session_idx).avg_b1_cue = mean(cell2mat(reshape(signal(total_session_idx).b1_cue,[1,1,length(signal(total_session_idx).b1_cue)])),3);    
    signal(total_session_idx).avg_b2_cue = mean(cell2mat(reshape(signal(total_session_idx).b2_cue,[1,1,length(signal(total_session_idx).b2_cue)])),3);    
    signal(total_session_idx).avg_gamma_cue = mean(cell2mat(reshape(signal(total_session_idx).gamma_cue,[1,1,length(signal(total_session_idx).gamma_cue)])),3);    
    signal(total_session_idx).avg_hg_cue = mean(cell2mat(reshape(signal(total_session_idx).hg_cue,[1,1,length(signal(total_session_idx).hg_cue)])),3);    
    
    signal(total_session_idx).delta_base = signal(total_session_idx).avg_delta_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue
    signal(total_session_idx).theta_base = signal(total_session_idx).avg_theta_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue
    signal(total_session_idx).alpha_base = signal(total_session_idx).avg_alpha_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue
    signal(total_session_idx).b1_base = signal(total_session_idx).avg_b1_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue
    signal(total_session_idx).b2_base = signal(total_session_idx).avg_b2_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue
    signal(total_session_idx).gamma_base = signal(total_session_idx).avg_gamma_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue    
    signal(total_session_idx).hg_base = signal(total_session_idx).avg_hg_cue(3000-750:3000,:); %use both for cue and sp; -0.75s to cue
    
    
    signal(total_session_idx).avg_delta_sp = mean(cell2mat(reshape(signal(total_session_idx).delta_sp,[1,1,length(signal(total_session_idx).delta_sp)])),3);
    signal(total_session_idx).avg_theta_sp = mean(cell2mat(reshape(signal(total_session_idx).theta_sp,[1,1,length(signal(total_session_idx).theta_sp)])),3);
    signal(total_session_idx).avg_alpha_sp = mean(cell2mat(reshape(signal(total_session_idx).alpha_sp,[1,1,length(signal(total_session_idx).alpha_sp)])),3);
    signal(total_session_idx).avg_b1_sp = mean(cell2mat(reshape(signal(total_session_idx).b1_sp,[1,1,length(signal(total_session_idx).b1_sp)])),3);    
    signal(total_session_idx).avg_b2_sp = mean(cell2mat(reshape(signal(total_session_idx).b2_sp,[1,1,length(signal(total_session_idx).b2_sp)])),3);
    signal(total_session_idx).avg_gamma_sp = mean(cell2mat(reshape(signal(total_session_idx).gamma_sp,[1,1,length(signal(total_session_idx).gamma_sp)])),3);    
    signal(total_session_idx).avg_hg_sp = mean(cell2mat(reshape(signal(total_session_idx).hg_sp,[1,1,length(signal(total_session_idx).hg_sp)])),3);
    
    
%delta
    signal(total_session_idx).z_delta_cue = (signal(total_session_idx).avg_delta_cue - repmat(mean(signal(total_session_idx).delta_base,1),[length(signal(total_session_idx).avg_delta_cue),1]))...
        ./repmat(std(signal(total_session_idx).delta_base,0,1),[length(signal(total_session_idx).avg_delta_cue),1]);
    
    signal(total_session_idx).z_delta_sp = (signal(total_session_idx).avg_delta_sp - repmat(mean(signal(total_session_idx).delta_base,1),[length(signal(total_session_idx).avg_delta_sp),1]))...
        ./repmat(std(signal(total_session_idx).delta_base,0,1),[length(signal(total_session_idx).avg_delta_sp),1]);

    %theta
    signal(total_session_idx).z_theta_cue = (signal(total_session_idx).avg_theta_cue - repmat(mean(signal(total_session_idx).theta_base,1),[length(signal(total_session_idx).avg_theta_cue),1]))...
        ./repmat(std(signal(total_session_idx).theta_base,0,1),[length(signal(total_session_idx).avg_theta_cue),1]);
    
    signal(total_session_idx).z_theta_sp = (signal(total_session_idx).avg_theta_sp - repmat(mean(signal(total_session_idx).theta_base,1),[length(signal(total_session_idx).avg_theta_sp),1]))...
        ./repmat(std(signal(total_session_idx).theta_base,0,1),[length(signal(total_session_idx).avg_theta_sp),1]);    
    
    %alpha
    signal(total_session_idx).z_alpha_cue = (signal(total_session_idx).avg_alpha_cue - repmat(mean(signal(total_session_idx).alpha_base,1),[length(signal(total_session_idx).avg_alpha_cue),1]))...
        ./repmat(std(signal(total_session_idx).alpha_base,0,1),[length(signal(total_session_idx).avg_alpha_cue),1]);
    
    signal(total_session_idx).z_alpha_sp = (signal(total_session_idx).avg_alpha_sp - repmat(mean(signal(total_session_idx).alpha_base,1),[length(signal(total_session_idx).avg_alpha_sp),1]))...
        ./repmat(std(signal(total_session_idx).alpha_base,0,1),[length(signal(total_session_idx).avg_alpha_sp),1]);
    
    %b1

    signal(total_session_idx).z_b1_cue = (signal(total_session_idx).avg_b1_cue - repmat(mean(signal(total_session_idx).b1_base,1),[length(signal(total_session_idx).avg_b1_cue),1]))...
        ./repmat(std(signal(total_session_idx).b1_base,0,1),[length(signal(total_session_idx).avg_b1_cue),1]);
    
    signal(total_session_idx).z_b1_sp = (signal(total_session_idx).avg_b1_sp - repmat(mean(signal(total_session_idx).b1_base,1),[length(signal(total_session_idx).avg_b1_sp),1]))...
        ./repmat(std(signal(total_session_idx).b1_base,0,1),[length(signal(total_session_idx).avg_b1_sp),1]);    
    
    %b2

    signal(total_session_idx).z_b2_cue = (signal(total_session_idx).avg_b2_cue - repmat(mean(signal(total_session_idx).b2_base,1),[length(signal(total_session_idx).avg_b2_cue),1]))...
        ./repmat(std(signal(total_session_idx).b2_base,0,1),[length(signal(total_session_idx).avg_b2_cue),1]);
    
    signal(total_session_idx).z_b2_sp = (signal(total_session_idx).avg_b2_sp - repmat(mean(signal(total_session_idx).b2_base,1),[length(signal(total_session_idx).avg_b2_sp),1]))...
        ./repmat(std(signal(total_session_idx).b2_base,0,1),[length(signal(total_session_idx).avg_b2_sp),1]);    
    
    %gamma

    signal(total_session_idx).z_gamma_cue = (signal(total_session_idx).avg_gamma_cue - repmat(mean(signal(total_session_idx).gamma_base,1),[length(signal(total_session_idx).avg_gamma_cue),1]))...
        ./repmat(std(signal(total_session_idx).gamma_base,0,1),[length(signal(total_session_idx).avg_gamma_cue),1]);
    
    signal(total_session_idx).z_gamma_sp = (signal(total_session_idx).avg_gamma_sp - repmat(mean(signal(total_session_idx).gamma_base,1),[length(signal(total_session_idx).avg_gamma_sp),1]))...
        ./repmat(std(signal(total_session_idx).gamma_base,0,1),[length(signal(total_session_idx).avg_gamma_sp),1]);    
    
    %hgamma
    signal(total_session_idx).z_hg_cue = (signal(total_session_idx).avg_hg_cue - repmat(mean(signal(total_session_idx).hg_base,1),[length(signal(total_session_idx).avg_hg_cue),1]))...
        ./repmat(std(signal(total_session_idx).hg_base,0,1),[length(signal(total_session_idx).avg_hg_cue),1]);
    
    signal(total_session_idx).z_hg_sp = (signal(total_session_idx).avg_hg_sp - repmat(mean(signal(total_session_idx).hg_base,1),[length(signal(total_session_idx).avg_hg_sp),1]))...
        ./repmat(std(signal(total_session_idx).hg_base,0,1),[length(signal(total_session_idx).avg_hg_sp),1]); 
    
    mean_trial(total_session_idx).session = Session_info.Session_id(total_session_idx);
    
    
    mean_trial(total_session_idx).delta_cue_ref_avgfirst = signal(total_session_idx).z_delta_cue;
    mean_trial(total_session_idx).delta_sp_ref_avgfirst = signal(total_session_idx).z_delta_sp;
    mean_trial(total_session_idx).theta_cue_ref_avgfirst = signal(total_session_idx).z_theta_cue;
    mean_trial(total_session_idx).theta_sp_ref_avgfirst = signal(total_session_idx).z_theta_sp;
    mean_trial(total_session_idx).alpha_cue_ref_avgfirst = signal(total_session_idx).z_alpha_cue;
    mean_trial(total_session_idx).alpha_sp_ref_avgfirst = signal(total_session_idx).z_alpha_sp;
    mean_trial(total_session_idx).b1_cue_ref_avgfirst = signal(total_session_idx).z_b1_cue;
    mean_trial(total_session_idx).b1_sp_ref_avgfirst = signal(total_session_idx).z_b1_sp;
    mean_trial(total_session_idx).b2_cue_ref_avgfirst = signal(total_session_idx).z_b2_cue;
    mean_trial(total_session_idx).b2_sp_ref_avgfirst = signal(total_session_idx).z_b2_sp;   
    mean_trial(total_session_idx).gamma_cue_ref_avgfirst = signal(total_session_idx).z_gamma_cue;
    mean_trial(total_session_idx).gamma_sp_ref_avgfirst = signal(total_session_idx).z_gamma_sp;    
    mean_trial(total_session_idx).hg_cue_ref_avgfirst = signal(total_session_idx).z_hg_cue;
    mean_trial(total_session_idx).hg_sp_ref_avgfirst = signal(total_session_idx).z_hg_sp;  
    %% first normalize, then average
%     % get baseline for each trial in each session, 1s-precue as baseline
%     signal(total_session_idx).macro_base = cellfun(@(x,y) x(y-(1*fs):y,:,:),signal(total_session_idx).Macro,signal(total_session_idx).event_idx(:,1)','UniformOutput',0);
%     
%     %convert signal to z-scored signal
%     signal(total_session_idx).z_val = cellfun(@(x,y) ...
%         (x-repmat(mean(y,1),[length(x),1])) ./  repmat(std(y,0,1),[length(x),1]),...
%         signal(total_session_idx).Macro,signal(total_session_idx).macro_base,...
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
%     mean_trial(total_session_idx).cue = mean(cell2mat(reshape(cellfun(@(x,y) x(y-2.5*fs:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,1)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Macro,2)])),4);
%     
%     mean_trial(total_session_idx).sp = mean(cell2mat(reshape(cellfun(@(x,y) x(y-2.5*fs:y+3*fs,:,:),signal(total_session_idx).z_val,signal(total_session_idx).event_idx(:,2)','UniformOutput',0),[1,1,1,size(signal(total_session_idx).Macro,2)])),4);
%     
%     
end

readme = 'macro, CAR and avgfirst, hilbert all bands';
save([dionysis,'Users/dwang/VIM/datafiles/processed_data/macro_mean_trial_ref_avgfirst_hilb.mat'],'mean_trial','readme','-v7.3');