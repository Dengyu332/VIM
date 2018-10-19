% First created on 10/18/2018
% This script runs a very quick test to see the first and second session
% difference in different bands in different time window and
% trial_selection

% The finding is:
% no difference: delta, theta, highbeta, gamma
% session 1 greater than session 2: highgamma
% session 1 lower than session 2 (means session 1 shows greater de-sync): alpha, lowbeta

% use information in z_table to do the comparison, paired-ttest

DW_machine;
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/z_table.mat']);

% find duplicate contacts
dup_contacts = DW_DupVal(z_table.contact_id);
idx_oi = find(ismember(z_table.contact_id,dup_contacts));
% the third idx of every three idxs is combined-session idx, should be
% removed
temp = reshape(idx_oi,3,[]); temp(3,:) = []; temp = temp(:);

final_idx = temp;

table_oi = z_table(final_idx,:);

clearvars  store stat
store = [];
for column_id = 1:48
    value_oi = table_oi{:,column_id+4};
    
    [store(column_id,2),store(column_id,1),~,stat(column_id)] = ttest(value_oi(1:2:end), value_oi(2:2:end));
end    