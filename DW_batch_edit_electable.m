DW_machine;
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
%% loading packages
rmpath(genpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/fieldtrip'));
addpath('/Users/Dengyu/Dropbox (Brain Modulation Lab)/Functions/Dengyu/git/fieldtrip');
ft_defaults;
bml_defaults;


for Subject_idx = 1:height(Subject_list);
        cd([dionysis,'Electrophysiology_Data/DBS_Intraop_Recordings/',...
        Subject_list.Subject_id{Subject_idx},'/Preprocessed Data/FieldTrip']);
    
    Subject_list.Subject_id{Subject_idx}
         electrode = bml_annot_read('annot/electrode.txt');
        electrode.id = (1:height(electrode))';
        electrode.starts = zeros(height(electrode),1);
        electrode.ends = ones(height(electrode),1) * 100000;
        electrode.duration = ones(height(electrode),1) * 100000
        
        bml_annot_write(electrode,'annot/electrode.txt');
end   