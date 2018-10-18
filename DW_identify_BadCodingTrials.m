% first created on 09/25/2018
% This script aims to concatenate coding tables of all subjects, and adjust
% column contents and column order for the convenience of identifying bad
% trials based on coding resutls

% read in Subject_list_allVim.xlsx, PilotWordLists.mat and coding.txt of
% each subject under Users/dwang/VIM/datafiles/preprocessed_new/v1/

% Generate /Volumes/Nexus/Users/dwang/VIM/datafiles/Docs/AllTrials.csv and /Volumes/Nexus/Users/dwang/VIM/datafiles/Docs/BadCodingTrials.csv

% specify machine to run
DW_machine;

% read in subject list
Subject_list = readtable([dionysis 'Users/dwang/VIM/datafiles/Docs/Subject_list_allVim.xlsx']);

%  load polot word list (from 1 to 4)
load([dionysis 'DBS/DBS_subject_lists/Pilot-wordlist/PilotWordLists.mat']);

% merge into one grand wordlist
WordListGrand = [WordList1;WordList2;WordList3;WordList4];

% table to cell conversion
Subject_list = table2cell(Subject_list)';

 % exclude DBS4039 as it doesn't have coding info
Subject_list(2) = [];

% initialize grandtable to be a container of our result
GrandTable = table();

% loop through subjects
for subject_id = Subject_list
    
    % read in coding table of this subject
    table_i = readtable([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v1/' subject_id{:} '/annot/coding.txt']);
    
    % table_new is used to be a temp container of this subject's table
    table_new = table();
    
    % loop through trials
    for t = 1:height(table_i)
        table_new.subject_id(t) = subject_id(:);
        table_new.session_id(t) = table_i.session_id(t);
        table_new.trial_id(t) = table_i.trial_id(t);
        table_new.word(t) = table_i.word(t);
        % add standard phonetic code of this trial
        temp = find(strcmp(table_new.word(t),WordListGrand(:,1)));
        table_new.expectedPhonetic{t} = WordListGrand{temp(1),2};
        
        table_new.phoneticCode(t) = table_i.phoneticCode(t);
        table_new.err_cons1(t) = table_i.err_cons1(t);
        
        if iscell(table_i.err_vowel(t)) % due to some subjects err_vowel is NaN instead of a cell
            table_new.err_vowel(t) = table_i.err_vowel(t);
        else
            table_new.err_vowel(t) = {''};
        end
        
        table_new.err_cons2(t) = table_i.err_cons2(t);
        
        % comment columns across subjects are not consistent, need to
        % tackle this
        
        comment_columns = [];
        
        % find columns of table_i that are comments
        for v = 1:length(table_i.Properties.VariableNames)
            if length(table_i.Properties.VariableNames{v}) < 7
            else
                if strcmp(table_i.Properties.VariableNames{v}(1:7),'comment')
                    comment_columns = [comment_columns, v];
                end
            end
        end
        

        
        % add comment columns to table_new
        if length(comment_columns) ==1
            if iscell(table_i{t,comment_columns(1)})
                table_new.comment_1(t) = table_i{t,comment_columns(1)};
            else
                table_new.comment_1(t) = {''};
            end
            
            table_new.comment_2(t) = {''};
            table_new.comment_3(t) = {''};
            
        elseif length(comment_columns) ==2
            if iscell(table_i{t,comment_columns(1)})
                table_new.comment_1(t) = table_i{t,comment_columns(1)};
            else
                table_new.comment_1(t) = {''};
            end
            
            if iscell(table_i{t,comment_columns(2)})
                table_new.comment_2(t) = table_i{t,comment_columns(2)};
            else
                table_new.comment_2(t) = {''};
            end
            
            table_new.comment_3(t) = {''};
            
        else
            if iscell(table_i{t,comment_columns(1)})
                table_new.comment_1(t) = table_i{t,comment_columns(1)};
            else
                table_new.comment_1(t) = {''};
            end
            
            if iscell(table_i{t,comment_columns(2)})
                table_new.comment_2(t) = table_i{t,comment_columns(2)};
            else
                table_new.comment_2(t) = {''};
            end
            
            if iscell(table_i{t,comment_columns(3)})
                table_new.comment_3(t) = table_i{t,comment_columns(3)};
            else
                table_new.comment_3(t) = {''};
            end            
            
        end
        
        % Finally add timing columns to the tail of our new table (can provide some information sometimes)
        
        table_new.onset_word(t) = table_i.onset_word(t);
        table_new.onset_vowel(t) = table_i.onset_vowel(t);
        table_new.offset_vowel(t) = table_i.offset_vowel(t);
        table_new.offset_word(t) = table_i.offset_word(t);
               
    end % finish making table_new
    
    % concatenate table subject-wise to make this GrandTable
    GrandTable = vertcat(GrandTable, table_new);
    
end

% save this GrandTable first
writetable(GrandTable,[dionysis 'Users/dwang/VIM/datafiles/Docs/AllTrials.csv']);

%% start identifying bad trials
DW_machine;

GrandTable = readtable([dionysis 'Users/dwang/VIM/datafiles/Docs/AllTrials.csv']);

%%%% Firstly identify perfect trials and exclude them from our table
idx_1 = strcmp(GrandTable.expectedPhonetic,GrandTable.phoneticCode);
idx_2 = strcmp('',GrandTable.err_cons1);
idx_3 = strcmp('',GrandTable.err_vowel);
idx_4 = strcmp('',GrandTable.err_cons2);
idx_5 = ~isnan(GrandTable.onset_word) & ~isnan(GrandTable.onset_vowel) & ~isnan(GrandTable.offset_vowel) & ~isnan(GrandTable.offset_word);
idx_6 = strcmp('',GrandTable.comment_1);
idx_7 = strcmp('',GrandTable.comment_2);
idx_8 = strcmp('',GrandTable.comment_3);

% sup_idx points to "perfect trials"
sup_idx = find(idx_1 & idx_2 & idx_3 & idx_4 & idx_5 & idx_6 & idx_7 & idx_8);

sup_trials = GrandTable(sup_idx,:);

% Any trial that is not perfect trial is included in this table
GeneralBadTrials = GrandTable(setdiff(1:height(GrandTable), sup_idx),:);
%%%%%


% further refine GeneralBadTrials to reduce workload

% firstly identify trials whose timing data are not complete. These are bad
% trials

bad_idx1 = find(isnan(GeneralBadTrials.onset_word) | isnan(GeneralBadTrials.onset_vowel) | isnan(GeneralBadTrials.offset_vowel) | isnan(GeneralBadTrials.offset_word));

% create FinalBadTrials table
FinalBadTrials = GeneralBadTrials(bad_idx1,1:3);

% add 'reason' column
for i = 1:length(bad_idx1)
    FinalBadTrials.reason(i) = {'Missing timing'};
end

% move forward with GeneralBadTrials reducing the size of it until we
% manually go through it

% step1 is after removing those have missing timing data
GeneralBadTrials_step1 = GeneralBadTrials;
GeneralBadTrials_step1(bad_idx1,:) = [];

% then identify those with matched expectedcoding and actual coding
GBT_goodcoding_idx = find(strcmp(GeneralBadTrials_step1.expectedPhonetic,GeneralBadTrials_step1.phoneticCode));
GBT_goodcoding = GeneralBadTrials_step1(GBT_goodcoding_idx, : );

% manually inspect them and find final bad trials to be add to FinalBadTrials
abovetable_finalbad_idx = [10, 11, 22, 49,156, 161, 166,196, 202, 205, 208, 272, 291, 304, 309,323, 324,337];


temp = GBT_goodcoding(abovetable_finalbad_idx,[1:3,10]);

temp.Properties.VariableNames(4) = {'reason'};

FinalBadTrials = vertcat(FinalBadTrials,temp);


GeneralBadTrials_step2 = GeneralBadTrials_step1;
GeneralBadTrials_step2(GBT_goodcoding_idx,:) = [];

% identify final bad trials based on comments: word/nonword from
% nonword/word; prevocalization, etc.
FBT_commentbased = [4, 24, 49, 71, 76, 97, 122, 165, 185, 194, 195, 196, 202, 200, 214, 301, 459, 468, 479, 498, 539, 667, 695, 751, 783, 784, 790, 804, 812, 824, 834, 885, 939, 998, 1014, 1063, 1268, 1276, 1299, 1308, 1325, 1346, 1357, 1366, 1367, 1376, 1395]';

% add these to FinalBadTrials

temp = GeneralBadTrials_step2(FBT_commentbased,[1:3,10]);
temp.Properties.VariableNames(4) = {'reason'};
FinalBadTrials = vertcat(FinalBadTrials,temp);

GeneralBadTrials_step3 = GeneralBadTrials_step2;
GeneralBadTrials_step3(FBT_commentbased,:) = [];

% Next step: a trick, identify trials whose first phoneme coding matches
% the expected coding

counter = [];
for i = 1:height(GeneralBadTrials_step3)
    if isempty(GeneralBadTrials_step3.phoneticCode{i})
    else
        aa = DW_sectionbykey(GeneralBadTrials_step3.expectedPhonetic{i},'/'); bb = DW_sectionbykey(GeneralBadTrials_step3.phoneticCode{i},'/');
        
        if strcmp(aa{1} ,bb{1})
            counter = [counter,i];
        end
    end
end

GeneralBadTrials_step3_subset1 = GeneralBadTrials_step3(counter,:);

% manually check and find FinalBadTrials
FBT_step3_subset1 = 496;

temp = GeneralBadTrials_step3_subset1(FBT_step3_subset1,[1:3,7]);
temp.Properties.VariableNames(4) = {'reason'};
FinalBadTrials = vertcat(FinalBadTrials,temp);

% then remove counter trials from GeneralBadTrials and get step4 trials
GeneralBadTrials_step4 = GeneralBadTrials_step3;
GeneralBadTrials_step4(counter,:) = [];

%  identify trials who pronounced '\texttheta/' as '\dh/' or vice versa,
%  including those whose phoneticCode is empty

counter2 = [];

for i = 1:height(GeneralBadTrials_step4)
    
    if isempty(GeneralBadTrials_step4.phoneticCode{i})
        counter2 = [counter2, i];
    else
        aa = DW_sectionbykey(GeneralBadTrials_step4.expectedPhonetic{i},'/'); bb = DW_sectionbykey(GeneralBadTrials_step4.phoneticCode{i},'/');
        if (strcmp(aa{1},'\texttheta/') & strcmp(bb{1}, '\dh/')) | (strcmp(bb{1},'\texttheta/') & strcmp(aa{1}, '\dh/'))
            counter2 = [counter2, i];
        end
    end
end

GeneralBadTrials_step4_subset1 = GeneralBadTrials_step4(counter2,:);
    
% maunally inspect above trials and find no FinalBadTrials
% move to step 5
GeneralBadTrials_step5 = GeneralBadTrials_step4;
GeneralBadTrials_step5(counter2,:) = [];

% manually inspect part of them

good_step5 = [19, 20, 21,23:25, 27, 30:33, 38, 43,44,45,47,48, 51,53,55:58,60,61,64,65,67,71,73,74,76,94];
GeneralBadTrials_step6 = GeneralBadTrials_step5;
GeneralBadTrials_step6(good_step5,:) = [];


% find trials whose expected coding of first consonant is 'f/' or 'v/'
counter3 = [];
for i = 1:height(GeneralBadTrials_step6)
    aa = DW_sectionbykey(GeneralBadTrials_step6.expectedPhonetic{i},'/'); bb = DW_sectionbykey(GeneralBadTrials_step6.phoneticCode{i},'/');
    if strcmp(aa{1},'f/') | strcmp(aa{1},'v/')
        counter3 = [counter3, i];
    end
end

GeneralBadTrials_step6_subset = GeneralBadTrials_step6(counter3, :);
step6_subset_bad = [1,21,29,31];
% manually inspect the above trials and find FinalBadTrials

temp = GeneralBadTrials_step6_subset(step6_subset_bad,[1:3,6]);
temp.Properties.VariableNames{4} = 'reason';

FinalBadTrials = vertcat(FinalBadTrials,temp);

GeneralBadTrials_step7 = GeneralBadTrials_step6;
GeneralBadTrials_step7(counter3,:) = [];

% manually inspect GeneralBadTrials_step7 and find FinalBadTrials

last_bad_idx = [25:36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71:80,88:95,99:100,102,103,104:108,110:112,141,142,148,163,161,168,224,278,288,289,290,294];

temp = GeneralBadTrials_step7(last_bad_idx,[1:3,6]);
temp.Properties.VariableNames{4} = 'reason';
FinalBadTrials = vertcat(FinalBadTrials,temp);

% done
% save as BadCodingTrials.csv under 'Users/dwang/VIM/datafiles/Docs/'
FinalBadTrials = sortrows(FinalBadTrials,{'subject_id','session_id','trial_id'});

writetable(FinalBadTrials,[dionysis 'Users/dwang/VIM/datafiles/Docs/BadCodingTrials.csv']);