%% % follow DW_batch_CAR; takes in step3 data files
% deals with DBS4039 specifically
% generate spectrogram for each subcortical contact
%%
%specify machine
DW_machine;
% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

contact_id = 12;

Subject_id = 'DBS4039';

data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' Subject_id '_*_step3.mat']);

for which_session = 1:length(data_dir) % deal with one session at a time
    load([data_dir(which_session).folder filesep data_dir(which_session).name]);% load in data of step3 session oi
    % 1st: remove bad trials
    D1 = D;
    D1.trial(:,D1.badtrial_final) = [];
    D1.time(D1.badtrial_final) = [];
    D1.epoch(D1.badtrial_final,:) = [];
    %% ref + cue centered
    % amplitude 
    signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),D1.trial(2,:),'UniformOutput',0); % use referenced data
    % time X fq X ch
    
    %center on cue onset, -1.5 to + 2.5
    roi_starts = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) - 1.5*fs)';
    roi_ends = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) + 2.5*fs)';
    signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
    % average sinal_roi across trial
    avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
    avg_signal_roi = mean(avg_signal_roi,4);
    base = avg_signal_roi(501:1500,:,:); % 1s prior to cue onset as baseline
    
    z2 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
    ./repmat(std(base,0,1),[length(avg_signal_roi),1]);

    %% unref + cue centered

    % amplitude 
    signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),D1.trial(1,:),'UniformOutput',0); % use unreferenced data
    % time X fq X ch

    %center on cue onset, -1.5 to +2.5
    roi_starts = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) - 1.5*fs)';
    roi_ends = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) + 2.5*fs)';
    signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
    % average sinal_roi across trial
    avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
    avg_signal_roi = mean(avg_signal_roi,4);
    base = avg_signal_roi(501:1500,:,:); % 1s prior to cue onset as baseline            
    z4 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
    ./repmat(std(base,0,1),[length(avg_signal_roi),1]);

   
    % we get z1-z4, each corresponding to one condition
for ch_idx = 1:size(z2,3)
    contact_id = contact_id + 1;            
    
    z2_oi = z2(:,:,ch_idx);

    z4_oi = z4(:,:,ch_idx);


    readme2 = 'referenced, cue onset centered, -1.5 to 2.5 peri cue onset, 1s prior to cue as baseline';

    readme4 = 'unreferenced, cue onset centered, -1.5 to 2.5 peri cue onset, 1s prior to cue as baseline';


    save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id) '_ref_cuect.mat'],'z2_oi','readme2');

    save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id) '_unref_cuect.mat'],'z4_oi','readme4');



% z2
    figure; colormap(jet)

    t=linspace(-1.5,2.5,size(z2,1));
    imagesc(t, fq, z2(:,:,ch_idx)');set(gca, 'YDir', 'Normal');

    caxis([-10,10]); box off;% remove upper and right lines

    
    hold on; plot([0,0],ylim,'k--'); 
    

    xlabel('Time (s)'); % x-axis label
    ylabel('Frequency (Hz)'); % y-axis label

    saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
        'contact_' num2str(contact_id) '_ref_cuect','fig']);
    close all;

% z4
    figure; colormap(jet)

    t=linspace(-1.5,2.5,size(z4,1));
    imagesc(t, fq, z4(:,:,ch_idx)');set(gca, 'YDir', 'Normal');

    caxis([-10,10]); box off;% remove upper and right lines

    hold on;
    plot([0,0],ylim,'k--'); 
    
    xlabel('Time (s)'); % x-axis label
    ylabel('Frequency (Hz)'); % y-axis label

    saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
        'contact_' num2str(contact_id) '_unref_cuect','fig']);
    close all;            

    disp(['contact_' num2str(contact_id)]);
end
end