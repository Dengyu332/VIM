% follows DW_batch_CAR.m
% takes in step_3 data
% count trial number, bad trial number for each session
% generate a table

DW_machine;

Subject_list = readtable([dionysis 'Users/dwang/VIM/datafiles/Docs/Subject_list_allVim.xlsx']);

total_session = 0;

for subject_order = 1:height(Subject_list)
    subject_name = cell2mat(Subject_list.Subject_id(subject_order));
    data_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' subject_name '_*_step3.mat']);
    
    for i = 1:length(data_dir)
        total_session = total_session + 1;
        load([data_dir(i).folder filesep data_dir(i).name]);
        
        subject_id{total_session,1} = subject_name;
        session_id{total_session,1} = data_dir(i).name(9:16);
        total_trial(total_session,1) = size(D.trial,2);
        total_badtrial(total_session,1) = length(D.badtrial_final);
        viso_badtrial(total_session,1) = length(D.visobad_idx);
        quan_badtrial(total_session,1) = length(D.quanbad_idx);
        partial_trial(total_session,1) = length(D.partialtrial_idx);
        
    end
end

bad_trial_table = table(subject_id,session_id,total_trial,total_badtrial,viso_badtrial,quan_badtrial,partial_trial);

writetable(bad_trial_table,[dionysis 'Users/dwang/VIM/datafiles/Docs/bad_trial_count.xlsx']);