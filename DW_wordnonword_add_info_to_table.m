% First created on 10/09/2018

% aims to add subject_id and recording side information to the left of
% z_table, speech_response_table_t, speech_response_table, stat_table_t and
% stat_table

% specify machine
DW_machine;

load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

contact_info = struct2table(contact_info);

added_info = table();

for row_idx = 1:height(stat_table)
    contact_id = stat_table.contact_id(row_idx);
    info_idx = find(contact_info.contact_id == contact_id);
    added_info.subject_id(row_idx) = contact_info.subject_id(info_idx);
    added_info.side(row_idx) = contact_info.side(info_idx);
end
% get
% add added_info to table_oi

load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

stat_table = [stat_table(:,1:2), added_info, stat_table(:,3:end)];

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat'],'stat_table');


load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table_t.mat']);

stat_table = [stat_table(:,1:2), added_info, stat_table(:,3:end)];

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table_t.mat'],'stat_table');


load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/z_table.mat']);

z_table = [z_table(:,1:2), added_info, z_table(:,3:end)];

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/z_table.mat'],'z_table');



load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table.mat']);

speech_response_table = [speech_response_table(:,1:2), added_info, speech_response_table(:,3:end)];

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table.mat'],'speech_response_table');


load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table_t.mat']);

speech_response_table = [speech_response_table(:,1:2), added_info, speech_response_table(:,3:end)];

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table_t.mat'],'speech_response_table');