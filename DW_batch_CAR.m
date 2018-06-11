% follows DW_batch_finalize_badtrial.m
%loop through *_step2.mat, common average referencing and put CAR signal in
%the second row of field 'trial' under D; document recording site for each
%file
%generate *_session*_subcort_trials_step3.mat

% specify machine;
DW_machine;

data_dir = dir('/Users/Dengyu/Documents/Temp_data/v2/subcort/*_step2.mat');
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_new.xlsx']);

for total_session_idx = 1:height(Session_info) % loop through session
    %load in data
    load([data_dir(total_session_idx).folder filesep data_dir(total_session_idx).name])
    
    if size(D.trial{1,1},1) <=4 % one lead, or macro
        
        mean_trial = cellfun(@(x) mean(x,1),D.trial,'UniformOutput',0); % get an average trial for each trial
        
        D.trial(2,:) = cellfun(@(x,y) x-y,D.trial,mean_trial,'UniformOutput',0); % common average referencing
    elseif size(D.trial{1,1},1) >4 % two leads
        
        avg_trial_l = cellfun(@(x) mean(x(1:4,:),1),D.trial,'UniformOutput',0); % get an average trial for first 4 channels
        avg_trial_r = cellfun(@(x) mean(x(5:8,:),1),D.trial,'UniformOutput',0); % get an average trial for last 4 channels
        
        ref_trial_l = cellfun(@(x,y) x(1:4,:)-y,D.trial,avg_trial_l,'UniformOutput',0); % common average referencing
        ref_trial_r = cellfun(@(x,y) x(5:8,:)-y,D.trial,avg_trial_r,'UniformOutput',0); % common average referencing
        
        D.trial(2,:) = cellfun(@(x,y) [x;y],ref_trial_l,ref_trial_r,'UniformOutput',0); %merge
    end
    
    % recording side
    if ~strcmp(Session_info.Lead_Side(total_session_idx),"NA")
        D.side = Session_info.Lead_Side(total_session_idx);
    else
        D.side = Session_info.MER_Side(total_session_idx);
    end
    
    D.state = [D.state, ', CAR signal at second row, recording side documented'];
    
    save(['/Users/Dengyu/Documents/Temp_data/v2/subcort/' data_dir(total_session_idx).name(1:end-10) '_step3.mat'],'D','session_epoch','-v7.3'); % save locally
    
end