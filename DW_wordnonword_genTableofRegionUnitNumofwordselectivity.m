% created on 10/16/2018
% aims to generate a table, of which each row is a band+period combination,
% each column is a region of interest + number of units who have greater word response or nonword response
% SigUp or SigDown means the speech response (120 trials, -0.5 to 0.5 peri speech onset) of this unit is significantly
% higher or lower than baseline

% takes in region_word_selectivity_table (used as template),
% speech_response_table and stat_table, as well as
% word_nonword_response_table of each kind of combination

% v2 of the table is also generated. For more detials please refer to
% readme


% specify machine to run
DW_machine;

% use region_word_selectivity_table as a template
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/region_word_selectivity_table.mat']);
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table.mat']);
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

% remove combined-session rows from stat_table and speech_response_table
unique_contact = unique(speech_response_table.contact_id);
hasi = 0;
discard_idx = [];
for i = 1:length(unique_contact)
    
    
    contact_i = unique_contact(i);
    temp = find(speech_response_table.contact_id == contact_i);
    if length(temp) == 1
    else
        hasi = hasi + 1;
    discard_idx(hasi) =  temp(3);
    end
end
speech_response_table(discard_idx,:) = [];
stat_table(discard_idx,:) = [];

% init the table_oi
table_oi = table();

table_oi.category = region_word_selectivity_table.category; % borrow the rows from region_word_selectivity_table

% create selection matrix
region_selection = {'LeadLeft', 'LeadRight'};
sig_selection = {'', 'SigUp', 'SigDown'};
comparison_selection = {'GreaterWord', 'GreaterWordEdge', 'GreaterNonword', 'GreaterNonwordEdge'};

% find left and right idx list
lead_left_list = setdiff(find(strcmp(speech_response_table.side,'left')),1:39)';
lead_right_list = setdiff(find(strcmp(speech_response_table.side,'right')),1:39)';
region_idx_lists  = {lead_left_list,lead_right_list};

%%% loop through rows
for row_idx = 1:height(table_oi)
    
    % load in word_nonword_response_table of this band+period
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/UnitWordNonword_Response/' ...
        table_oi.category{row_idx} '.mat']);
    word_nonword_response_table(discard_idx,:) = [];
    
    % extract p_val and h_val of speech response of this band+period for
    % all units, bear in mind that period2 of speech_response_table is used
    p_oi = speech_response_table{:,[table_oi.category{row_idx}(1:end-1), '2_120_p']};
    h_oi = speech_response_table{:,[table_oi.category{row_idx}(1:end-1), '2_120_h']};
    
    % now we can generate sig_idx_lists for this band+period
    sig_idx_lists = {1:height(speech_response_table), find(p_oi * height(speech_response_table) <0.05 & h_oi == 1),...
        find(p_oi * height(speech_response_table) <0.05 & h_oi == -1)};
    
    % loop through columns
    for sig_id = 1:length(sig_selection)
        sig_name = sig_selection{sig_id};
        sig_idx = sig_idx_lists{sig_id};
        
        for region_id = 1:length(region_selection)
            region_name = region_selection{region_id};
            region_idx = region_idx_lists{region_id};
            
            % get final unit indexes that are explored under this selection
            % combination
            region_final = intersect(region_idx, sig_idx);
            
            % significantly word response greater than nonword
            comparison_num_lists(1) = sum(stat_table{region_final,[table_oi.category{row_idx} '_h']} == 1);
            
            % edgely word response greater than nonword
            comparison_num_lists(2) = sum(stat_table{region_final,[table_oi.category{row_idx} '_p']} > 0.05 & ...
                stat_table{region_final,[table_oi.category{row_idx} '_p']} < 0.06 & ...
                word_nonword_response_table.word(region_final) > word_nonword_response_table.nonword(region_final));
            comparison_num_lists(3) = sum(stat_table{region_final,[table_oi.category{row_idx} '_h']} == -1);
            comparison_num_lists(4) = sum(stat_table{region_final,[table_oi.category{row_idx} '_p']} > 0.05 & ...
                stat_table{region_final,[table_oi.category{row_idx} '_p']} < 0.06 & ...
                word_nonword_response_table.word(region_final) < word_nonword_response_table.nonword(region_final));
            
            for comparison_id = 1:length(comparison_selection)
                comparison_name = comparison_selection{comparison_id};
                comparison_num = comparison_num_lists(comparison_id);
            
                table_oi{row_idx,[sig_name region_name '_' comparison_name]} = comparison_num;
            end
        end
    end
end
% save as excel table
writetable(table_oi,[dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/' 'RegionUnitNumofSigWordSelection.xlsx']);

clc; close all; clear all;
% specify machine to run
DW_machine;

% use region_word_selectivity_table as a template
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/region_word_selectivity_table.mat']);
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table.mat']);
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

% remove combined-session rows from stat_table and speech_response_table
unique_contact = unique(speech_response_table.contact_id);
hasi = 0;
discard_idx = [];
for i = 1:length(unique_contact)
    
    
    contact_i = unique_contact(i);
    temp = find(speech_response_table.contact_id == contact_i);
    if length(temp) == 1
    else
        hasi = hasi + 1;
    discard_idx(hasi) =  temp(3);
    end
end
speech_response_table(discard_idx,:) = [];
stat_table(discard_idx,:) = [];

% init the table_oi
table_oi = table();

table_oi.category = region_word_selectivity_table.category; % borrow the rows from region_word_selectivity_table

% create selection matrix
region_selection = {'LeadLeft', 'LeadRight'};
sig_selection = {'', 'SigUp', 'SigDown'};
comparison_selection = {'GreaterWord', 'GreaterWordEdge', 'GreaterNonword', 'GreaterNonwordEdge'};

% find left and right idx list
lead_left_list = setdiff(find(strcmp(speech_response_table.side,'left')),1:39)';
lead_right_list = setdiff(find(strcmp(speech_response_table.side,'right')),1:39)';
region_idx_lists  = {lead_left_list,lead_right_list};

%%% loop through rows
for row_idx = 1:height(table_oi)
    
    % load in word_nonword_response_table of this band+period
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/UnitWordNonword_Response/' ...
        table_oi.category{row_idx} '.mat']);
    word_nonword_response_table(discard_idx,:) = [];
    
    % extract p_val and h_val of speech response of this band+period for
    % all units, bear in mind that period2 of speech_response_table is used
    p_oi = speech_response_table{:,[table_oi.category{row_idx}(1:end-1), '2_120_p']};
    h_oi = speech_response_table{:,[table_oi.category{row_idx}(1:end-1), '2_120_h']};
    
    % now we can generate sig_idx_lists for this band+period
    sig_idx_lists = {1:height(speech_response_table), find(p_oi * height(speech_response_table) <0.05 & h_oi == 1),...
        find(p_oi * height(speech_response_table) <0.05 & h_oi == -1)};
    
    % loop through columns
    for sig_id = 1:length(sig_selection)
        sig_name = sig_selection{sig_id};
        sig_idx = sig_idx_lists{sig_id};
        
        for region_id = 1:length(region_selection)
            region_name = region_selection{region_id};
            region_idx = region_idx_lists{region_id};
            
            % get final unit indexes that are explored under this selection
            % combination
            region_final = intersect(region_idx, sig_idx);
            NumUnit_of_Region = length(region_final);
            % significantly word response greater than nonword
            comparison_num_lists(1) = sum(stat_table{region_final,[table_oi.category{row_idx} '_h']} == 1);
            
            % edgely word response greater than nonword
            comparison_num_lists(2) = sum(stat_table{region_final,[table_oi.category{row_idx} '_p']} > 0.05 & ...
                stat_table{region_final,[table_oi.category{row_idx} '_p']} < 0.06 & ...
                word_nonword_response_table.word(region_final) > word_nonword_response_table.nonword(region_final));
            
            comparison_num_lists(3) = sum(stat_table{region_final,[table_oi.category{row_idx} '_h']} == -1);
            
            comparison_num_lists(4) = sum(stat_table{region_final,[table_oi.category{row_idx} '_p']} > 0.05 & ...
                stat_table{region_final,[table_oi.category{row_idx} '_p']} < 0.06 & ...
                word_nonword_response_table.word(region_final) < word_nonword_response_table.nonword(region_final));

            table_oi{row_idx,[sig_name region_name]} = {[num2str(comparison_num_lists(1)) '(' num2str(comparison_num_lists(2)) ')'...
                '-' num2str(comparison_num_lists(3)) '(' num2str(comparison_num_lists(4)) ')' ...
                '/' num2str(NumUnit_of_Region)]};
        end
    end
end

% save as v2 xlsx table
writetable(table_oi,[dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/' 'RegionUnitNumofSigWordSelection_v2.xlsx']);