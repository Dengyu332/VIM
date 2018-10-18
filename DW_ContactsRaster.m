% first created on 09/12/2018
% inspect on 09/13/2018
% edit on 09/15/2018: plot highgamma and lowbeta in one script

% follows DW_SingleTrialDetection_edition1 (or 2).m and DW_batch_subcort_single_contact_hilb_pertrial.m
% takes in files under v2/TimingAnalysis (or 2)/ContactsLatency and v2/contact_level_pertrial_band_activity/
% purpose: hg or lb raster plot for all contacts' sessions that are
% significantly activated of respective bands during speech production

% specify machine
DW_machine

temp = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/TimingAnalysis2/ContactsLatency/'...
'contact_*.mat']);

fs = 1000;

for i_order = 1:length(temp)
    
    % decide band type according to temp(i_order).name
    if strcmp(temp(i_order).name(end-14:end-4),'lowbeta_ref')
        band_id = 1; % lowbeta_ref
    else
        band_id = 2; % highgamma_ref
    end
    
    clearvars -except dionysis dropbox i_order temp fs band_id
    
    % load in timing table and data
    load([temp(i_order).folder filesep temp(i_order).name]);
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_pertrial_band_activity/' ...
        temp(i_order).name]);
    
    % sort z_oi and epoch_oi according to the trialorder stored in timing
    % table
    st_z = z_oi(ephy_timing.TrialOrder); % each trial is 2s precue to 2s post speech offset
    st_epoch = epoch_oi(ephy_timing.TrialOrder,:);
    
    tr2del = find(isnan(ephy_timing.ActOn)); % delete trials whose ActOn is missing (because trial_oi not activated)
    
    st_z(tr2del) = [];
    st_epoch(tr2del,:) = [];
    ephy_timing(tr2del,:) = [];
    
    st_z_smooth = cellfun(@(x) smooth(x',200)',st_z,'UniformOutput',0);% now the period is still 2s precue to 2s post speech off    
    
    %after smoothing, data is diluted, so we need to re-normalize it

    %baseline (which is 1s pre-cue)
    Bt = cellfun(@(x) x(1001:2000), st_z_smooth, 'UniformOutput',0);
    
    % normalize to baseline
    zz = cellfun(@(x,y) (x-mean(y))./std(y), st_z_smooth, Bt,'UniformOutput',0);
    
    % define region to be plotted
    
    roi_starts = num2cell((st_epoch.stimulus_starts - st_epoch.starts - 0.5) * fs + 1)'; % 0.5s precue
    
    % default roi_ends is 3s post cue, but if the min length of trials
    % is less than 5s, then use the shortest trial length as common
    % length
    if min(cell2mat(cellfun(@length, zz, 'UniformOutput',0))) < 5000 %  
       length_used = floor(min(cell2mat(cellfun(@length, zz, 'UniformOutput',0)))/100) * 100;

       roi_ends = num2cell(repmat(length_used,[1 length(zz)]));

    else
       roi_ends = num2cell((st_epoch.stimulus_starts - st_epoch.starts + 3) * fs)';
    end
    
    zz_crop = cellfun(@(x,y,z) z(x:y), roi_starts, roi_ends, zz,'UniformOutput',0);
    
    plot_mat = cell2mat(zz_crop');
    
    figure;
    
    tp = linspace(-0.5, length(plot_mat)/1000 -0.5 - 0.001, length(plot_mat));
    imagesc(tp,[1:size(plot_mat,1)],plot_mat); set(gca, 'YDir', 'Normal');
    
    c = jet; new_cm = c; new_cm(1:5,:)  = []; colormap(new_cm);
    
    % adjust some plotting parameters according to different bands plotted
    switch band_id
        case 1
            
            caxis([-4,6]);

            hold on; time_spon =plot(ephy_timing.ReactionT,(1:length(ephy_timing.ReactionT)),'-k');
            hold on; plot(ephy_timing.ActOn,(1:length(ephy_timing.ActOn)),'r*','MarkerSize',5); % red for lb
        %   hold on; plot(ephy_timing.ActMax,(1:length(ephy_timing.ActMax)),'k*','MarkerSize',5);
        %   hold on; plot(ephy_timing.ActOff,(1:length(ephy_timing.ActOff)),'m*','MarkerSize',5);
        case 2
            caxis([-6, 8]);
            hold on; time_spon =plot(ephy_timing.ReactionT,(1:length(ephy_timing.ReactionT)),'-k');
            hold on; plot(ephy_timing.ActOn,(1:length(ephy_timing.ActOn)),'b*','MarkerSize',5); % blue for hg
        %   hold on; plot(ephy_timing.ActMax,(1:length(ephy_timing.ActMax)),'k*','MarkerSize',5);
        %   hold on; plot(ephy_timing.ActOff,(1:length(ephy_timing.ActOff)),'m*','MarkerSize',5);
    end
        
    hh = gca;
    set(hh,'box','off');
    set(hh,'TickLength',[0.005,0.005])

    pcolorbar = colorbar;
    set(pcolorbar,'TickLength',[]);
    pcolorbar.Label.String = "z-score";
    
    xlabel("Time Relative to Cue Onset (s)");
    ylabel("Trial Number");
    
    saveas(gcf, [dionysis 'Users/dwang/VIM/Results/New/v2/TimingAnalysis3/ContactRaster/' temp(i_order).name(1:end-4) '.fig']);
    close all;
    
end   