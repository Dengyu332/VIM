%follow DW_batch_check_badtrial.m
%loop through *_session*_subcort_trials_step1.mat, quantitatively find
%bad trials, and find incomplete trials
%merge 3 kind of bad trials together to get the final bad trials for a
%session
%generate *_session*_subcort_trials_step2.mat

data_dir = dir('/Users/Dengyu/Documents/Temp_data/v2/subcort/*_step1.mat');
fs = 1000;

for total_session_idx = 1:length(data_dir)
    load([data_dir(total_session_idx).folder filesep data_dir(total_session_idx).name]);
    D1 = D;
%% quantify trial feature for each channel
    D1.maxdiff=cellfun(@(x) max(abs(diff(x,1,2)),[],2),D1.trial,'Uni',0); %maximal diff in each trial
    D1.maxdiff = cat(2,D1.maxdiff{:});
    D1.maxdiff_m = mean(D1.maxdiff,2); % mean max diff for each channel
    D1.maxdiff_s = std(D1.maxdiff,0,2); % std max diff for each channel


    D1.meandiff = cellfun(@(x) mean(abs(diff(x,1,2)),2),D1.trial,'Uni',0); % mean diff in each sample
    D1.meandiff = cat(2,D1.meandiff{:});
    D1.meandiff_m = mean(D1.meandiff,2); % mean mean diff for each channel
    D1.meandiff_s = std(D1.meandiff,0,2); % std mean diff for each channel

    D1.maxval = cellfun(@(x) max(x,[],2),D1.trial,'Uni',0); % max val in each trial
    D1.maxval= cat(2,D1.maxval{:});
    D1.maxval_m = mean(D1.maxval,2); % mean max val for each channel
    D1.maxval_s = std(D1.maxval,0,2); % std max val for each channel

    D1.minval = cellfun(@(x) min(x,[],2),D1.trial,'Uni',0); % min val in each trial
    D1.minval= cat(2,D1.minval{:});
    D1.minval_m = mean(D1.minval,2); % mean min val for each channel
    D1.minval_s = std(D1.minval,0,2); % std min val for each channel

    D1.mean = cellfun(@(x) mean(x,2),D1.trial,'Uni',0); % mean val in each trial
    D1.mean = cat(2,D1.mean{:});
    D1.mean_m = mean(D1.mean,2); % mean range for each channel
    D1.mean_s = std(D1.mean,0,2); % std range for each channel

    % exclusion criteria: measures deviate more than 3 sigma
    artifact = [];
    for i = 1:size(D1.trial{1},1);
        artifact{i}= unique([find(D1.maxdiff(i,:)>D1.maxdiff_m(i)+3*D1.maxdiff_s(i) | D1.maxdiff(i,:)<D1.maxdiff_m(i)-3*D1.maxdiff_s(i)) ...
        find(D1.meandiff(i,:)>D1.meandiff_m(i)+3*D1.meandiff_s(i) | D1.meandiff(i,:)<D1.meandiff_m(i)-3*D1.meandiff_s(i)) ...
        find(D1.maxval(i,:)>D1.maxval_m(i)+3*D1.maxval_s(i) | D1.maxval(i,:)<D1.maxval_m(i)-3*D1.maxval_s(i)) ...
        find(D1.minval(i,:)>D1.minval_m(i)+3*D1.minval_s(i) | D1.minval(i,:)<D1.minval_m(i)-3*D1.minval_s(i)) ...
        find(D1.mean(i,:)>D1.mean_m(i)+3*D1.mean_s(i) | D1.mean(i,:)<D1.mean_m(i)-3*D1.mean_s(i))]);
    end
    
    candidates = unique(cell2mat(artifact)); 
    
%     count_badtrials = histc(cell2mat(artifact),candidates);
%     
%     candi_indx = find(count_badtrials > floor(size(D1.trial{1},1)/4)); % trials whose bad num > 1/4 total channel num (floor) are bad trials
%     
%     quanbad_idx = candidates(candi_indx);% quantitatively defined bad trials
    quanbad_idx = candidates;
    
    ideal_length = round((D1.epoch.ends - D1.epoch.starts)*fs);
    
    actual_length = cell2mat(cellfun(@(x) length(x),D1.time,'UniformOutput',0))';
    
    partialtrial_idx = find(ideal_length> actual_length + 2); % identify partial trial
    
    % badtrials consist of visually identified artifact, quantitatively
    % identified artifact, and partial trials
    badtrial_final = union(union(D1.visobad_idx,quanbad_idx),partialtrial_idx)';
    
    D.quanbad_idx = quanbad_idx;
    D.partialtrial_idx = partialtrial_idx;
    D.badtrial_final = badtrial_final;
    D.state = 'notch_filt,ds to 1khz,lpf_400, hpf_2, badch detected,badtrial of all type identified';
    
    save(['/Users/Dengyu/Documents/Temp_data/v2/subcort/' data_dir(total_session_idx).name(1:end-10) '_step2.mat'],'D','session_epoch','-v7.3'); % save locally
end