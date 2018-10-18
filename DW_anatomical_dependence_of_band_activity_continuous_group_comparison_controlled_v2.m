% first created on 09/16

% refer to DW_anatomical_dependence_of_band_activity_continuous_group_comparison_controlled.m

% follows
% DW_anatomical_dependence_of_band_activity_continuous_group_comparison_v2.m

% takes in contact_info_step2.mat, z_table2.mat and continuous_group_comparison.mat (v2)

% strategy: for each combination, we do glme for each axis and component

% PCA has x1, x2, x3, and axis has X, Y Z

% for each band+ref+group combination, control for: 0 (suffix): subject_id; 1:
% subject_id + recording_type; 2: subject_id + recording_type + side

% generate controlled_continuous_group_comparison.mat under 
% Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity_0916/

% specify machine
DW_machine;

% load in contact location info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table2.mat']);

% load in continuous_group_comparison.mat
load([dionysis...
    'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity_0916/continuous_group_comparison.mat']);

%% construct table for linear model

% get grand coords matrix of all contacts
grand_coord = reshape(extractfield(contact_info,'mni_coords'),[3,size(contact_info,2)])';

% convert coords to table
grand_coord_tbl = table(grand_coord(:,1),grand_coord(:,2),grand_coord(:,3),'VariableNames',{'X','Y','Z'});

% convert z to table
z_table = struct2table(z_table);

% This is a table of coordinates and z value
glmtable = [grand_coord_tbl,z_table];

% then we need to add contact_info to the table
info_table = struct2table(contact_info);

for i = 1:height(info_table)
    if ismember(i,[1:39])
        info_table.recording_type(i) = {'macro'};
    else
        info_table.recording_type(i) = {'lead'};
    end
end

mtable = join(glmtable,info_table);

for i = 1:height(mtable)
    if mtable.X(i) > 0
        mtable.X(i) = -mtable.X(i);
    end
end


% mtable is the table we use in subsequent steps

%% generate groups
group_selection = {'all','lead','macro'};

all_idx = [1:95];
lead_idx = intersect(40:95, all_idx);
macro_idx = intersect(1:39, all_idx);

group_ids = {all_idx,lead_idx,macro_idx};
%% band and ref selection
column_selection = {'unref_alpha','ref_alpha','unref_lowbeta','ref_lowbeta',...
    'unref_highbeta','ref_highbeta','unref_highgamma','ref_highgamma'};




%% start the loop

for combination_idx = 1:length(big_stat)
    column_name = big_stat(combination_idx).band; % name of the column
    group_name = big_stat(combination_idx).group; % name of the group
    
    group_idx = group_ids{find(strcmp(group_name,group_selection))}; % contact_oi
    
    table_oi = mtable(group_idx,:);
    
    pca_table = table(big_stat(combination_idx).PCA.score(:,1),big_stat(combination_idx).PCA.score(:,2),big_stat(combination_idx).PCA.score(:,3),...
        'VariableNames',{'x1', 'x2', 'x3'});
   
    table_oi = [table_oi,pca_table];
    
    control_stat(combination_idx).band = column_name;
    control_stat(combination_idx).group = group_name;
    
    % X, Y, Z
    control_stat(combination_idx).X0 = fitglme(table_oi,[column_name ' ~ 1 + X + (1|subject_id)']);

    control_stat(combination_idx).Y0 = fitglme(table_oi,[column_name ' ~ 1 + Y  + (1|subject_id)']);

    control_stat(combination_idx).Z0 = fitglme(table_oi,[column_name ' ~ 1 + Z  + (1|subject_id)']);
    
    control_stat(combination_idx).X1 = fitglme(table_oi,[column_name ' ~ 1 + X + recording_type + (1|subject_id)']);

    control_stat(combination_idx).Y1 = fitglme(table_oi,[column_name ' ~ 1 + Y + recording_type + (1|subject_id)']);

    control_stat(combination_idx).Z1 = fitglme(table_oi,[column_name ' ~ 1 + Z + recording_type + (1|subject_id)']);
    
    control_stat(combination_idx).X2 = fitglme(table_oi,[column_name ' ~ 1 + X + recording_type + side + (1|subject_id)']);

    control_stat(combination_idx).Y2 = fitglme(table_oi,[column_name ' ~ 1 + Y + recording_type + side + (1|subject_id)']);

    control_stat(combination_idx).Z2 = fitglme(table_oi,[column_name ' ~ 1 + Z + recording_type + side + (1|subject_id)']);    

    % x1, x2, x3
    control_stat(combination_idx).x10 = fitglme(table_oi,[column_name ' ~ 1 + x1  + (1|subject_id)']);

    control_stat(combination_idx).x20 = fitglme(table_oi,[column_name ' ~ 1 + x2 + (1|subject_id)']);

    control_stat(combination_idx).x30 = fitglme(table_oi,[column_name ' ~ 1 + x3 + (1|subject_id)']);
    
    control_stat(combination_idx).x11 = fitglme(table_oi,[column_name ' ~ 1 + x1 + recording_type + (1|subject_id)']);

    control_stat(combination_idx).x21 = fitglme(table_oi,[column_name ' ~ 1 + x2 + recording_type + (1|subject_id)']);

    control_stat(combination_idx).x31 = fitglme(table_oi,[column_name ' ~ 1 + x3 + recording_type + (1|subject_id)']);
    
    control_stat(combination_idx).x12 = fitglme(table_oi,[column_name ' ~ 1 + x1 + recording_type + side + (1|subject_id)']);

    control_stat(combination_idx).x22 = fitglme(table_oi,[column_name ' ~ 1 + x2 + recording_type + side + (1|subject_id)']);

    control_stat(combination_idx).x32 = fitglme(table_oi,[column_name ' ~ 1 + x3 + recording_type + side + (1|subject_id)']);    
  
end

readme = 'For each combination, do glme for each axis and component, controlling for: 0: subject; 1: subject + recording_type; 2: subject + recording_type + side';

save([dionysis ...
    'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity_0916/controlled_continuous_group_comparison.mat'],...
    'control_stat','readme');