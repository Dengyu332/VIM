% look at ERP, signal either referenced or not

%specify machine to run the script on
DW_machine;

% load in session info list
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_new.xlsx']);

for total_session_idx = 1:height(Session_info) % loop through all sessions
    clearvars -except Choice dionysis dropbox Session_info total_session_idx
    
    session_oi = cell2mat(Session_info.Session_id(total_session_idx)); % which session
    
    load([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' session_oi '_subcort_trials_step3.mat']); % load in data of the corresponding session
    
    % data is 2s pre cue-on to 2s after sp-off
    
    % remove bad trials
    
    D.trial(:,D.badtrial_final) = [];
    D.time(:,D.badtrial_final) = [];
    D.epoch(D.badtrial_final,:) = [];
    
    for ch_idx = 1:size(D.trial{1,1},1) % loop through channels
        clearvars -except Choice dionysis dropbox Session_info total_session_idx D ch_idx session_oi session_epoch
        
        sp_onset_idx = round(1000*(D.epoch.onset_word - D.epoch.starts));
        mean_sp_onset_idx = mean(sp_onset_idx);
        max_sp_onset_idx = max(sp_onset_idx);
        
        sp_offset_idx = round(1000*(D.epoch.offset_word - D.epoch.starts));
        mean_sp_offset_idx = mean(sp_offset_idx);
        max_sp_offset_idx = max(sp_offset_idx);
        
        

        % align to sp, decide epoch used
        epoch_start_idx = sp_onset_idx - 2000;
        epoch_end_idx = sp_onset_idx+2000; % 2s before sp 2s post sp-onset
        epoch_start_idx = num2cell(epoch_start_idx); % in order to use cellfun
        epoch_end_idx = num2cell(epoch_end_idx);
        % extract region of interest of each trial
        
        trials_raw_oi = cellfun(@(x,y,z) x(ch_idx,y:z),D.trial(1,:),epoch_start_idx',epoch_end_idx','UniformOutput',0);
        trials_ref_oi = cellfun(@(x,y,z) x(ch_idx,y:z),D.trial(2,:),epoch_start_idx',epoch_end_idx','UniformOutput',0);
        
        % convert to matrix,time x trial
        trials_raw_oi_mat = squeeze(cell2mat(reshape(trials_raw_oi,[1,1,size(trials_raw_oi,2)])));
        trials_ref_oi_mat = squeeze(cell2mat(reshape(trials_ref_oi,[1,1,size(trials_ref_oi,2)])));
        
        % average across trial
        avg_tr_raw = mean(trials_raw_oi_mat,2);
        avg_tr_ref = mean(trials_ref_oi_mat,2);
        
        % normalize to baseline (first 1s)
        % onset
        
        avg_tr_raw_norm = (avg_tr_raw - mean(avg_tr_raw(1:1000)))./std(avg_tr_raw(1:1000),0,1);
        
        avg_tr_ref_norm = (avg_tr_ref - mean(avg_tr_ref(1:1000)))./std(avg_tr_ref(1:1000),0,1);
        
        cue_rltv2_spon = D.epoch.stimulus_starts - D.epoch.onset_word;
        mean_cue_rltv2_spon = mean(cue_rltv2_spon);
        
        spoff_rltv2_spon = D.epoch.offset_word - D.epoch.onset_word;
        mean_spoff_rltv2_spon =mean(spoff_rltv2_spon);
        
        plot(-2:0.001:2,avg_tr_raw_norm)
        ylim([-10,10]);
        hold on;plot([0,0],ylim,'--')
        
        plot([mean_cue_rltv2_spon,mean_cue_rltv2_spon],ylim,'--');
        plot([mean_spoff_rltv2_spon,mean_spoff_rltv2_spon],ylim,'--');
        
        saveas(gcf,['/Volumes/Nexus/Users/dwang/VIM/Results/New/subcort_ERP_sp_v2/' session_oi '_contact' num2str(ch_idx)  '.fig'])
        
        close all;
        
        plot(-2:0.001:2,avg_tr_ref_norm)
        ylim([-10,10]);
        hold on;plot([0,0],ylim,'--')
        
        plot([mean_cue_rltv2_spon,mean_cue_rltv2_spon],ylim,'--');
        plot([mean_spoff_rltv2_spon,mean_spoff_rltv2_spon],ylim,'--');  
        
        
        
        saveas(gcf,['/Volumes/Nexus/Users/dwang/VIM/Results/New/subcort_ERP_sp_v2/' session_oi '_contact' num2str(ch_idx) '_ref' '.fig'])
        close all
    end
end