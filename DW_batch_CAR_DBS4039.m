% follows DW_batch_finalize_badtrial.m
% deals with DBS4039 specifically
% loop through *_step2.mat, common average referencing and put CAR signal in
%the second row of field 'trial' under D; document recording site for each file
%generate *_session*_subcort_trials_step3.mat

% specify machine;
DW_machine;

data_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/DBS4039*_step2.mat']);

for total_session_idx = 1:length(data_dir) % loop through session
    %load in data
    load([data_dir(total_session_idx).folder filesep data_dir(total_session_idx).name])
    
    mean_trial = cellfun(@(x) mean(x,1),D.trial,'UniformOutput',0); % get an average trial for each trial

    D.trial(2,:) = cellfun(@(x,y) x-y,D.trial,mean_trial,'UniformOutput',0); % common average referencing
    
    % recording side
    D.side = {'L'};
    
    D.state = [D.state, ', CAR signal at second row, recording side documented'];
    
    save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' data_dir(total_session_idx).name(1:end-10) '_step3.mat'],'D','session_epoch','-v7.3'); % save locally
    
end