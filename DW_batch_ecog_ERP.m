%follow DW_batch_CAR_ecog
%look at ERP of ecog, signal either referenced or not

%specify machine to run the script on
DW_machine;

fs = 1000;
%read in subject list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
Subject_list([2],:) =[]; % DBS4039 no ecog

for Subject_idx = 1:height(Subject_list)
    
    Subject_id = cell2mat(Subject_list.Subject_id(Subject_idx));
    data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id filesep 'ecog/*_step3.mat']);
    for which_session = 1:length(data_dir) % deal with one session at a time
        load([data_dir(which_session).folder filesep data_dir(which_session).name]);% load in data of step3 session oi
        %remove bad trials
        D1 = D;
        D1.trial(:,D1.badtrial_final) = [];
        D1.time(D1.badtrial_final) = [];
        D1.epoch(D1.badtrial_final,:) = [];
        %center on word onset, -2 to + 2
        roi_starts = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) - 2*fs)';
        roi_ends = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) + 2*fs)';
        avg_cue = mean(D1.epoch.stimulus_starts - D1.epoch.onset_word);
        avg_word_off = mean(D1.epoch.offset_word - D1.epoch.onset_word);
        
    for ch_idx = 1:size(D1.trial{1,1},1) % loop through channels

        % extract region of interest of each trial
        
        trials_raw_oi = cellfun(@(x,y,z) x(ch_idx,y:z),D1.trial(1,:),roi_starts,roi_ends,'UniformOutput',0);
        trials_ref_oi = cellfun(@(x,y,z) x(ch_idx,y:z),D1.trial(2,:),roi_starts,roi_ends,'UniformOutput',0);
        
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
        
        
        plot(-2:0.001:2,avg_tr_raw_norm)
        ylim([-10,10]);
        hold on;plot([0,0],ylim,'--')
        
        plot([avg_cue,avg_cue],ylim,'--');
        plot([avg_word_off,avg_word_off],ylim,'--');
        
        saveas(gcf,['/Volumes/Nexus/Users/dwang/VIM/Results/New/ecog_erp_sp/' data_dir(which_session).name(1:17)...
            'ch' num2str(ch_idx)]);
        
        close all;
        
        plot(-2:0.001:2,avg_tr_ref_norm)
        ylim([-10,10]);
        hold on;plot([0,0],ylim,'--')
        
        plot([avg_cue,avg_cue],ylim,'--');
        plot([avg_word_off,avg_word_off],ylim,'--');  
        

        saveas(gcf,['/Volumes/Nexus/Users/dwang/VIM/Results/New/ecog_erp_sp/' data_dir(which_session).name(1:17)...
            'ch' num2str(ch_idx) '_ref']);
        close all
    end
    end
end