% first created on 08/18

% follows
% DW_anatomical_dependence_of_band_activity_continuous_group_comparison.m
% based on previous script, we identify activity-correlated axis and
% principle compoents not controlling for subjects and recording type
% and we further do linear regression controlling for subject_id and recording_type

% takes in contact_info_step2.mat, z_table.mat and continuous_group_comparison.mat

% strategy: for each combination, we do glme for each axis and component

% PCA has x1, x2, x3, and axis has X, Y Z

% for each band+ref+group combination, control for recording_type and
% subject_id

% generate controlled_continuous_group_comparison.mat under 
% Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/

% specify machine
DW_machine;

% load in contact location info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);

% load in continuous_group_comparison.mat
load([dionysis...
    'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/continuous_group_comparison.mat']);

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

% mtable is the table we use in subsequent steps

%% generate groups
group_selection = {'left','right','lead_left','lead_right','macro_left'};

left_idx = find(strcmp('left',extractfield(contact_info,'side')));
right_idx = find(strcmp('right',extractfield(contact_info,'side')));
lead_left_idx = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[1:39]);
lead_right_idx = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[1:39]);
macro_left_idx = intersect(find(strcmp('left',extractfield(contact_info,'side'))),[1:39]);

group_ids = {left_idx,right_idx,lead_left_idx,lead_right_idx,macro_left_idx};

%% band and ref selection
column_selection = {'unref_alpha','ref_alpha','unref_lowbeta','ref_lowbeta',...
    'unref_highbeta','ref_highbeta','unref_highgamma','ref_highgamma'};


%%

Axis_selection = {'X','Y','Z'};
PCA_selection = {'x1','x2','x3'};

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
    control_stat(combination_idx).X = fitglme(table_oi,[column_name ' ~ 1 + X + recording_type + (1|subject_id)']);

    control_stat(combination_idx).Y = fitglme(table_oi,[column_name ' ~ 1 + Y + recording_type + (1|subject_id)']);

    control_stat(combination_idx).Z = fitglme(table_oi,[column_name ' ~ 1 + Z + recording_type + (1|subject_id)']);

    % x1, x2, x3
    control_stat(combination_idx).x1 = fitglme(table_oi,[column_name ' ~ 1 + x1 + recording_type + (1|subject_id)']);

    control_stat(combination_idx).x2 = fitglme(table_oi,[column_name ' ~ 1 + x2 + recording_type + (1|subject_id)']);

    control_stat(combination_idx).x3 = fitglme(table_oi,[column_name ' ~ 1 + x3 + recording_type + (1|subject_id)']);
  
end

readme = 'For each combination, do glme for each axis and component, controlling for subject and recording_type';

save([dionysis ...
    'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/controlled_continuous_group_comparison.mat'],...
    'control_stat','readme');