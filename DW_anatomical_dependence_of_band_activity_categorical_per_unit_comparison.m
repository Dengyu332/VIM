% first created on 08/13/2018
% follows DW_generate_band_activity_z_table.m and
% DW_categorizing_contacts.m

% categorical and per unit base comparison of VLa vs. VLp in terms of band
% response activity

%per subject base, per subject side base and per session base
%% per subject base

% specify machine
DW_machine;

% read in subject list
Subject_list = readtable([dionysis 'Users/dwang/VIM/datafiles/Docs/Subject_list_allVim.xlsx']);

% load contact info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);

contact_info = struct2table(contact_info);
z_table = struct2table(z_table);


counter = 0;
for subject_name = Subject_list.Subject_id'
    
    find(strcmp(subject_name,contact_info.subject_id)); % This is the contact indexes of this subject
    
    % indexes of VLa of this subject
    VLa_oi = intersect(find(strcmp('VLa',contact_info.group_used)),find(strcmp(subject_name,contact_info.subject_id)));
    % indexes of VLp of this subject
    VLp_oi = intersect(find(strcmp('VLp',contact_info.group_used)),find(strcmp(subject_name,contact_info.subject_id)));
    
    if (isempty(VLa_oi) || isempty(VLp_oi)) % which means this subject has no contact of VLa or no contact of VLp
    else
        counter = counter + 1;
        table_oi(counter).subject_id = subject_name{:};
        
        val_oi = [mean(table2array(z_table(VLa_oi,2:end)),1),mean(table2array(z_table(VLp_oi,2:end)),1)];
        
        table_oi(counter).VLa_unref_alpha = val_oi(1);
        table_oi(counter).VLp_unref_alpha = val_oi(9);
        table_oi(counter).VLa_ref_alpha = val_oi(2);
        table_oi(counter).VLp_ref_alpha = val_oi(10);        
        table_oi(counter).VLa_unref_lowbeta = val_oi(3);
        table_oi(counter).VLp_unref_lowbeta = val_oi(11);
        table_oi(counter).VLa_ref_lowbeta = val_oi(4);
        table_oi(counter).VLp_ref_lowbeta = val_oi(12);        
        table_oi(counter).VLa_unref_highbeta = val_oi(5);
        table_oi(counter).VLp_unref_highbeta = val_oi(13);
        table_oi(counter).VLa_ref_highbeta = val_oi(6);
        table_oi(counter).VLp_ref_highbeta = val_oi(14);          
        table_oi(counter).VLa_unref_highgamma = val_oi(7);
        table_oi(counter).VLp_unref_highgamma = val_oi(15);  
        table_oi(counter).VLa_ref_highgamma = val_oi(8);
        table_oi(counter).VLp_ref_highgamma = val_oi(16);
    end
        
end

table_oi = struct2table(table_oi);

val_matrix = table2array(table_oi(:,2:end)); % exclude first column, which is subject_id 


p = [];
for comp_id = 1:8
    [~,p(comp_id,1)] = ttest(val_matrix(:,comp_id*2-1),val_matrix(:,comp_id*2)); % paired t test
end


% keep p;
clearvars -except p dionysis dropbox;


%% per subject side base

% read in subject list
Subject_list = readtable([dionysis 'Users/dwang/VIM/datafiles/Docs/Subject_list_allVim.xlsx']);

% load contact info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);

contact_info = struct2table(contact_info);
z_table = struct2table(z_table);


counter = 0;

for subject_name = Subject_list.Subject_id'
    
    this_subject = find(strcmp(subject_name,contact_info.subject_id)); % ids of this subject
    
    sides = unique(contact_info.side(this_subject))'; % which sides this subject have
    
    for side_name = sides
        
        
        
        region_oi = intersect(this_subject,find(strcmp(side_name,contact_info.side)));
        
        VLa_oi = intersect(find(strcmp('VLa',contact_info.group_used)),region_oi);
        
        VLp_oi = intersect(find(strcmp('VLp',contact_info.group_used)),region_oi);
        
        if (isempty(VLa_oi) || isempty(VLp_oi)) % which means this region has no contact of VLa or no contact of VLp
        else   
            counter = counter+1;
            table_oi(counter).subject_id = subject_name{:};
            table_oi(counter).side = side_name{:};
            
            val_oi = [mean(table2array(z_table(VLa_oi,2:end)),1),mean(table2array(z_table(VLp_oi,2:end)),1)];
            
            table_oi(counter).VLa_unref_alpha = val_oi(1);
            table_oi(counter).VLp_unref_alpha = val_oi(9);
            table_oi(counter).VLa_ref_alpha = val_oi(2);
            table_oi(counter).VLp_ref_alpha = val_oi(10);        
            table_oi(counter).VLa_unref_lowbeta = val_oi(3);
            table_oi(counter).VLp_unref_lowbeta = val_oi(11);
            table_oi(counter).VLa_ref_lowbeta = val_oi(4);
            table_oi(counter).VLp_ref_lowbeta = val_oi(12);        
            table_oi(counter).VLa_unref_highbeta = val_oi(5);
            table_oi(counter).VLp_unref_highbeta = val_oi(13);
            table_oi(counter).VLa_ref_highbeta = val_oi(6);
            table_oi(counter).VLp_ref_highbeta = val_oi(14);          
            table_oi(counter).VLa_unref_highgamma = val_oi(7);
            table_oi(counter).VLp_unref_highgamma = val_oi(15);  
            table_oi(counter).VLa_ref_highgamma = val_oi(8);
            table_oi(counter).VLp_ref_highgamma = val_oi(16);
        end
    end
            
            
end

table_oi = struct2table(table_oi);
val_matrix = table2array(table_oi(:,3:end)); % exclude first two columns, which are subject_id and side

for comp_id = 1:8
    [~,p(comp_id,2)] = ttest(val_matrix(:,comp_id*2-1),val_matrix(:,comp_id*2)); % paired t test
end



% keep p
clearvars -except p dionysis dropbox;

%% per session base

% read in subject list
Subject_list = readtable([dionysis 'Users/dwang/VIM/datafiles/Docs/Subject_list_allVim.xlsx']);

% load contact info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% load in z value table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat']);

contact_info = struct2table(contact_info);
z_table = struct2table(z_table);

counter = 0;

for subject_name = Subject_list.Subject_id(1:6)' % macro subjects
    this_subject = find(strcmp(subject_name,contact_info.subject_id)); % ids of this subject

    sessions = unique(cell2mat(contact_info.session(this_subject)))'; % which sessions this subject have

    for session_id = sessions
        
        region_oi = this_subject(find(cell2mat(contact_info.session(this_subject))==session_id));
        
        VLa_oi = intersect(find(strcmp('VLa',contact_info.group_used)),region_oi);
        
        VLp_oi = intersect(find(strcmp('VLp',contact_info.group_used)),region_oi);
        
        if isempty(VLp_oi) && ~isempty(VLa_oi) % has VLa, but not VLp; only DBS4039 has this issue
            
            counter = counter+1;
            
            table_oi(counter).subject_id = subject_name{:};
            side_name = unique(contact_info.side(region_oi));
            table_oi(counter).side = side_name{:};
            table_oi(counter).session = session_id;
            
            VLa_oi = intersect(find(strcmp('VLa',contact_info.group_used)),this_subject); % extend to use whole subject contacts
            VLp_oi = intersect(find(strcmp('VLp',contact_info.group_used)),this_subject); % extend to use whole subject contacts
            
            val_oi = [mean(table2array(z_table(VLa_oi,2:end)),1),mean(table2array(z_table(VLp_oi,2:end)),1)];
            
            table_oi(counter).VLa_unref_alpha = val_oi(1);
            table_oi(counter).VLp_unref_alpha = val_oi(9);
            table_oi(counter).VLa_ref_alpha = val_oi(2);
            table_oi(counter).VLp_ref_alpha = val_oi(10);        
            table_oi(counter).VLa_unref_lowbeta = val_oi(3);
            table_oi(counter).VLp_unref_lowbeta = val_oi(11);
            table_oi(counter).VLa_ref_lowbeta = val_oi(4);
            table_oi(counter).VLp_ref_lowbeta = val_oi(12);        
            table_oi(counter).VLa_unref_highbeta = val_oi(5);
            table_oi(counter).VLp_unref_highbeta = val_oi(13);
            table_oi(counter).VLa_ref_highbeta = val_oi(6);
            table_oi(counter).VLp_ref_highbeta = val_oi(14);          
            table_oi(counter).VLa_unref_highgamma = val_oi(7);
            table_oi(counter).VLp_unref_highgamma = val_oi(15);  
            table_oi(counter).VLa_ref_highgamma = val_oi(8);
            table_oi(counter).VLp_ref_highgamma = val_oi(16);
        elseif isempty(VLa_oi)
        else % include VLa and VLp in one session
            counter = counter+1;
            table_oi(counter).subject_id = subject_name{:};
            side_name = unique(contact_info.side(region_oi));
            table_oi(counter).side = side_name{:};
            table_oi(counter).session = session_id;
            
            val_oi = [mean(table2array(z_table(VLa_oi,2:end)),1),mean(table2array(z_table(VLp_oi,2:end)),1)];
            
            table_oi(counter).VLa_unref_alpha = val_oi(1);
            table_oi(counter).VLp_unref_alpha = val_oi(9);
            table_oi(counter).VLa_ref_alpha = val_oi(2);
            table_oi(counter).VLp_ref_alpha = val_oi(10);        
            table_oi(counter).VLa_unref_lowbeta = val_oi(3);
            table_oi(counter).VLp_unref_lowbeta = val_oi(11);
            table_oi(counter).VLa_ref_lowbeta = val_oi(4);
            table_oi(counter).VLp_ref_lowbeta = val_oi(12);        
            table_oi(counter).VLa_unref_highbeta = val_oi(5);
            table_oi(counter).VLp_unref_highbeta = val_oi(13);
            table_oi(counter).VLa_ref_highbeta = val_oi(6);
            table_oi(counter).VLp_ref_highbeta = val_oi(14);          
            table_oi(counter).VLa_unref_highgamma = val_oi(7);
            table_oi(counter).VLp_unref_highgamma = val_oi(15);  
            table_oi(counter).VLa_ref_highgamma = val_oi(8);
            table_oi(counter).VLp_ref_highgamma = val_oi(16);
        end
    end

end

for subject_name = Subject_list.Subject_id(7:end)' % lead subjects
    this_subject = find(strcmp(subject_name,contact_info.subject_id)); % ids of this subject

    sides = unique(contact_info.side(this_subject))'; % which sides this subject have, each side is one session

    for side_name = sides
        
        region_oi = intersect(this_subject,find(strcmp(side_name,contact_info.side)));
        
        VLa_oi = intersect(find(strcmp('VLa',contact_info.group_used)),region_oi);
        
        VLp_oi = intersect(find(strcmp('VLp',contact_info.group_used)),region_oi);
        
        if isempty(VLp_oi) || isempty(VLa_oi)

        else
            counter = counter+1;
            table_oi(counter).subject_id = subject_name{:};
            table_oi(counter).side = side_name{:};
            if strcmp(side_name,'left')
                
                table_oi(counter).session = [1,2];
            else
                table_oi(counter).session = 2;
            end
            
            val_oi = [mean(table2array(z_table(VLa_oi,2:end)),1),mean(table2array(z_table(VLp_oi,2:end)),1)];
            
            table_oi(counter).VLa_unref_alpha = val_oi(1);
            table_oi(counter).VLp_unref_alpha = val_oi(9);
            table_oi(counter).VLa_ref_alpha = val_oi(2);
            table_oi(counter).VLp_ref_alpha = val_oi(10);        
            table_oi(counter).VLa_unref_lowbeta = val_oi(3);
            table_oi(counter).VLp_unref_lowbeta = val_oi(11);
            table_oi(counter).VLa_ref_lowbeta = val_oi(4);
            table_oi(counter).VLp_ref_lowbeta = val_oi(12);        
            table_oi(counter).VLa_unref_highbeta = val_oi(5);
            table_oi(counter).VLp_unref_highbeta = val_oi(13);
            table_oi(counter).VLa_ref_highbeta = val_oi(6);
            table_oi(counter).VLp_ref_highbeta = val_oi(14);          
            table_oi(counter).VLa_unref_highgamma = val_oi(7);
            table_oi(counter).VLp_unref_highgamma = val_oi(15);  
            table_oi(counter).VLa_ref_highgamma = val_oi(8);
            table_oi(counter).VLp_ref_highgamma = val_oi(16);
        end
    end

end

table_oi = struct2table(table_oi);
val_matrix = table2array(table_oi(:,4:end));

for comp_id = 1:8
    [~,p(comp_id,3)] = ttest(val_matrix(:,comp_id*2-1),val_matrix(:,comp_id*2)); % paired t test
end


p_table = array2table(p);
p_table.Properties.RowNames{1} = 'unref_alpha';
p_table.Properties.RowNames{2} = 'ref_alpha';
p_table.Properties.RowNames{3} = 'unref_lowbeta';
p_table.Properties.RowNames{4} = 'ref_lowbeta';
p_table.Properties.RowNames{5} = 'unref_highbeta';
p_table.Properties.RowNames{6} = 'ref_highbeta';
p_table.Properties.RowNames{7} = 'unref_highgamma';
p_table.Properties.RowNames{8} = 'ref_highgamma';

p_table.Properties.VariableNames{1} = 'per_subject';
p_table.Properties.VariableNames{2} = 'per_subject_side';
p_table.Properties.VariableNames{3} = 'per_session';

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/categorical_per_subject_comparison.mat'],'p_table');