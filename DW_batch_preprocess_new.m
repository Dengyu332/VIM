%First step of 5/20/2018 new preprocess step
%loop through thalamic pilot patients on the server, runs
%*_ft_raw_session_new.m under each subject's folder
% removed DC offset, unpowerlined, resample(anti-aliasing) to 1khz,
%400hz lpf and 2hz hpf
%generate *_ft_raw_session_new.mat under each subjects folder

% set machine
DW_machine;
%read in Subject_list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
 
for Subject_idx = 1:height(Subject_list);
    Subject_idx
    clearvars -except dionysis dropbox Subject_list Subject_idx Choice;
    
    cd([dionysis,'DBS/',...
    Subject_list.Subject_id{Subject_idx},'/Preprocessed Data/FieldTrip']);
 
        script_dir = dir('scripts/*_ft_raw_session_new.m');
        
        run([script_dir.folder filesep script_dir.name]);
end