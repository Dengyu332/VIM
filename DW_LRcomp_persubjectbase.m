%  follows DW_generate_band_activity_z_table.m and DW_categorizing_contacts.m
% takes in z_table and contact_info_step2

% do left and right subject_base paired t test on selected band


%specify machine
DW_machine;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);

left_contacts = []; left_idx = 0;
right_contacts = []; right_idx = 0;

for contact_id = 40:95
    if strcmp('left', contact_info(contact_id).side)
        left_idx = left_idx + 1;
        
        left_contacts(left_idx) = contact_id;
    else
        right_idx = right_idx + 1;
        right_contacts(right_idx) = contact_id;
    end
end

z_table = struct2table(z_table);

left_z = z_table{left_contacts,:};
right_z = z_table{right_contacts,:};

left_z_cell = mat2cell(left_z, [4,4,4,4,4,4,4],[9]);
right_z_cell = mat2cell(right_z, [4,4,4,4,4,4,4],[9]);

left_z_cell_mean = cellfun(@(x) mean(x,1),left_z_cell,'UniformOutput',0);
right_z_cell_mean = cellfun(@(x) mean(x,1),right_z_cell,'UniformOutput',0);

Lmeanzs  = cell2mat(left_z_cell_mean);
Rmeanzs = cell2mat(right_z_cell_mean);

[h,p] = ttest2(Lmeanzs(:,5),Rmeanzs(:,5))        