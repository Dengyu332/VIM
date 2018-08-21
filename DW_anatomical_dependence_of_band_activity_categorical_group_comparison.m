% first created on 08/10/2018

% follows DW_generate_band_activity_z_table.m and
% DW_categorizing_contacts.m

% Categorical and Group comparison of VLa vs. VLp in terms of band response
% activity

% categorical way (VLa vs. VLp), and use whole subject group to do
% comparison

% statistical method: 1. hypothesis test 2. regression with controling for
% irrelevant variables

%generate categorical_group_comparison.mat under [dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/']

%% Hypothesis test: two-sample t test and Mann-Whitney U-test

% specify machine
DW_machine;

% load in contact location info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);

% loop configuration
ref_selection = {'unref', 'ref'};
band_selection = {'alpha', 'lowbeta', 'highbeta', 'highgamma'};
test_selection = {'t_test', 'MWW_test'};

% select which subgroup you want to look at
group_selection = {'grand','left','right','lead','lead_left','lead_right','macro'};

grand_idx = [1:95];
left_idx = find(strcmp('left',extractfield(contact_info,'side')));
right_idx = find(strcmp('right',extractfield(contact_info,'side')));

lead_idx = [40:95];
lead_left_idx = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[1:39]);
lead_right_idx = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[1:39]);

macro_idx = [1:39];

group_ids = {grand_idx,left_idx,right_idx,lead_idx,lead_left_idx,lead_right_idx,macro_idx};

ttest_table = table; % initialize t test p value table

%loop through bands
for band_id = 1:4
    band_name = band_selection{band_id};
    
    %loop through ref
    for ref_id = 1:2
        ref_name = ref_selection{ref_id};
        ttest_table(ref_id - 2 + 2 * band_id,1) = {[ref_name,'_', band_name]};
        z_column = extractfield(z_table,[ref_name,'_', band_name]);
        
        % loop through groups
        for group_order = 1:7
            group_name = group_selection{group_order};
            group_idx = group_ids{group_order};
            VLa_oi = intersect(group_idx, find(strcmp('VLa',extractfield(contact_info,'group_used'))));
            VLp_oi = intersect(group_idx, find(strcmp('VLp',extractfield(contact_info,'group_used'))));
            
            for test_id = 1:2 % select test methods
                if test_id == 1 % ttest
                    [~,p] = ttest2(z_column(VLa_oi), z_column(VLp_oi));
                    ttest_table(ref_id - 2 + 2 * band_id,group_order * 2 ) = {p};
                else % ranksum test
                    p = ranksum(z_column(VLa_oi), z_column(VLp_oi));
                    ttest_table(ref_id - 2 + 2 * band_id,group_order * 2+1 ) = {p};
                end
            end
        end
    end
end

for i = 1:15 % assign column names to ttable
    if i == 1
        ttest_table.Properties.VariableNames{['Var' num2str(i)]} = 'name';
    elseif mod(i,2) % odd
        ttest_table.Properties.VariableNames{['Var' num2str(i)]} = [cell2mat(group_selection(floor(i/2))),'_ranksum'];
    else % even
        ttest_table.Properties.VariableNames{['Var' num2str(i)]} = [cell2mat(group_selection(floor(i/2))),'_ttest'];
    end
end

%% fit glm and glme
clearvars -except ttest_table;

% specify machine
DW_machine;

% load in contact location info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);


% convert contact_info from struct to table, for regression modeling
info_table = struct2table(contact_info);

% add one column of recording type
for i = 1:height(info_table)
    if ismember(i,[1:39])
        info_table.recording_type(i) = {'macro'};
    else
        info_table.recording_type(i) = {'lead'};
    end
end

% convert z_table from struct to table variable, for regression modeling
val_table = struct2table(z_table);

mtable = join(info_table,val_table);


% include contacts which belong to VLa or VLp
mtable = mtable(find(strcmp('VLa',mtable.group_used) | strcmp('VLp',mtable.group_used)),:);


column_selection = mtable.Properties.VariableNames(end-7:end);

reg_table = table;




% first glm

% construct template for modelspec, there are in total four combination
model_selection = {'',' + side', ' + recording_type',' + side + recording_type'};

mdl = struct;% store all results in mdl

% loop through different bands and different ref options
for column_id = 1:8
    column_name = column_selection{column_id};
    
    % loop through regression models
    for model_id = 1:4
        model_name = model_selection{model_id};
        
        modelspec = [column_name ' ~ 1 + group_used' model_name];
        
        glm_model(model_id) = {modelspec};
        
        mdl(column_id*4 - 4 + model_id).sum = fitglm(mtable,modelspec);
        
        reg_table(column_id,1) = {column_name};
        
        
        
        which_p = find(strcmp('group_used_VLp', mdl(column_id * 4 - 4 + model_id).sum.CoefficientNames));
        
        p_oi = mdl(column_id * 4 - 4 + model_id).sum.Coefficients.pValue(which_p);
        

        reg_table(column_id,model_id+1) = {p_oi};
        
    end
end

% then glme
% construct template for modelspec, there are in total four combination
model_selection = {' + ',' + side + ', ' + recording_type + ',' + side + recording_type + '};

mdl = struct; % store all results in mdl

% loop through different bands and different ref options



for column_id = 1:8
    column_name = column_selection{column_id};
    
    % loop through regression models
    for model_id = 1:4
        model_name = model_selection{model_id};
        
        modelspec = [column_name ' ~ 1 + group_used' model_name '(1|subject_id)'];
        
        glme_model(model_id) = {modelspec};
        
        mdl(column_id*4 - 4 + model_id).sum = fitglme(mtable,modelspec);
        
        
        
        
        
        which_p = find(strcmp('group_used_VLp', mdl(column_id * 4 - 4 + model_id).sum.Coefficients.Name));
        
        p_oi = mdl(column_id * 4 - 4 + model_id).sum.Coefficients.pValue(which_p);

        reg_table(column_id,model_id+5) = {p_oi};
        
    end
end

% give column name to reg_table
reg_table.Properties.VariableNames{1} = 'name';
reg_table.Properties.VariableNames{2} = 'glm1';
reg_table.Properties.VariableNames{3} = 'glm2';
reg_table.Properties.VariableNames{4} = 'glm3';
reg_table.Properties.VariableNames{5} = 'glm4';
reg_table.Properties.VariableNames{6} = 'glme1';
reg_table.Properties.VariableNames{7} = 'glme2';
reg_table.Properties.VariableNames{8} = 'glme3';
reg_table.Properties.VariableNames{9} = 'glme4';


reg_table; ttest_table;glm_model;glme_model;

readme = 'Anatomical dependence of band activity, catogorical way; group comparison; hypothesis test and regression methods used';

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/categorical_group_comparison.mat'],...
    'ttest_table','reg_table','glm_model','glme_model','readme');