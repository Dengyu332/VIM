DW_machine;
load([dionysis,'Users/dwang/VIM/datafiles/processed_data/macro_mean_trial_ref_avgfirst_hilb.mat']);

mean_trial(7:8) = [];

delta_cue = [];
delta_sp = [];
theta_cue = [];
theta_sp = [];
alpha_cue = [];
alpha_sp = [];
b1_cue = [];
b1_sp = [];
b2_cue = [];
b2_sp = [];
gamma_cue = [];
gamma_sp = [];
hg_cue = [];
hg_sp = [];

for total_session_idx = 1:length(mean_trial);
    delta_cue = [delta_cue,mean_trial(total_session_idx).delta_cue_ref_avgfirst];
    delta_sp = [delta_sp,mean_trial(total_session_idx).delta_sp_ref_avgfirst];
    theta_cue = [theta_cue,mean_trial(total_session_idx).theta_cue_ref_avgfirst];
    theta_sp = [theta_sp,mean_trial(total_session_idx).theta_sp_ref_avgfirst];    
    alpha_cue = [alpha_cue,mean_trial(total_session_idx).alpha_cue_ref_avgfirst];
    alpha_sp = [alpha_sp,mean_trial(total_session_idx).alpha_sp_ref_avgfirst];    
    b1_cue = [b1_cue,mean_trial(total_session_idx).b1_cue_ref_avgfirst];
    b1_sp = [b1_sp,mean_trial(total_session_idx).b1_sp_ref_avgfirst];
    b2_cue = [b2_cue,mean_trial(total_session_idx).b2_cue_ref_avgfirst];
    b2_sp = [b2_sp,mean_trial(total_session_idx).b2_sp_ref_avgfirst];
    gamma_cue = [gamma_cue,mean_trial(total_session_idx).gamma_cue_ref_avgfirst];
    gamma_sp = [gamma_sp,mean_trial(total_session_idx).gamma_sp_ref_avgfirst];    
    hg_cue = [hg_cue,mean_trial(total_session_idx).hg_cue_ref_avgfirst];
    hg_sp = [hg_sp,mean_trial(total_session_idx).hg_sp_ref_avgfirst];
end

delta_cue_avg = mean(delta_cue,2);
delta_sp_avg = mean(delta_sp,2);
theta_cue_avg = mean(theta_cue,2);
theta_sp_avg = mean(theta_sp,2);
alpha_cue_avg = mean(alpha_cue,2);
alpha_sp_avg = mean(alpha_sp,2);
b1_cue_avg = mean(b1_cue,2);
b1_sp_avg = mean(b1_sp,2);
b2_cue_avg = mean(b2_cue,2);
b2_sp_avg = mean(b2_sp,2);
gamma_cue_avg = mean(gamma_cue,2);
gamma_sp_avg = mean(gamma_sp,2);
hg_cue_avg = mean(hg_cue,2);
hg_sp_avg = mean(hg_sp,2);


figure;
plot(delta_cue_avg); hold on;plot(delta_sp_avg)

figure;
plot(theta_cue_avg); hold on;plot(theta_sp_avg)

figure;
plot(alpha_cue_avg); hold on;plot(alpha_sp_avg)

figure;
plot(b1_cue_avg); hold on;plot(b1_sp_avg)

figure;
plot(b2_cue_avg); hold on;plot(b2_sp_avg)

figure;
plot(gamma_cue_avg); hold on;plot(gamma_sp_avg)

figure;
plot(hg_cue_avg); hold on;plot(hg_sp_avg)
    
    
    
    