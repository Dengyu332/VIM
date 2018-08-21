% follows DW_batch_subcort_single_contact_hilbert.m
% takes in data under /Volumes/Nexus/Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/
% generate figures of VLa vs. VLp of different bands under band_region_comparison_raw
% raw version
% loops a lot haha

%specify machine
DW_machine;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

band_selection = {'alpha','lowbeta','highbeta','highgamma'};
ref_selection = {'unref','ref'};
locking_selection = {'spct','cuect'};
group_selection = {'grand','left','right','lead','lead_left','lead_right','macro','macro_left','macro_right'};

% loop through groups first

grand_idx = [1:12,19:95]; 
left_idx = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[13:18]);
right_idx = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[13:18]);

lead_idx = [40:95];
lead_left_idx = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[1:39]);
lead_right_idx = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[1:39]);

macro_idx = [1:12,19:39];
macro_left = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[13:18,40:95]);
macro_right = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[13:18,40:95]);

group_ids = {grand_idx,left_idx,right_idx,lead_idx,lead_left_idx,lead_right_idx,macro_idx,macro_left,macro_right};


for group_order = 1:9
    
    clearvars -except band_selection Choice contact_info dionysis dropbox grand_idx group_ids group_selection lead_idx lead_left_idx ...
        lead_right_idx left_idx locking_selection macro_idx macro_left macro_right ref_selection right_idx group_order;
    
    
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
                

                
                switch locking_id
                    case 1 % spct
                        locking_name = locking_selection{locking_id};
                        
                        
                        z_VLa = [];z_VLp = [];
                        VLa_n = 0; VLp_n = 0; 
                        cue_VLa = 0; cue_VLp = 0;
                        sp_VLa = 0; sp_VLp = 0;                         
                        
                        
                        for contact_id = group_idx % loop through contact group of interest
                            
                            % load in the file specified by contact_id,
                            % band_name, ref_name and locking selection
                            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
                                num2str(contact_id) '_' band_name '_' ref_name '_' locking_name '.mat']);
                            
                            if strcmp('VLa',contact_info(contact_id).group_used)
                                VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
                            elseif strcmp('VLp',contact_info(contact_id).group_used)
                                VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
                            end
                        end
                        
                        % get average data for each group

                        % VLa
                        z_VLa_avg = mean(z_VLa,3);
                        cue_VLa_avg = cue_VLa / VLa_n;
                        sp_VLa_avg = sp_VLa / VLa_n;

                        % VLp
                        z_VLp_avg = mean(z_VLp,3);
                        cue_VLp_avg = cue_VLp / VLp_n;
                        sp_VLp_avg = sp_VLp / VLp_n;                        

                        % plot
                        t = linspace(-2,2,4001);
                        figure;
                        plot(t,z_VLa_avg); hold on;plot(t,z_VLp_avg);

                        hold on; plot([0,0],ylim,'LineStyle','--','Color',[160 32 240]/256); 

                        hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);
                        hold on; plot([sp_VLa_avg,sp_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);

                        hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);
                        hold on; plot([sp_VLp_avg,sp_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);

                        set(gca,'box','off');
                        xlabel('Time (s)'); % x-axis label
                        ylabel([band_name ' z-score']); % y-axis label
                        legend('VLa','VLp');

                        saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/band_region_comparison_raw/'...
                            group_name '_VLa_vs_VLp_' band_name '_' ref_name '_' locking_name '.fig']);
                        
                        close all;
                            
                        
                        
                    case 2 % cuect
               
                        locking_name = locking_selection{locking_id};
                        
                        
                        z_VLa = [];z_VLp = [];
                        VLa_n = 0; VLp_n = 0; 
                        spon_VLa = 0; spon_VLp = 0;
                        spoff_VLa = 0; spoff_VLp = 0;                         
                        
                        
                        for contact_id = group_idx % loop through contact group of interest
                            
                            % load in the file specified by contact_id,
                            % band_name, ref_name and locking selection
                            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
                                num2str(contact_id) '_' band_name '_' ref_name '_' locking_name '.mat']);
                            
                            if strcmp('VLa',contact_info(contact_id).group_used)
                                VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z; spon_VLa = spon_VLa + avg_word_on; spoff_VLa = spoff_VLa + avg_word_off;
                            elseif strcmp('VLp',contact_info(contact_id).group_used)
                                VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z; spon_VLp = spon_VLp + avg_word_on; spoff_VLp = spoff_VLp + avg_word_off;
                            end
                        end
                        
                        % get average data for each group

                        % VLa
                        z_VLa_avg = mean(z_VLa,3);
                        spon_VLa_avg = spon_VLa / VLa_n;
                        spoff_VLa_avg = spoff_VLa / VLa_n;

                        % VLp
                        z_VLp_avg = mean(z_VLp,3);
                        spon_VLp_avg = spon_VLp / VLp_n;
                        spoff_VLp_avg = spoff_VLp / VLp_n;                        

                        % plot
                        t = linspace(-1.5,2.5,4001);
                        figure;
                        plot(t,z_VLa_avg); hold on;plot(t,z_VLp_avg);

                        hold on; plot([0,0],ylim,'LineStyle','--','Color',[160 32 240]/256); 

                        hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);
                        hold on; plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);

                        hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);
                        hold on; plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);

                        set(gca,'box','off');
                        xlabel('Time (s)'); % x-axis label
                        ylabel([band_name ' z-score']); % y-axis label
                        legend('VLa','VLp');

                        saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/band_region_comparison_raw/'...
                            group_name '_VLa_vs_VLp_' band_name '_' ref_name '_' locking_name '.fig']);
                        
                        close all;
                end
            end
        end
    end
end