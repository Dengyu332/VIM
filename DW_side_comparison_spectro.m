% This script follows DW_batch_subcort_spectrogram
% takes in data under contact_level_spectrogram folder
% intend to roughly compare the difference between left and right

% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% remove DBS4039 for now

contact_info(13:18) = [];

% re-give contact id
for i = 1:length(contact_info)
    contact_info(i).contact_id = i;
end

%% part I, all contacts
% define variables
contact_n = length(contact_info);

n_left = 0;
n_right = 0;

cue_left = 0;
cue_right = 0;
spoff_left = 0;
spoff_right = 0;
z_left = [];
z_right = [];

% loop through all contacts and retrieve data
for contact_id = 1:contact_n
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);
    
    if strcmp(contact_info(contact_id).side,'left')
        n_left = n_left + 1;
        cue_left = cue_left + avg_cue;
        spoff_left = spoff_left + avg_word_off;
        z_left(:,:,n_left) = z1_oi;
    else

        n_right = n_right + 1;
        cue_right = cue_right + avg_cue;
        spoff_right = spoff_right + avg_word_off;
        z_right(:,:,n_right) = z1_oi;
    end
    
end
 
% get grand averaged z and cue and speech offset for each side
z_left_avg = mean(z_left,3);
cue_left_avg = cue_left/n_left;
spoff_left_avg = spoff_left/n_left;

z_right_avg = mean(z_right,3);
cue_right_avg = cue_right/n_right;
spoff_right_avg = spoff_right/n_right;
% plot

% left
figure; colormap(jet)
t=linspace(-2,2,size(z_left_avg,1));
imagesc(t, fq, z_left_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_left_avg,cue_left_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_left_avg,spoff_left_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/side_comparison/'...
'grand_left_spct']);

% right

figure; colormap(jet)
t=linspace(-2,2,size(z_right_avg,1));
imagesc(t, fq, z_right_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_right_avg,cue_right_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_right_avg,spoff_right_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/side_comparison/'...
'grand_right_spct']);

%% Part II: lead only

% from 34 to 89
contact_info(1:33) = [];

% re-give contact id
for i = 1:length(contact_info)
    contact_info(i).contact_id = i;
end

% define variables
contact_n = length(contact_info);

n_left = 0;
n_right = 0;

cue_left = 0;
cue_right = 0;
spoff_left = 0;
spoff_right = 0;
z_left = [];
z_right = [];

%% loop through all contacts and retrieve data
for contact_id = 1:contact_n
    contact_used = contact_id + 33;
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_used) '_ref_spct.mat']);
    
    if strcmp(contact_info(contact_id).side,'left')
        n_left = n_left + 1;
        cue_left = cue_left + avg_cue;
        spoff_left = spoff_left + avg_word_off;
        z_left(:,:,n_left) = z1_oi;
    else

        n_right = n_right + 1;
        cue_right = cue_right + avg_cue;
        spoff_right = spoff_right + avg_word_off;
        z_right(:,:,n_right) = z1_oi;
    end
    
end
 
%% get grand averaged z and cue and speech offset for each side
z_left_avg = mean(z_left,3);
cue_left_avg = cue_left/n_left;
spoff_left_avg = spoff_left/n_left;

z_right_avg = mean(z_right,3);
cue_right_avg = cue_right/n_right;
spoff_right_avg = spoff_right/n_right;
%% plot

% left
figure; colormap(jet)
t=linspace(-2,2,size(z_left_avg,1));
imagesc(t, fq, z_left_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_left_avg,cue_left_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_left_avg,spoff_left_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/side_comparison/'...
'lead_left_spct']);

% right

figure; colormap(jet)
t=linspace(-2,2,size(z_right_avg,1));
imagesc(t, fq, z_right_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_right_avg,cue_right_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_right_avg,spoff_right_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/side_comparison/'...
'lead_right_spct']);


%% Part III: macro only

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/Results/contact_loc/contact_info_step2.mat'])

% from 34 to 89
contact_info(40:95) = [];

contact_info(13:18) = [];

% re-give contact id
for i = 1:length(contact_info)
    contact_info(i).contact_id = i;
end

% define variables
contact_n = length(contact_info);

n_left = 0;
n_right = 0;

cue_left = 0;
cue_right = 0;
spoff_left = 0;
spoff_right = 0;
z_left = [];
z_right = [];

%% loop through all contacts and retrieve data
for contact_id = 1:contact_n
    
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);
    
    if strcmp(contact_info(contact_id).side,'left')
        n_left = n_left + 1;
        cue_left = cue_left + avg_cue;
        spoff_left = spoff_left + avg_word_off;
        z_left(:,:,n_left) = z1_oi;
    else

        n_right = n_right + 1;
        cue_right = cue_right + avg_cue;
        spoff_right = spoff_right + avg_word_off;
        z_right(:,:,n_right) = z1_oi;
    end
    
end
 
%% get grand averaged z and cue and speech offset for each side
z_left_avg = mean(z_left,3);
cue_left_avg = cue_left/n_left;
spoff_left_avg = spoff_left/n_left;

z_right_avg = mean(z_right,3);
cue_right_avg = cue_right/n_right;
spoff_right_avg = spoff_right/n_right;
%% plot

% left
figure; colormap(jet)
t=linspace(-2,2,size(z_left_avg,1));
imagesc(t, fq, z_left_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-2,2]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_left_avg,cue_left_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_left_avg,spoff_left_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/side_comparison/'...
'macro_left_spct']);

% right

figure; colormap(jet)
t=linspace(-2,2,size(z_right_avg,1));
imagesc(t, fq, z_right_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-5,5]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_right_avg,cue_right_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_right_avg,spoff_right_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/side_comparison/'...
'macro_right_spct']);