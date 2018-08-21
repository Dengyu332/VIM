% This script follows DW_batch_subcort_spectrogram

% Intend to get a grand average figure of overall spectrogram regarding speech



% strategy: first retreive a mean trial spectrogram for each recording site, then average
% across sites

% add cue centered images on 07/26/2018

%% all, referenced, % center on speech onset, -2 to 2 s

% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

num_contact = length(dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_*_ref_spct.mat']));

cue_total = 0;
total_word_off = 0 ;

% group all data
for contact_id = 1:num_contact
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_spct.mat']);
    cue_total = cue_total + avg_cue; total_word_off = total_word_off + avg_word_off;
    
    z_total(:,:,contact_id) = z1_oi;
end

% get grand averaged z and cue and speech offset
z_grand_avg = mean(z_total,3);

cue_grand_avg = cue_total/num_contact;
spoff_grand_avg = total_word_off/num_contact;

% plot

figure; colormap(jet)
t=linspace(-2,2,size(z_grand_avg,1));
imagesc(t, fq, z_grand_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_grand_avg,cue_grand_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_avg,spoff_grand_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_specto_spct']);

close all;

%% all, referenced, center on cue -1.5 to 2s

clear all;

% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

total_word_on = 0;
total_word_off = 0;

% exclude DBS4039 for now
contact_oi = [1:12,19:95];
contact_i = 0;
for contact_id = contact_oi
    contact_i = contact_i + 1;
    clearvars avg_word_on2 avg_word_off2 z2_oi;
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_ref_cuect.mat']);
    total_word_on = total_word_on + avg_word_on2; total_word_off = total_word_off + avg_word_off2;
    
    z_total(:,:,contact_i) = z2_oi;
end

% get grand averaged z and cue and speech offset
z_grand_avg = mean(z_total,3);

spon_grand_avg = total_word_on/contact_i;
spoff_grand_avg = total_word_off/contact_i;

% plot

figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_grand_avg,1));
imagesc(t, fq, z_grand_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_grand_avg,spon_grand_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_avg,spoff_grand_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_specto_cuect']);

close all;

%% average across macro, ref
% contact_id of macro: 1:33

clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

cue_macro_total = 0;
spoff_macro_total = 0;

for macro_contact = 1:33
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(macro_contact) '_ref_spct.mat']);
    
    cue_macro_total = cue_macro_total + avg_cue; spoff_macro_total = spoff_macro_total + avg_word_off;
    
    z_total_macro(:,:,macro_contact) = z1_oi;
end

% get grand averaged z and cue and speech offset across macro recordings
z_grand_macro = mean(z_total_macro,3);

cue_grand_macro = cue_macro_total/33;
spoff_grand_macro = spoff_macro_total/33;

% plot

figure; colormap(jet)
t=linspace(-2,2,size(z_grand_macro,1));
imagesc(t, fq, z_grand_macro(:,:)');set(gca, 'YDir', 'Normal');
caxis([-2,2]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_grand_macro,cue_grand_macro],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_macro,spoff_grand_macro],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_macro_spct']);

close all;



%% average across macro, ref, cue centered (-1.5 to 2.5)
% contact_id of macro: [1:12, 19:39]

clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

spon_macro_total = 0;
spoff_macro_total = 0;

contact_i = 0;
for macro_contact = [1:12,19:39]
    
    contact_i = contact_i + 1;
    clearvars avg_word_on2 avg_word_off2 z2_oi;   
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(macro_contact) '_ref_cuect.mat']);
    
    spon_macro_total = spon_macro_total + avg_word_on2; spoff_macro_total = spoff_macro_total + avg_word_off2;
    
    z_total_macro(:,:,contact_i) = z2_oi;
end

% get grand averaged z and cue and speech offset across macro recordings
z_grand_macro = mean(z_total_macro,3);

spon_grand_macro = spon_macro_total/33;
spoff_grand_macro = spoff_macro_total/33;

% plot

figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_grand_macro,1));
imagesc(t, fq, z_grand_macro(:,:)');set(gca, 'YDir', 'Normal');
caxis([-2,2]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_grand_macro,spon_grand_macro],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_macro,spoff_grand_macro],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_macro_cuect']);

close all;


%% average across lead, ref
% contact_id of lead: 34:89
clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

cue_lead_total = 0;
spoff_lead_total = 0;

for lead_contact = 34:89
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(lead_contact) '_ref_spct.mat']);
    
    cue_lead_total = cue_lead_total + avg_cue; spoff_lead_total = spoff_lead_total + avg_word_off;
    
    z_total_lead(:,:,lead_contact-33) = z1_oi;
end

% get grand averaged z and cue and speech offset across lead recordings
z_grand_lead = mean(z_total_lead,3);

cue_grand_lead = cue_lead_total/56;
spoff_grand_lead = spoff_lead_total/56;

% plot

figure; colormap(jet)
t=linspace(-2,2,size(z_grand_lead,1));
imagesc(t, fq, z_grand_lead(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_grand_lead,cue_grand_lead],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_lead,spoff_grand_lead],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_lead_spct']);

close all;

%% average across lead, ref, cue centered
% contact_id of lead: 40:95
clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

spon_lead_total = 0;
spoff_lead_total = 0;

for lead_contact = 40:95
    
    clearvars avg_word_on2 avg_word_off2 z2_oi
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(lead_contact) '_ref_cuect.mat']);
    
    spon_lead_total = spon_lead_total + avg_word_on2; spoff_lead_total = spoff_lead_total + avg_word_off2;
    
    z_total_lead(:,:,lead_contact-39) = z2_oi;
end

% get grand averaged z and cue and speech offset across lead recordings
z_grand_lead = mean(z_total_lead,3);

spon_grand_lead = spon_lead_total/56;
spoff_grand_lead = spoff_lead_total/56;

% plot

figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_grand_lead,1));
imagesc(t, fq, z_grand_lead(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_grand_lead,spon_grand_lead],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_lead,spoff_grand_lead],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_lead_cuect']);

close all;

%% average across lead, unref
% contact_id of lead: 34:89
clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

cue_lead_total = 0;
spoff_lead_total = 0;

for lead_contact = 34:89
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(lead_contact) '_unref_spct.mat']);
    
    cue_lead_total = cue_lead_total + avg_cue3; spoff_lead_total = spoff_lead_total + avg_word_off3;
    
    z_total_lead(:,:,lead_contact-33) = z3_oi;
end

% get grand averaged z and cue and speech offset across lead recordings
z_grand_lead = mean(z_total_lead,3);

cue_grand_lead = cue_lead_total/56;
spoff_grand_lead = spoff_lead_total/56;

% plot

figure; colormap(jet)
t=linspace(-2,2,size(z_grand_lead,1));
imagesc(t, fq, z_grand_lead(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_grand_lead,cue_grand_lead],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_lead,spoff_grand_lead],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_lead_spct_unref']);

close all;


%% average across lead, unref, cue centered
% contact_id of lead: 40:95
clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

spon_lead_total = 0;
spoff_lead_total = 0;

for lead_contact = 40:95
    
    clearvars avg_word_on4 avg_word_off4 z4_oi
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(lead_contact) '_unref_cuect.mat']);
    
    spon_lead_total = spon_lead_total + avg_word_on4; spoff_lead_total = spoff_lead_total + avg_word_off4;
    
    z_total_lead(:,:,lead_contact-39) = z4_oi;
end

% get grand averaged z and cue and speech offset across lead recordings
z_grand_lead = mean(z_total_lead,3);

spon_grand_lead = spon_lead_total/56;
spoff_grand_lead = spoff_lead_total/56;

% plot

figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_grand_lead,1));
imagesc(t, fq, z_grand_lead(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_grand_lead,spon_grand_lead],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_lead,spoff_grand_lead],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_lead_cuect_unref']);

close all;

%% average across macro, unref, cue centered (-1.5 to 2.5)
% contact_id of macro: [1:12, 19:39]

clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

spon_macro_total = 0;
spoff_macro_total = 0;

contact_i = 0;
for macro_contact = [1:12,19:39]
    
    contact_i = contact_i + 1;
    clearvars avg_word_on4 avg_word_off4 z4_oi;   
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(macro_contact) '_unref_cuect.mat']);
    
    spon_macro_total = spon_macro_total + avg_word_on4; spoff_macro_total = spoff_macro_total + avg_word_off4;
    
    z_total_macro(:,:,contact_i) = z4_oi;
end

% get grand averaged z and cue and speech offset across macro recordings
z_grand_macro = mean(z_total_macro,3);

spon_grand_macro = spon_macro_total/33;
spoff_grand_macro = spoff_macro_total/33;

% plot

figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_grand_macro,1));
imagesc(t, fq, z_grand_macro(:,:)');set(gca, 'YDir', 'Normal');
caxis([-2,2]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_grand_macro,spon_grand_macro],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_macro,spoff_grand_macro],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_macro_cuect_unref']);

close all;


%% average across macro, unref
% contact_id of macro: 1:33
clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

cue_macro_total = 0;
spoff_macro_total = 0;

for macro_contact = 1:33
    
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(macro_contact) '_unref_spct.mat']);
    
    cue_macro_total = cue_macro_total + avg_cue3; spoff_macro_total = spoff_macro_total + avg_word_off3;
    
    z_total_macro(:,:,macro_contact) = z3_oi;
end

% get grand averaged z and cue and speech offset across macro recordings
z_grand_macro = mean(z_total_macro,3);

cue_grand_macro = cue_macro_total/33;
spoff_grand_macro = spoff_macro_total/33;

% plot

figure; colormap(jet)
t=linspace(-2,2,size(z_grand_macro,1));
imagesc(t, fq, z_grand_macro(:,:)');set(gca, 'YDir', 'Normal');
caxis([-2,2]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_grand_macro,cue_grand_macro],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_macro,spoff_grand_macro],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_macro_spct_unref']);

close all;

%% all, unreferenced
clear all;
% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

num_contact = length(dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_*_unref_spct.mat']));

cue_total = 0;
total_word_off = 0 ;

% group all data
for contact_id = 1:num_contact
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_spct.mat']);
    cue_total = cue_total + avg_cue3; total_word_off = total_word_off + avg_word_off3;
    
    z_total(:,:,contact_id) = z3_oi;
end

% get grand averaged z and cue and speech offset
z_grand_avg = mean(z_total,3);

cue_grand_avg = cue_total/num_contact;
spoff_grand_avg = total_word_off/num_contact;

% plot

figure; colormap(jet)
t=linspace(-2,2,size(z_grand_avg,1));
imagesc(t, fq, z_grand_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([cue_grand_avg,cue_grand_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_avg,spoff_grand_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_specto_spct_unref']);

close all;


%% all, unreferenced, center on cue -1.5 to 2.5s

clear all;

% specify the machine to run
DW_machine;

% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

total_word_on = 0;
total_word_off = 0;

% exclude DBS4039 for now
contact_oi = [1:12,19:95];
contact_i = 0;
for contact_id = contact_oi
    contact_i = contact_i + 1;
    clearvars avg_word_on4 avg_word_off4 z4_oi;
    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/contact_' num2str(contact_id) '_unref_cuect.mat']);
    total_word_on = total_word_on + avg_word_on4; total_word_off = total_word_off + avg_word_off4;
    
    z_total(:,:,contact_i) = z4_oi;
end

% get grand averaged z and cue and speech offset
z_grand_avg = mean(z_total,3);

spon_grand_avg = total_word_on/89;
spoff_grand_avg = total_word_off/89;

% plot

figure; colormap(jet)
t=linspace(-1.5,2.5,size(z_grand_avg,1));
imagesc(t, fq, z_grand_avg(:,:)');set(gca, 'YDir', 'Normal');
caxis([-3,3]); box off;% remove upper and right lines

% plot timepoints
hold on; plot([spon_grand_avg,spon_grand_avg],ylim,'k--');
plot([0,0],ylim,'k--'); 
plot([spoff_grand_avg,spoff_grand_avg],ylim,'k--');

xlabel('Time (s)'); % x-axis label
ylabel('Frequency (Hz)'); % y-axis label

colorbar;

saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/grand_avg/'...
'grand_specto_cuect_unref']);

close all;