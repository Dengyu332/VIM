% first created on 08/08/2018
%follows DW_generate_band_activity_z_table.m and DW_plot_contact_location.m
% generate 3-D plots of contact location-band activity relation under
% 'Users/dwang/VIM/Results/New/v2/pos_power_relation/pos_power_plot/'

% specify machine
DW_machine;

% load in contact location info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);

% load in colormap that's used
load([dropbox 'Functions/Dengyu/General/cm_g2r.mat']);


% group
group_selection = {'left','right','lead_left','lead_right'};

left_idx = find(strcmp('left',extractfield(contact_info,'side')));
right_idx = find(strcmp('right',extractfield(contact_info,'side')));
lead_left_idx = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[1:39]);
lead_right_idx = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[1:39]);

group_ids = {left_idx,right_idx,lead_left_idx,lead_right_idx};

% band and ref selection
column_selection = {'unref_alpha','ref_alpha','unref_lowbeta','ref_lowbeta',...
    'unref_highbeta','ref_highbeta','unref_highgamma','ref_highgamma'};

z_matrix = [];
for col_idx = 1:8
    z_matrix(:,col_idx) = extractfield(z_table,column_selection{col_idx})';
end

prct_95 = prctile(z_matrix,95,1);
prct_5 = prctile(z_matrix,5,1);
prct_50 =  prctile(z_matrix,50,1);
prct_75 = prctile(z_matrix,75,1);
prct_25 = prctile(z_matrix,25,1);
prct_10 = prctile(z_matrix,10,1);
prct_90 = prctile(z_matrix,90,1);

% specify the lower and upper limits of colorbar for each type
lowerlims = [-4,-5,-3,-5,-2,-3,-2,-0.5];
upperlims = [1,0.5,1,-0.5,0,0,2,2.5];



grand_coord = reshape(extractfield(contact_info,'mni_coords'),[3,size(contact_info,2)])';

% loop through groups
for group_order = 1:4
    
    
    %name of the group
    group_name = group_selection{group_order};

    % contact id of this group
    group_idx = group_ids{group_order};
    
    coord_oi = grand_coord(group_idx,:);
    
    Xs = coord_oi(:,1);
    Ys = coord_oi(:,2);
    Zs = coord_oi(:,3);
    
    for column_id = 1:8
        column_name = column_selection{column_id};
        
        z_col = extractfield(z_table,column_name);
        z_oi = z_col(group_idx)';
        
        figure;
        scatter3(Xs,Ys,Zs,50,z_oi,'filled')
        
        colormap(cm_g2r);
        cc = colorbar;
        caxis([lowerlims(column_id) upperlims(column_id)]);
        
        cc.Label.String = 'z-score';
        
        if ismember(group_order,[1,3])
            xlabel('lateral-medial (mm)');
        else
            xlabel('medial-lateral (mm)');
        end
        
        ylabel('anterior-posterior (mm)');
        zlabel('ventral-dorsal (mm)');
        
        saveas(gcf,['/Volumes/Nexus/Users/dwang/VIM/Results/New/v2/pos_power_relation/pos_power_plot/'...
            group_name '_' column_name],'fig')
        
        close all;
        
    end
end  