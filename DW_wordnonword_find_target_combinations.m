% Try to establish a method to inspect each band's each period word vs.
% nonword response and find fruitul band and period

% We will make use of WordVsNonword/stat_table and WordVsNonword/speech_response_table

% specify machine
DW_machine;

load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% use perm-table, could allow tolerance of p slightly larger than 0.05

load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table.mat']);

% There are in total 24 choices (8 bands X 3 periods), go through one by
% one and pick potentially fruitful ones


% alpha period2: left side nonword decrease greater than word
% lowbeta period1: decrease: left side word decrease greater than nonword, right side opposite
% highbeta period1: both left and right show greater nonword decrease than word
% highbeta period2: seems both left and right show greater word decrease than nonword
% highbeta period3: left and right showed mixed wordvs.nonword response in highbeta decreasing

% highgamma period 2 and 3: exclusively left side nonword activation greater than word

% delta period1
temp = stat_table(:,1:6);
temp.response_p = speech_response_table.ref_delta_period2_120_p;
temp.response_h = speech_response_table.ref_delta_period2_120_h;

find(temp.ref_delta_period1_p > 0.05 & temp.ref_delta_period1_p < 0.06);

% manually inspect, not promising

% delta period2
temp = stat_table(:,[1:4,7,8]);
temp.response_p = speech_response_table.ref_delta_period2_120_p;
temp.response_h = speech_response_table.ref_delta_period2_120_h;

find(temp.ref_delta_period2_p > 0.05 & temp.ref_delta_period2_p < 0.06);

% manually inspect, not promising


% delta period3
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,9};
temp.comp_h = stat_table{:,10};
temp.response_p = speech_response_table.ref_delta_period2_120_p;
temp.response_h = speech_response_table.ref_delta_period2_120_h;

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)

% manually inspect, not promising

% theta period1
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,11};
temp.comp_h = stat_table{:,12};
temp.response_p = speech_response_table.ref_theta_period2_120_p;
temp.response_h = speech_response_table.ref_theta_period2_120_h;

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising

% theta period2
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,13};
temp.comp_h = stat_table{:,14};
temp.response_p = speech_response_table.ref_theta_period2_120_p;
temp.response_h = speech_response_table.ref_theta_period2_120_h;

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising

% theta period3
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,15};
temp.comp_h = stat_table{:,16};
temp.response_p = speech_response_table.ref_theta_period2_120_p;
temp.response_h = speech_response_table.ref_theta_period2_120_h;

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising

% alpha period1
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,17};
temp.comp_h = stat_table{:,18};
temp.response_p = speech_response_table.ref_alpha_period2_120_p;
temp.response_h = speech_response_table.ref_alpha_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising

% alpha period2
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,19};
temp.comp_h = stat_table{:,20};
temp.response_p = speech_response_table.ref_alpha_period2_120_p;
temp.response_h = speech_response_table.ref_alpha_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)

% alpha period3
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,21};
temp.comp_h = stat_table{:,22};
temp.response_p = speech_response_table.ref_alpha_period2_120_p;
temp.response_h = speech_response_table.ref_alpha_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising

% lowbeta period1
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,23};
temp.comp_h = stat_table{:,24};
temp.response_p = speech_response_table.ref_lowbeta_period2_120_p;
temp.response_h = speech_response_table.ref_lowbeta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising

% lowbeta period2
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,25};
temp.comp_h = stat_table{:,26};
temp.response_p = speech_response_table.ref_lowbeta_period2_120_p;
temp.response_h = speech_response_table.ref_lowbeta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising

% lowbeta period3
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,27};
temp.comp_h = stat_table{:,28};
temp.response_p = speech_response_table.ref_lowbeta_period2_120_p;
temp.response_h = speech_response_table.ref_lowbeta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising

% highbeta period1
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,29};
temp.comp_h = stat_table{:,30};
temp.response_p = speech_response_table.ref_highbeta_period2_120_p;
temp.response_h = speech_response_table.ref_highbeta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)

% highbeta period2
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,31};
temp.comp_h = stat_table{:,32};
temp.response_p = speech_response_table.ref_highbeta_period2_120_p;
temp.response_h = speech_response_table.ref_highbeta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)

% highbeta period3
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,33};
temp.comp_h = stat_table{:,34};
temp.response_p = speech_response_table.ref_highbeta_period2_120_p;
temp.response_h = speech_response_table.ref_highbeta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)

% beta period1
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,35};
temp.comp_h = stat_table{:,36};
temp.response_p = speech_response_table.ref_beta_period2_120_p;
temp.response_h = speech_response_table.ref_beta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising



% beta period1
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,35};
temp.comp_h = stat_table{:,36};
temp.response_p = speech_response_table.ref_beta_period2_120_p;
temp.response_h = speech_response_table.ref_beta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% manually inspect, not promising




% beta period2
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,37};
temp.comp_h = stat_table{:,38};
temp.response_p = speech_response_table.ref_beta_period2_120_p;
temp.response_h = speech_response_table.ref_beta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)


% beta period3
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,39};
temp.comp_h = stat_table{:,40};
temp.response_p = speech_response_table.ref_beta_period2_120_p;
temp.response_h = speech_response_table.ref_beta_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)



% gamma period1
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,41};
temp.comp_h = stat_table{:,42};
temp.response_p = speech_response_table.ref_gamma_period2_120_p;
temp.response_h = speech_response_table.ref_gamma_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)
% too mixed, activation and desynchronization half and half


% gamma period2
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,43};
temp.comp_h = stat_table{:,44};
temp.response_p = speech_response_table.ref_gamma_period2_120_p;
temp.response_h = speech_response_table.ref_gamma_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)


% gamma period3
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,45};
temp.comp_h = stat_table{:,46};
temp.response_p = speech_response_table.ref_gamma_period2_120_p;
temp.response_h = speech_response_table.ref_gamma_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)




% highgamma period1
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,47};
temp.comp_h = stat_table{:,48};
temp.response_p = speech_response_table.ref_highgamma_period2_120_p;
temp.response_h = speech_response_table.ref_highgamma_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)



% highgamma period2
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,49};
temp.comp_h = stat_table{:,50};
temp.response_p = speech_response_table.ref_highgamma_period2_120_p;
temp.response_h = speech_response_table.ref_highgamma_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)


% highgamma period3
temp = stat_table(:,1:4);
temp.comp_p = stat_table{:,51};
temp.comp_h = stat_table{:,52};
temp.response_p = speech_response_table.ref_highgamma_period2_120_p;
temp.response_h = speech_response_table.ref_highgamma_period2_120_h;

sum(temp.comp_h~=0 & temp.response_h~=0)

find(temp.comp_p > 0.05 & temp.comp_p < 0.06)