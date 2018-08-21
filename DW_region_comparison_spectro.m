% This script follows DW_batch_subcort_spectrogram
% takes in data under contact_level_spectrogram folder
% tend to group compare contacts of different regions

%% all contacts included, regardless of side and contact type, spct ref

% This part was done before other parts

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])

% remove DBS4039 for now
contact_info(13:18) = [];

% re-give contact id
for i = 1:length(contact_info)
    contact_info(i).contact_id = i;
end

% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);
    
    if strcmp('VLa',contact_info(contact_id).group_used)
        VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
    elseif strcmp('VLp',contact_info(contact_id).group_used)
        VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
    elseif strcmp('VP',contact_info(contact_id).group_used)
        VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VLa_spct']);

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VLp_spct']);

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VP_spct']);

%% all contacts included, regardless of side and contact type, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VP_spct_unref']);

close all;





%% all contacts included, regardless of side and contact type, cuect ref

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VP_cuect']);

close all;

%% all contacts included, regardless of side and contact type, cuect unref

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'grand_VP_cuect_unref']);

close all;




%% left contacts included, regardless of contact type, spct ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue avg_word_off z1_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VLa_spct']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VLp_spct']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VP_spct']);

close all;

%% left contacts included, regardless of contact type, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VP_spct_unref']);

close all;



%% left contacts included, regardless of contact type, cuect ref

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VP_cuect']);

close all;

%% left contacts included, regardless of contact type, cuect unref

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'left_VP_cuect_unref']);

close all;


%% right contacts included, regardless of contact type, spct ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue avg_word_off z1_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VLa_spct']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VLp_spct']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VP_spct']);

close all;

%% right contacts included, regardless of contact type, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VP_spct_unref']);

close all;



%% right contacts included, regardless of contact type, cuect ref

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VP_cuect']);

close all;

%% right contacts included, regardless of contact type, cuect unref

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[13:18])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'right_VP_cuect_unref']);

close all;



















%% Only lead contacts included

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/Results/contact_loc/contact_info_step2.mat'])

% remove DBS4039 for now
contact_info(13:18) = [];

% re-give contact id
for i = 1:length(contact_info)
    contact_info(i).contact_id = i;
end

% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 34:89
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);
    
    if strcmp('VLa',contact_info(contact_id).group_used)
        VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
    elseif strcmp('VLp',contact_info(contact_id).group_used)
        VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
    elseif strcmp('VP',contact_info(contact_id).group_used)
        VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLa_spct']);

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLp_spct']);

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VP_spct']);

%% only left lead included

% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/Results/contact_loc/contact_info_step2.mat'])

% remove DBS4039 for now
contact_info(13:18) = [];

% re-give contact id
for i = 1:length(contact_info)
    contact_info(i).contact_id = i;
end

% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 34:89
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);
    
    if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
        VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
    elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
        VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
    elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
        VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLa_spct']);

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLp_spct']);

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VP_spct']);
















%% lead contacts included, regardless of side, spct ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])


% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions

for contact_id = 1:contact_n
    clearvars avg_cue avg_word_off z1_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLa_spct']);
close all;
% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLp_spct']);
close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VP_spct']);
close all;



%% lead contacts included, regardless of side, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VP_spct_unref']);

close all;





%% lead contacts included, regardless of side, cuect ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VP_cuect']);

close all;

%% lead contacts included, regardless of side, cuect unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_VP_cuect_unref']);

close all;






%% lead left contacts included, spct ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue avg_word_off z1_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLa_spct']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLp_spct']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VP_spct']);

close all;

%% lead_left contacts included, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VP_spct_unref']);

close all;



%% lead_left contacts included, cuect ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VP_cuect']);

close all;

%% lead_left contacts included, cuect unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_left_VP_cuect_unref']);

close all;














%% lead_right contacts included, spct ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue avg_word_off z1_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VLa_spct']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VLp_spct']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VP_spct']);

close all;

%% lead_right contacts included, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VP_spct_unref']);

close all;



%% lead_right contacts included, cuect ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VP_cuect']);

close all;

%% lead_right contacts included, cuect unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[1:39])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'lead_right_VP_cuect_unref']);

close all;
























%% macro contacts included, regardless of side, spct ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])


% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions

for contact_id = 1:contact_n
    clearvars avg_cue avg_word_off z1_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VLa_spct']);
close all;
% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VLp_spct']);
close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VP_spct']);
close all;



%% macro contacts included, regardless of side, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VP_spct_unref']);

close all;





%% macro contacts included, regardless of side, cuect ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VP_cuect']);

close all;

%% macro contacts included, regardless of side, cuect unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_VP_cuect_unref']);

close all;






%% macro left contacts included, spct ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue avg_word_off z1_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VLa_spct']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VLp_spct']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VP_spct']);

close all;

%% macro_left contacts included, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VP_spct_unref']);

close all;



%% macro_left contacts included, cuect ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VP_cuect']);

close all;

%% macro_left contacts included, cuect unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('left',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_left_VP_cuect_unref']);

close all;














%% macro_right contacts included, spct ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue avg_word_off z1_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z1_oi; cue_VLa = cue_VLa + avg_cue; sp_VLa = sp_VLa + avg_word_off;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z1_oi; cue_VLp = cue_VLp + avg_cue; sp_VLp = sp_VLp + avg_word_off;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z1_oi; cue_VP = cue_VP + avg_cue; sp_VP = sp_VP + avg_word_off;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VLa_spct']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VLp_spct']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VP_spct']);

close all;

%% macro_right contacts included, spct unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
cue_VLa = 0; cue_VLp = 0; cue_VP = 0;
sp_VLa = 0; sp_VLp = 0; sp_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_cue3 avg_word_off3 z3_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z3_oi; cue_VLa = cue_VLa + avg_cue3; sp_VLa = sp_VLa + avg_word_off3;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z3_oi; cue_VLp = cue_VLp + avg_cue3; sp_VLp = sp_VLp + avg_word_off3;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z3_oi; cue_VP = cue_VP + avg_cue3; sp_VP = sp_VP + avg_word_off3;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
cue_VLa_avg = cue_VLa / VLa_n;
sp_VLa_avg = sp_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
cue_VLp_avg = cue_VLp / VLp_n;
sp_VLp_avg = sp_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
cue_VP_avg = cue_VP / VP_n;
sp_VP_avg = sp_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-2,2,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLa_avg,cue_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLa_avg,sp_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VLa_spct_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-2,2,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VLp_avg,cue_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VLp_avg,sp_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VLp_spct_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-2,2,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_VP_avg,cue_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([sp_VP_avg,sp_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VP_spct_unref']);

close all;



%% macro_right contacts included, cuect ref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z2_oi; spon_VLa = spon_VLa + avg_word_on2; spoff_VLa = spoff_VLa + avg_word_off2;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z2_oi; spon_VLp = spon_VLp + avg_word_on2; spoff_VLp = spoff_VLp + avg_word_off2;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z2_oi; spon_VP = spon_VP + avg_word_on2; spoff_VP = spoff_VP + avg_word_off2;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VLa_cuect']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VLp_cuect']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VP_cuect']);

close all;

%% macro_right contacts included, cuect unref
clear all;
% specify machine
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat'])



% define variables
contact_n = length(contact_info);

z_VLa = [];z_VLp = [];z_VP = [];
VLa_n = 0; VLp_n = 0; VP_n = 0;
spon_VLa = 0; spon_VLp = 0; spon_VP = 0;
spoff_VLa = 0; spoff_VLp = 0; spoff_VP = 0;

% loop through all the contacts and categorize the data according to the
% regions
for contact_id = 1:contact_n
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    if ismember(contact_id,[13:18,40:95])
    else
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);

        if strcmp('VLa',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLa_n = VLa_n + 1; z_VLa(:,:,VLa_n) = z4_oi; spon_VLa = spon_VLa + avg_word_on4; spoff_VLa = spoff_VLa + avg_word_off4;
        elseif strcmp('VLp',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VLp_n = VLp_n + 1; z_VLp(:,:,VLp_n) = z4_oi; spon_VLp = spon_VLp + avg_word_on4; spoff_VLp = spoff_VLp + avg_word_off4;
        elseif strcmp('VP',contact_info(contact_id).group_used) && strcmp('right',contact_info(contact_id).side)
            VP_n = VP_n + 1; z_VP(:,:,VP_n) = z4_oi; spon_VP = spon_VP + avg_word_on4; spoff_VP = spoff_VP + avg_word_off4;
        end
    end
end

% get average data for each group

% VLa
z_VLa_avg = mean(z_VLa,3);
spon_VLa_avg = spon_VLa / VLa_n;
spoff_VLa_avg = spoff_VLa / VLa_n;

% VLp
z_VLp_avg = mean(z_VLp,3);
spon_VLp_avg = spon_VLp / VLp_n;
spoff_VLp_avg = spoff_VLp / VLp_n;

% VP
z_VP_avg = mean(z_VP,3);
spon_VP_avg = spon_VP / VP_n;
spoff_VP_avg = spoff_VP / VP_n;

% plot

% VLa
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLa_avg,1));
imagesc(t, fq, z_VLa_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLa_avg,spon_VLa_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLa_avg,spoff_VLa_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VLa_cuect_unref']);

close all;

% VLp
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VLp_avg,1));
imagesc(t, fq, z_VLp_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VLp_avg,spon_VLp_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VLp_avg,spoff_VLp_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VLp_cuect_unref']);

close all;

% VP
figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_VP_avg,1));
imagesc(t, fq, z_VP_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_VP_avg,spon_VP_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_VP_avg,spoff_VP_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/region_comparison/'...
'macro_right_VP_cuect_unref']);

close all;