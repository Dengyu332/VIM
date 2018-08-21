% follows DW_batch_subcort_single_contact_hilbert.m
% takes in data under /Volumes/Nexus/Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/
% generate grand average activity of different band

% imitate the routine of DW_batch_VLa2VLp_band_activity_comparison.m

%specify machine
DW_machine;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

band_selection = {'alpha','lowbeta','highbeta','highgamma'};
ref_selection = {'unref','ref'};
locking_selection = {'spct','cuect'};
group_selection = {'grand','lead','macro'};

% loop through groups first

grand_idx = [1:12,19:95];

lead_idx = [40:95];

macro_idx = [1:12,19:39];

group_ids = {grand_idx,lead_idx,macro_idx};

for group_order = 1:3

    clearvars -except band_selection Choice contact_info dionysis dropbox grand_idx group_ids group_selection lead_idx  ...
          locking_selection macro_idx   ref_selection  group_order;
    
    
    %name of the group
    group_name = group_selection{group_order};
    
    % contact id of this group
    group_idx = group_ids{group_order};
    
    % then loop through band
    for band_id = 1:4
        
        band_name = band_selection{band_id}; % name of the band
        
        % then loop through reference selection
        for ref_id = 1:2
            ref_name = ref_selection{ref_id}; % ref or not
            
            % finally select between cue lock and spon lock
            
            for locking_id = 1:2
                
                if locking_id == 1 % spct
                    
                    locking_name = locking_selection{locking_id};
                    
                    z_total = [];
                    n_total = 0;
                    cue_total = 0;
                    sp_total = 0;
                    
                    for contact_id = group_idx % loop through contact group of interest
                        
                        % load in the file specified by contact_id,
                        % band_name, ref_name and locking selection
                        
                        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
                            num2str(contact_id) '_' band_name '_' ref_name '_' locking_name '.mat']);
                        
                        n_total = n_total + 1;
                        
                        z_total(:,:,n_total) = z;
                        
                        cue_total = cue_total + avg_cue;
                        
                        sp_total = sp_total + avg_word_off;
                    end
                        
                    % get average data

                    z_avg =  mean(z_total,3);

                    cue_total_mean = cue_total/n_total;

                    sp_total_mean = sp_total / n_total;

                    % plot

                    t = linspace(-2,2,4001);

                    figure;

                    plot(t,smooth(z_avg,100),'LineWidth',3);

                    hold on; plot([0,0],ylim,'--k');

                    hold on; plot([cue_total_mean,cue_total_mean],ylim,'--k');
                    hold on; plot([sp_total_mean,sp_total_mean],ylim,'--k');

                    set(gca,'box','off');
                    xlabel('Time (s)'); % x-axis label
                    ylabel([band_name ' z-score']); % y-axis label

                    saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/band_grand_avg/'...
                        group_name '_' band_name '_' ref_name '_' locking_name '.fig']);

                    close all;
                
                else % cue lock

                    locking_name = locking_selection{locking_id};
                    
                    z_total = [];
                    n_total = 0;
                    spon_total = 0;
                    spoff_total = 0;
                    
                    for contact_id = group_idx % loop through contact group of interest
                        
                        % load in the file specified by contact_id,
                        % band_name, ref_name and locking selection
                        
                        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
                            num2str(contact_id) '_' band_name '_' ref_name '_' locking_name '.mat']);
                        
                        n_total = n_total + 1;
                        
                        z_total(:,:,n_total) = z;
                        
                        spon_total = spon_total + avg_word_on;
                        
                        spoff_total = spoff_total + avg_word_off;
                    end
                        
                    % get average data

                    z_avg =  mean(z_total,3);

                    spon_total_mean = spon_total/n_total;

                    spoff_total_mean = spoff_total / n_total;

                    % plot

                    t = linspace(-1.5,2.5,4001);

                    figure;

                    plot(t,smooth(z_avg,100),'LineWidth',3);

                    hold on; plot([0,0],ylim,'--k');

                    hold on; plot([spon_total_mean,spon_total_mean],ylim,'--k');
                    hold on; plot([spoff_total_mean,spoff_total_mean],ylim,'--k');

                    set(gca,'box','off');
                    xlabel('Time (s)'); % x-axis label
                    ylabel([band_name ' z-score']); % y-axis label

                    saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/band_grand_avg/'...
                        group_name '_' band_name '_' ref_name '_' locking_name '.fig']);

                    close all;
                end
            end
        end
    end
end                