% first created on 09/27/2018
% follows script DW_batch_CAR.m

% This script aims to base on step3 files, re-define bad trials: include
% badcoding trial, higher the threshold of visobad trials, higher the
% threshold of quanbad trial (and identify after excluding visobad and
% partial trials), partial trial stay the same

% generate step4 data and bad_trial_count2

% specify machine to run
DW_machine;

% read in
% /Volumes/Nexus/Users/dwang/VIM/datafiles/Docs/bad_trial_count.xlsx and
% use this as a template to make our own table

template_table = readtable([dionysis 'Users/dwang/VIM/datafiles/Docs/bad_trial_count.xlsx']);

% make a new table which is to be the conainer of new-defined bad trials
new_table = template_table(:,{'subject_id','session_id'});

% add new_visobadidx
new_table.VisoBadIdx = {[];[1,2];[];[];[];[];[1:13];[];[];[];[];[111];[73:76];[];[6];[];[1,2];[];[];[];[];[];[];[];[];[];[];[]};

% read in badcodingtrial table
BadCodingTrials = readtable([dionysis 'Users/dwang/VIM/datafiles/Docs/BadCodingTrials.csv']);

clearvars -except BadCodingTrials dionysis dropbox new_table;

% get access to subject step3 data
subject_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/*step3.mat']);

% create this table to count new bad trials
bad_trial_count2 = new_table(:,1:2);

% loop through sessions and subjects
for Allsession_idx = 1:length(subject_dir)
    clearvars -except Allsession_idx bad_trial_count2 BadCodingTrials dionysis dropbox new_table subject_dir;
    
    subject_id = subject_dir(Allsession_idx).name(1:7);
    which_session = subject_dir(Allsession_idx).name(9:16); % char instead of num
    
    rowidx = find(strcmp(subject_id,bad_trial_count2.subject_id) & strcmp(which_session, bad_trial_count2.session_id));
    
    % load in data of this subject and this session
    
    load([subject_dir(Allsession_idx).folder filesep subject_dir(Allsession_idx).name]);
    % got D and session_epoch
    
    % detect bad trials quantitatively
    D1 = D;
    
    % remove new visobad trials and partial trial to make quantification more
    % accurate
    
    
    OrigIdx = 1:length(D1.trial);
    
    Tr2Rm = union(new_table.VisoBadIdx{rowidx}, D1.partialtrial_idx);
    
    D1.trial(:,Tr2Rm) = [];
    
    IdxNow = OrigIdx; IdxNow(Tr2Rm) = []; % IdxNow corresponds to reduced D1.trial
    
    D1.trial(2,:) = []; % remove CAR trials in the second row
    
    
    % keep in mind there are multiple channels
    D1.maxdiff=cellfun(@(x) max(abs(diff(x,1,2)),[],2),D1.trial,'Uni',0); %maximal diff in each trial
    D1.maxdiff = cat(2,D1.maxdiff{:});
    D1.maxdiff_m = mean(D1.maxdiff,2); % mean max diff for each channel
    D1.maxdiff_s = std(D1.maxdiff,0,2); % std max diff for each channel

    D1.meandiff = cellfun(@(x) mean(abs(diff(x,1,2)),2),D1.trial,'Uni',0); % mean diff in each sample
    D1.meandiff = cat(2,D1.meandiff{:});
    D1.meandiff_m = mean(D1.meandiff,2); % mean mean diff for each channel
    D1.meandiff_s = std(D1.meandiff,0,2); % std mean diff for each channel

    D1.maxval = cellfun(@(x) max(abs(x),[],2),D1.trial,'Uni',0); % max val in each trial
    D1.maxval= cat(2,D1.maxval{:});
    D1.maxval_m = mean(D1.maxval,2); % mean max val for each channel
    D1.maxval_s = std(D1.maxval,0,2); % std max val for each channel
    
    artifact = [];
    % 5 std
    for i = 1:size(D1.trial{1},1)
        artifact{i}= unique([find(D1.maxdiff(i,:)>D1.maxdiff_m(i)+5*D1.maxdiff_s(i) | D1.maxdiff(i,:)<D1.maxdiff_m(i)-5*D1.maxdiff_s(i)) ...
        find(D1.meandiff(i,:)>D1.meandiff_m(i)+5*D1.meandiff_s(i) | D1.meandiff(i,:)<D1.meandiff_m(i)-5*D1.meandiff_s(i)) ...
        find(D1.maxval(i,:)>D1.maxval_m(i)+5*D1.maxval_s(i) | D1.maxval(i,:)<D1.maxval_m(i)-5*D1.maxval_s(i))]);
    end
    
    candidates = unique(cell2mat(artifact));
    % map back to original idx
    quanbad_idx = IdxNow(candidates);
    
    % end quantification, got quanbad_idx
    
    % get visobad_idx
    visobad_idx = new_table.VisoBadIdx{rowidx};
    
    % partialtrial_idx is already here
    partialtrial_idx = D1.partialtrial_idx;
    
    % lastly get badcodingtrials
    % find this subject this session's badcoding trials
   BCTidx = find(strcmp(subject_id,BadCodingTrials.subject_id) & strcmp(which_session(end),  cellstr(num2str(BadCodingTrials.session_id))) );
   
   codingbad_idx = find(ismember(D1.epoch.trial_id, BadCodingTrials.trial_id(BCTidx)))';
   
   % Now we get all kinds of bad trials
   
   badtrial_final = unique([quanbad_idx, visobad_idx, codingbad_idx, partialtrial_idx]);
   
   D.visobad_idx = visobad_idx; D.quanbad_idx = quanbad_idx; D.codingbad_idx = codingbad_idx; D.partialtrial_idx = partialtrial_idx; D.badtrial_final = badtrial_final;
   
   % bear in mind that this total_trial already excludes trials that miss
   % word_onset or word_offset time data
   bad_trial_count2.total_trial(rowidx) = size(D.trial,2);
   bad_trial_count2.total_badtrial(rowidx) = length(D.badtrial_final);
   bad_trial_count2.coding_badtrial(rowidx) = length(D.codingbad_idx);
   bad_trial_count2.viso_badtrial(rowidx) = length(D.visobad_idx);
   bad_trial_count2.quan_badtrial(rowidx) = length(D.quanbad_idx);
   bad_trial_count2.partial_badtrial(rowidx) = length(D.partialtrial_idx);
   
   % save as step 4
   save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' subject_dir(Allsession_idx).name(1:end-10) '_step4.mat'],'D','session_epoch','-v7.3'); 

end
% write table bad_trial_count2
writetable(bad_trial_count2, [dionysis 'Users/dwang/VIM/datafiles/Docs/bad_trial_count2.csv']);