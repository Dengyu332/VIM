%follow DW_batch_preprocess_new.m 
% check timings of *_ft_raw_session_new.mat files under each subjects
% folder

% last check time: 07/25/2018

% set machine
DW_machine;
%read in Subject_list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list_allVim.xlsx']);
Subject_list(2,:) =[];


for Subject_idx = 1:height(Subject_list);
    Subject = cell2mat(Subject_list.Subject_id(Subject_idx))
    DW_test_coding(Subject)
    pause;
    close all

end