% follows DW_batch_subcort_single_contact_hilbert.m
% takes in data under /Volumes/Nexus/Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/

% This script is to compare the difference between the effect of smooth, downsampling on the final illustration of the data

% take lead, highgamma, ref, spct VLa vs VLp as example


% The finding is:
% 1. smooth before average across contacts or smooth after averaging look
% the same
% 2. smooth + downsampling looks similar to only downsampling, but more
% steady

% so decide to use downsampling to do statistical test

%% try lead, highgamma, ref, spct

%specify machine
DW_machine;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

band_selection = {'alpha','lowbeta','highbeta','highgamma'};
ref_selection = {'unref','ref'};
locking_selection = {'spct','cuect'};
group_selection = {'grand','left','right','lead','lead_left','lead_right','macro','macro_left','macro_right'};

% loop through groups first

grand_idx = [1:12,19:95]; 
left_idx = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[13:18]);
right_idx = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[13:18]);

lead_idx = [40:95];
lead_left_idx = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[1:39]);
lead_right_idx = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[1:39]);

macro_idx = [1:12,19:39];
macro_left = setdiff(find(strcmp('left',extractfield(contact_info,'side'))),[13:18,40:95]);
macro_right = setdiff(find(strcmp('right',extractfield(contact_info,'side'))),[13:18,40:95]);

group_ids = {grand_idx,left_idx,right_idx,lead_idx,lead_left_idx,lead_right_idx,macro_idx,macro_left,macro_right};

%lead
group_order = 4;

group_name = group_selection{group_order};

% contact id of group lead
group_idx = group_ids{group_order};

% highgamma
band_id = 4; 

band_name = band_selection{band_id}; % name of the band

% ref
ref_id = 2;

ref_name = ref_selection{ref_id};

% spct
locking_id = 1;

locking_name = locking_selection{locking_id};

z_VLa = [];z_VLp = [];
VLa_n = 0; VLp_n = 0; 
cue_VLa = 0; cue_VLp = 0;
sp_VLa = 0; sp_VLp = 0;                         

for contact_id = group_idx % loop through contact group of interest

    % load in the file specified by contact_id,
    % band_name, ref_name and locking selection
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
        num2str(contact_id) '_' band_name '_' ref_name '_' locking_name '.mat']);

    if strcmp('VLa',contact_info(contact_id).group_used)
        VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
    elseif strcmp('VLp',contact_info(contact_id).group_used)
        VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
    end
end
%% downsampling to 10 hz

z_VLa = squeeze(z_VLa);
z_VLp = squeeze(z_VLp);

z_VLa = z_VLa(2:end,:);
z_VLp = z_VLp(2:end,:);

z_VLa_10hz = resample(z_VLa,10,1000);
z_VLp_10hz = resample(z_VLp,10,1000);

% get average data for each group

% VLa
z_VLa_10hz_avg = mean(z_VLa_10hz,2);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_10hz_avg = mean(z_VLp_10hz,2);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;                        

% plot
t = linspace(-1.9,2,40);
figure;
plot(t,z_VLa_10hz_avg,'LineWidth',3); hold on;plot(t,z_VLp_10hz_avg,'LineWidth',3);

hold on; plot([0,0],ylim,'LineStyle','--','Color',[160 32 240]/256); 

hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);
hold on; plot([sp_VLa_avg,sp_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);

hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);
hold on; plot([sp_VLp_avg,sp_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);

set(gca,'box','off');
xlabel('Time (s)'); % x-axis label
ylabel([band_name ' z-score']); % y-axis label
legend('VLa','VLp');

%% 100smooth, but this time before average across contacts

z_VLa = squeeze(z_VLa);
z_VLp = squeeze(z_VLp);

for i = 1:size(z_VLa,2)
    z_VLa_100smooth(:,i) = smooth(z_VLa(:,i),100);
end

for i = 1:size(z_VLp,2)
    z_VLp_100smooth(:,i) = smooth(z_VLp(:,i),100);
end



% get average data for each group

% VLa
z_VLa_100smooth_avg = mean(z_VLa_100smooth,2);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_100smooth_avg = mean(z_VLp_100smooth,2);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;                        

% plot
t = linspace(-2,2,4001);
figure;
plot(t,z_VLa_100smooth_avg); hold on;plot(t,z_VLp_100smooth_avg);

hold on; plot([0,0],ylim,'LineStyle','--','Color',[160 32 240]/256); 

hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);
hold on; plot([sp_VLa_avg,sp_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);

hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);
hold on; plot([sp_VLp_avg,sp_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);

set(gca,'box','off');
xlabel('Time (s)'); % x-axis label
ylabel([band_name ' z-score']); % y-axis label
legend('VLa','VLp');

%% 100smooth + downsampling to 10 hz

z_VLa = squeeze(z_VLa);
z_VLp = squeeze(z_VLp);

z_VLa = z_VLa(2:end,:);
z_VLp = z_VLp(2:end,:);

for i = 1:size(z_VLa,2)
    z_VLa_100smooth(:,i) = smooth(z_VLa(:,i),100);
end

for i = 1:size(z_VLp,2)
    z_VLp_100smooth(:,i) = smooth(z_VLp(:,i),100);
end

z_VLa_100smooth_10hz = resample(z_VLa_100smooth,10,1000);
z_VLp_100smooth_10hz = resample(z_VLp_100smooth,10,1000);

% get average data for each group

% VLa
z_VLa_100smooth_10hz_avg = mean(z_VLa_100smooth_10hz,2);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_100smooth_10hz_avg = mean(z_VLp_100smooth_10hz,2);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;                        

% plot
t = linspace(-1.9,2,40);
figure;
plot(t,z_VLa_100smooth_10hz_avg); hold on;plot(t,z_VLp_100smooth_10hz_avg);

hold on; plot([0,0],ylim,'LineStyle','--','Color',[160 32 240]/256); 

hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);
hold on; plot([sp_VLa_avg,sp_VLa_avg],ylim,'LineStyle','--','Color',[0 0.447 0.741]);

hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);
hold on; plot([sp_VLp_avg,sp_VLp_avg],ylim,'LineStyle','--','Color',[0.85 0.325 0.098]);

set(gca,'box','off');
xlabel('Time (s)'); % x-axis label
ylabel([band_name ' z-score']); % y-axis label
legend('VLa','VLp');