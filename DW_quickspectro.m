DW_machine;

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/leadmeantrial_all.mat']);

fs = 1000;
fq = 2:2:200;

t = linspace(-3,3,6000);
badch = [];
for total_session_idx = 1:length(mean_trial);
    for ch_idx = 1:size(mean_trial(total_session_idx).sp_ref_avgfirst,3);
        figure (ch_idx);
        imagesc(t, fq,mean_trial(total_session_idx).sp_ref_avgfirst(:,:,ch_idx)');set(gca, 'YDir', 'Normal');
        
        all_data = mean_trial(total_session_idx).sp_ref_avgfirst(:,:,ch_idx)';
        all_data = all_data(:);

        colormap jet;caxis([-10,10]);colorbar
    end
    
    badch_i = input('bad figure index:');
    badch{total_session_idx} = badch_i;
    close all;
end

compact_sp = [];
for total_session_idx = 1:length(mean_trial);
    compact_sp = cat(3,compact_sp,mean_trial(total_session_idx).sp...
        (:,:,setdiff(1:size(mean_trial(total_session_idx).sp ,3),badch{total_session_idx})));
end

avg_sp_allpatients = mean(compact_sp,3);
imagesc(t, fq,avg_sp_allpatients');set(gca, 'YDir', 'Normal');

caxis([-2,2]);colorbar





%% macro
DW_machine;
load([dionysis,'Users/dwang/VIM/datafiles/processed_data/macro_mean_trial_nonref_avgfirst.mat']);
macro_mean_trial_nonref_avgfirst = mean_trial;

macro_mean_trial_nonref_avgfirst(7:8) = [];

fs = 1000;
fq = 2:2:200;

t = linspace(-3,3,6000);
badch = [];
for total_session_idx = 1:length(macro_mean_trial_nonref_avgfirst);
    for ch_idx = 1:size(macro_mean_trial_nonref_avgfirst(total_session_idx).sp_ref_avgfirst,3);
        figure (ch_idx);
        imagesc(t, fq,macro_mean_trial_nonref_avgfirst(total_session_idx).sp_ref_avgfirst(:,:,ch_idx)');set(gca, 'YDir', 'Normal');
        
        all_data = macro_mean_trial_nonref_avgfirst(total_session_idx).sp_ref_avgfirst(:,:,ch_idx)';
        all_data = all_data(:);

        colormap jet;caxis([-10,10]);colorbar
    end
    
    badch_i = input('bad figure index:');
    badch{total_session_idx} = badch_i;
    close all;
end
 
 
compact_macro_car = [];
for total_session_idx = 1:length(macro_mean_trial_nonref_avgfirst);
    compact_macro_car = cat(3,compact_macro_car,macro_mean_trial_nonref_avgfirst(total_session_idx).sp_ref_avgfirst...
        (:,:,setdiff(1:size(macro_mean_trial_nonref_avgfirst(total_session_idx).sp_ref_avgfirst,3),badch{total_session_idx})));
end

avg_sp_allpatients = mean(compact_macro_car,3);
imagesc(t, fq,avg_sp_allpatients');set(gca, 'YDir', 'Normal');

caxis([-1,1]);colorbar


