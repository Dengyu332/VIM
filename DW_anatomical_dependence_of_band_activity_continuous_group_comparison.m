% first created on 08/17/2018
% follows DW_generate_band_activity_z_table.m and DW_categorizing_contacts.m
% takes in contact_info_step2.mat and z_table
% continuous way of investigating anatomical dependence of band activity
% during speech production

% doesn't control for subject and recording type

% generate continuous_group_comparison.mat under
% dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/

% specify machine
DW_machine;

% load in contact location info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);

% generate a complexed table that is used thorougout the script

z_table = struct2table(z_table); % convert to table format

grand_coord = reshape(extractfield(contact_info,'mni_coords'),[3,size(contact_info,2)])';% get grand coords matrix of all contacts

grand_coord_tbl = table(grand_coord(:,1),grand_coord(:,2),grand_coord(:,3),'VariableNames',{'X','Y','Z'});


model_table = [grand_coord_tbl,z_table];% This is the final table generated

% downstream we only need model_table and contact_info struct

clearvars -except dionysis dropbox contact_info model_table;

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

%% method names

analysis_selection = {'PCA', 'AxisCorr', 'stepwise_axis', 'stepwise_PCA'};

%% start the super loop

% first loop through band+ref
for col_idx = 1:length(column_selection)
    
    % name of the column 
    column_name = column_selection{col_idx};
    
    % then loop through groups
    for group_order = 1:length(group_selection)
        
        % name of the group
        group_name = group_selection{group_order};
        
        % contact id of this group
        group_idx = group_ids{group_order};
        
        table_oi = model_table(group_idx,:);
        
        % then choose different methods
        for analysis_id = 1:length(analysis_selection)
            
            % name of the method
            analysis_name = analysis_selection{analysis_id};
            
            switch analysis_id
                case 1 % PCA
                    
                    [coeff,score,latent,tsquared,explained,mu] = pca([table_oi.X,table_oi.Y,table_oi.Z]);
                    
                    big_stat(5*col_idx - 5 + group_order).band = column_name;
                    
                    big_stat(5*col_idx - 5 + group_order).group = group_name;
                    
                    big_stat(5*col_idx - 5 + group_order).PCA.coeff = coeff;
                    
                    big_stat(5*col_idx - 5 + group_order).PCA.score = score;
                    
                    
                    [r1,p1] = corr(big_stat(5*col_idx - 5 + group_order).PCA.score(:,1), table_oi{:,column_name});
                    [r2,p2] = corr(big_stat(5*col_idx - 5 + group_order).PCA.score(:,2), table_oi{:,column_name});
                    [r3,p3] = corr(big_stat(5*col_idx - 5 + group_order).PCA.score(:,3), table_oi{:,column_name});
                    big_stat(5*col_idx - 5 + group_order).PCA.corr = [r1,r2,r3;p1,p2,p3];
                    
                case 2 % AxisCorr
                    [r1,p1] = corr(table_oi.X, table_oi{:,column_name});
                    [r2,p2] = corr(table_oi.Y, table_oi{:,column_name});
                    [r3,p3] = corr(table_oi.Z, table_oi{:,column_name});            
                    big_stat(5*col_idx - 5 + group_order).AxisCorr = [r1,r2,r3;p1,p2,p3];
                case 3 % stepwise_axis
                    mdl = stepwiselm(table_oi,'constant','ResponseVar',column_name,'PredictorVars',{'X','Y','Z'});
                    
                    big_stat(5*col_idx - 5 + group_order).stepwise_axis = mdl;
                    
                case 4 % stepwise with PCA components
                    mdl = stepwiselm(big_stat(5*col_idx - 5 + group_order).PCA.score,table_oi{:,column_name},'constant');
                    
                    big_stat(5*col_idx - 5 + group_order).stepwise_PCA = mdl;
                    
            end
        end
    end
end

readme = 'each row is a band+ref+group combination, Corr first row is rho and second row is p';

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/continuous_group_comparison.mat'],...
    'big_stat','readme');