%% follow step3 
%generate spectrogram for each session's each channel
DW_machine;
fs = 1000;
fq = 2:2:200;
%read in subject list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
Subject_list([1:9],:) =[]; % DBS4039 no ecog
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
        signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),D1.trial(2,:),'UniformOutput',0); % use referenced data
        % time X fq X ch
        %center on word onset, -2 to + 2
        roi_starts = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) - 2*fs)';
        roi_ends = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) + 2*fs)';
        signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
        % average sinal_roi across trial
        avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
        avg_signal_roi = mean(avg_signal_roi,4);
        base = avg_signal_roi(1:1000,:,:); % first 1s used as baseline;
        z = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
        ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
        avg_cue = mean(D1.epoch.stimulus_starts - D1.epoch.onset_word);
        avg_word_off = mean(D1.epoch.offset_word - D1.epoch.onset_word);
        for ch_idx = 1:size(z,3);
            figure (ch_idx); colormap(jet)
            t=linspace(-2,2,size(z,1));
            imagesc(t, fq, z(:,:,ch_idx)');set(gca, 'YDir', 'Normal');
            caxis([-10,10]);
            colorbar;
            hold on; plot([avg_cue,avg_cue],ylim,'--'); plot([avg_word_off,avg_word_off],ylim,'--');
            saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/ecog_spectrogram/' data_dir(which_session).name(1:17)...
            'ch' num2str(ch_idx)]);
            disp(data_dir(which_session).name(1:17));
            close all;
        end
    end
end