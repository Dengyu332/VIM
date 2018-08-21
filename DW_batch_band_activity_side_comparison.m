% follows DW_batch_subcort_single_contact_hilbert.m
% takes in data under /Volumes/Nexus/Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/
% compare left vs. right activity of different group and different bands

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
                    
                    z_left = [];z_right = [];
                    left_n = 0; right_n = 0;
                    cue_left = 0; cue_right = 0;
                    sp_left = 0; sp_right = 0;
                    
                    for contact_id = group_idx % loop through contact group of interest
                        
                        % load in the file specified by contact_id,
                        % band_name, ref_name and locking selection
                        
                        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
                            num2str(contact_id) '_' band_name '_' ref_name '_' locking_name '.mat']);                        
                        
                        if strcmp('left',contact_info(contact_id).side)
                            left_n = left_n + 1; z_left(:,:,left_n) = z; cue_left = cue_left + avg_cue; sp_left = sp_left + avg_word_off;
                        elseif strcmp('right',contact_info(contact_id).side)
                            right_n = right_n + 1; z_right(:,:,right_n) = z; cue_right = cue_right + avg_cue; sp_right = sp_right + avg_word_off;
                        end
                    end
                    
                    % get average data for each group

                    % left
                    z_left_avg = mean(z_left,3);
                    cue_left_avg = cue_left / left_n;
                    sp_left_avg = sp_left / left_n;

                    % right
                    z_right_avg = mean(z_right,3);
                    cue_right_avg = cue_right / right_n;
                    sp_right_avg = sp_right / right_n;
                    
                    % plot
                    t = linspace(-2,2,4001);
                    figure;
                    plot(t,smooth(z_left_avg,100),'LineWidth',3); hold on;plot(t,smooth(z_right_avg,100),'LineWidth',3);

                    hold on; plot([0,0],ylim,'LineStyle','--','Color',[160 32 240]/256); 

                    hold on; plot([cue_left_avg,cue_left_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);
                    hold on; plot([sp_left_avg,sp_left_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);

                    hold on; plot([cue_right_avg,cue_right_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);
                    hold on; plot([sp_right_avg,sp_right_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);

                    set(gca,'box','off');
                    xlabel('Time (s)'); % x-axis label
                    ylabel([band_name ' z-score']); % y-axis label
                    legend('left','right');

                    saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/band_side_comparison/'...
                        group_name '_left_vs_right_' band_name '_' ref_name '_' locking_name '.fig']);

                    close all;
                    
                else % cue lock
                    
                    locking_name = locking_selection{locking_id};
                    
                    z_left = [];z_right = [];
                    left_n = 0; right_n = 0;
                    spon_left = 0; spon_right = 0;
                    spoff_left = 0; spoff_right = 0;
                    
                    for contact_id = group_idx % loop through contact group of interest
                        
                        % load in the file specified by contact_id,
                        % band_name, ref_name and locking selection
                        
                        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
                            num2str(contact_id) '_' band_name '_' ref_name '_' locking_name '.mat']);                        
                        
                        if strcmp('left',contact_info(contact_id).side)
                            left_n = left_n + 1; z_left(:,:,left_n) = z; spon_left = spon_left + avg_word_on; spoff_left = spoff_left + avg_word_off;
                        elseif strcmp('right',contact_info(contact_id).side)
                            right_n = right_n + 1; z_right(:,:,right_n) = z; spon_right = spon_right + avg_word_on; spoff_right = spoff_right + avg_word_off;
                        end
                    end
                    
                    % get average data for each group

                    % left
                    z_left_avg = mean(z_left,3);
                    spon_left_avg = spon_left / left_n;
                    spoff_left_avg = spoff_left / left_n;

                    % right
                    z_right_avg = mean(z_right,3);
                    spon_right_avg = spon_right / right_n;
                    spoff_right_avg = spoff_right / right_n;
                    
                    % plot
                    t = linspace(-1.5,2.5,4001);
                    figure;
                    plot(t,smooth(z_left_avg,100),'LineWidth',3); hold on;plot(t,smooth(z_right_avg,100),'LineWidth',3);

                    hold on; plot([0,0],ylim,'LineStyle','--','Color',[160 32 240]/256); 

                    hold on; plot([spon_left_avg,spon_left_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);
                    hold on; plot([spoff_left_avg,spoff_left_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);

                    hold on; plot([spon_right_avg,spon_right_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);
                    hold on; plot([spoff_right_avg,spoff_right_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);

                    set(gca,'box','off');
                    xlabel('Time (s)'); % x-axis label
                    ylabel([band_name ' z-score']); % y-axis label
                    legend('left','right');

                    saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/band_side_comparison/'...
                        group_name '_left_vs_right_' band_name '_' ref_name '_' locking_name '.fig']);

                    close all;
                end
            end
        end
    end
end                  