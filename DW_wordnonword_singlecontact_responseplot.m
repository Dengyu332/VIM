% Created on 10/10/2018
% aims to make good figures of single unit band activity word vs. nonword
% strategy: pick some typical unit to try first
% use contact_50_session1_highgamma_ref as an example unit

% generate figures under /VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg

% specify machine
DW_machine;
% sampling frequency
fs = 1000;
% load in contact 50 session 1 ref_highgamma, which is a typical unit
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/contact_50_session1_highgamma_ref.mat']);
% define trials starts and ends
starts_oi = num2cell(round((epoch_oi.onset_word - epoch_oi.starts - 2) * fs))';
ends_oi = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 2) * fs) )';
% Why having 4001 points? For enough points after downsampling

temp = cellfun(@(x,y,z) x(y:z),z_oi,starts_oi,ends_oi,'UniformOutput',0); % -2 to 2 peri spon trials

bases = cellfun(@(x) x(1000:2000),z_oi,'UniformOutput',0); % base for each trial, which is 1s precue
% 1001 points for downsampling

nonword_idx = find(mod(epoch_oi.trial_id,2)~=0 & epoch_oi.trial_id<=60); %nonword index
word_idx =  find(mod(epoch_oi.trial_id,2)==0 & epoch_oi.trial_id<=60); % word index

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = temp(word_idx); nonword_trials = temp(nonword_idx);
word_bases = bases(word_idx);nonword_bases = bases(nonword_idx);

% Get average trial and base for word and nonword
word_t = mean(cell2mat(word_trials'));
nonword_t = mean(cell2mat(nonword_trials'));

word_b = mean(cell2mat(word_bases'));
nonword_b = mean(cell2mat(nonword_bases'));

% plot stage1 figure
figure; plot(word_t); hold on; plot(nonword_t)
% not normalized, not smoothed, not downsampled: look very noisy and can
% see nothing
saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg/stage1.fig']);

% Normalize to base
% operation name is added to the end of each new variable
word_tn = (word_t - mean(word_b))./std(word_b); word_bn = (word_b - mean(word_b))./std(word_b);
nonword_tn = (nonword_t - mean(nonword_b))./std(nonword_b); nonword_bn = (nonword_b - mean(nonword_b)) ./ std(nonword_b);
% plot stage2 figure
figure; plot(word_tn); hold on; plot(nonword_tn)
% same with stage1 figure except larger scale
saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg/stage2.fig']);

close all;
% word_tn, word_bn, nonword_tn, nonword_bn is used downstreamly

% what's next
% It's really open questions about how to get the ideal curves, I tried
% many different methods and different method combination (smooth and
% downsample and normalize)

% try different smooth time and downsample and normalization combination

%%%%%%%%%%%%%%%%%%%%%%%%%solution 1: 4hz downsample, normalize and then smooth twice

% downsample to 4hz and normalize
word_tnd = resample(word_tn,4,1000); nonword_tnd = resample(nonword_tn,4,1000);
word_bnd = resample(word_bn,4,1000); nonword_bnd = resample(nonword_bn,4,1000);

word_tndn = (word_tnd - mean(word_bnd))./std(word_bnd);
nonword_tndn = (nonword_tnd - mean(nonword_bnd))./ std(nonword_bnd);

word_bndn = (word_bnd - mean(word_bnd))./std(word_bnd);
nonword_bndn = (nonword_bnd - mean(nonword_bnd))./ std(nonword_bnd);

figure; plot(word_tnd); hold on; plot(nonword_tnd); xlim([1 17]);
figure; plot(word_tndn); hold on; plot(nonword_tndn); xlim([1 17]);
%region_oi plot
figure; plot(word_tnd(5:13)); hold on; plot(nonword_tnd(5:13));
figure; plot(word_tndn(5:13)); hold on; plot(nonword_tndn(5:13));
% looks fine, save as stage3_2s
saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg/stage3_2s.fig']);

% smooth twice


word_tndns = smoothdata(word_tndn); nonword_tndns = smoothdata(nonword_tndn);
word_tndnss = smooth(word_tndns); nonword_tndnss = smooth(nonword_tndns);
figure; plot(word_tndnss); hold on; plot(nonword_tndnss); xlim([1 17]);
% save as stage4
saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg/stage4.fig']);

figure; plot(word_tndnss(5:13)); hold on; plot(nonword_tndnss(5:13)); % not good

% try smoothdata function
word_tndnss = smoothdata(word_tndns); nonword_tndnss = smoothdata(nonword_tndns);
figure; plot(word_tndnss); hold on; plot(nonword_tndnss); xlim([1 17]);
% save as stage5
saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg/stage5.fig']);

figure; plot(word_tndnss(5:13)); hold on; plot(nonword_tndnss(5:13)); % not good

%%%%%%%%%%%% end solution1

%%%%%%%%%%%%%% solution 2: smooth once with smoothdata rlowess, normalize,
%%%%%%%%%%%%%% downsample to 4hz

% smooth with rlowess
word_tns = smoothdata(word_tn,'rlowess',200);  nonword_tns = smoothdata(nonword_tn,'rlowess',200);
word_bns = smoothdata(word_bn,'rlowess',200);  nonword_bns = smoothdata(nonword_bn,'rlowess',200);

% normalize
word_tnsn = (word_tns - mean(word_bns))./ std(word_bns);
nonword_tnsn= (nonword_tns - mean(nonword_bns))./ std(nonword_bns);

word_bnsn = (word_bns - mean(word_bns))./ std(word_bns);
nonword_bnsn= (nonword_bns - mean(nonword_bns))./ std(nonword_bns);

figure; plot(word_tnsn); hold on; plot(nonword_tnsn);

% select region_oi
word_tnsnr = word_tnsn(1000:3000);
nonword_tnsnr = nonword_tnsn(1000:3000);

% downsample
word_tnsnrd = resample(word_tnsnr,4,1000);
nonword_tnsnrd = resample(nonword_tnsnr,4,1000);
figure; plot(word_tnsnrd); hold on; plot(nonword_tnsnrd);
% pretty good, save as stage6
saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg/stage6.fig']);

%%% end solution2 


%%%%%%%%%%%%%%%%%%%%% bold attempts
aa = smoothdata(nonword_t,'movmean',200); bb = smoothdata(aa,'movmean',200); cc = smoothdata(bb,'movmean',200);dd = cc(1000:3000);ff = resample(dd,4,1000);
qq = smoothdata(word_t,'movmean',200); ww = smoothdata(qq,'movmean',200); ee = smoothdata(ww,'movmean',200); rr = ee(1000:3000);tt = resample(rr,4,1000);
figure; plot(tt); hold on; plot(ff);

aa = smoothdata(nonword_t,'rlowess',200); bb = smoothdata(aa,'rlowess',200); cc = smoothdata(bb,'rlowess',200);dd = cc(1000:3000);ff = resample(dd,4,1000);
qq = smoothdata(word_t,'rlowess',200); ww = smoothdata(qq,'rlowess',200); ee = smoothdata(ww,'rlowess',200); rr = ee(1000:3000);tt = resample(rr,4,1000);
figure; plot(tt); hold on; plot(ff);

aa = smoothdata(nonword_t,'gaussian',200); bb = smoothdata(aa,'gaussian',200); cc = smoothdata(bb,'gaussian',200);dd = cc(1000:3000);ff = resample(dd,4,1000);
qq = smoothdata(word_t,'gaussian',200); ww = smoothdata(qq,'gaussian',200); ee = smoothdata(ww,'gaussian',200); rr = ee(1000:3000);tt = resample(rr,4,1000);
figure; plot(tt); hold on; plot(ff);
%%%%%%%%%%%%%%%%%%%


%%%%%%%%%pauses%%%%%%%%%%%%
%%%%% for now, use stage6 strategy, but smooth with single trial and then
%%%%% normalize with single trial, in order to get smaller sem
%%% followingly we plot a paper-quality single unit differential band
%%% response of wordvs.nonword


clear all; clc; close all;
% specify machine
DW_machine;
% sampling frequency
fs = 1000;
% load in contact 50 session 1 ref_highgamma, which is a typical unit
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/contact_50_session1_highgamma_ref.mat']);
% define trials starts and ends
starts_oi = num2cell(round((epoch_oi.onset_word - epoch_oi.starts - 2) * fs))';
ends_oi = num2cell(round((epoch_oi.onset_word - epoch_oi.starts + 2) * fs) )';
% Why having 4001 points? For enough points after downsampling

temp = cellfun(@(x,y,z) x(y:z),z_oi,starts_oi,ends_oi,'UniformOutput',0); % -2 to 2 peri spon trials

bases = cellfun(@(x) x(1000:2000),z_oi,'UniformOutput',0); % base for each trial, which is 1s precue
% 1001 points for downsampling

% smooth with rlowess first, beacause need to get smaller se
temp = cellfun(@(x) smoothdata(x,'rlowess',1000),temp,'UniformOutput',0);
bases = cellfun(@(x) smoothdata(x,'rlowess',1000),bases,'UniformOutput',0);

% normalize single trials
temp = cellfun(@(x,y) (x - mean(y))./std(y),temp,bases,'UniformOutput',0);
bases = cellfun(@(x) (x - mean(x))./std(x),bases,'UniformOutput',0);

nonword_idx = find(mod(epoch_oi.trial_id,2)~=0 & epoch_oi.trial_id<=60); %nonword index
word_idx =  find(mod(epoch_oi.trial_id,2)==0 & epoch_oi.trial_id<=60); % word index

% respectively pick out word trials, nonword trials, word bases and nonword
% bases
word_trials = temp(word_idx); nonword_trials = temp(nonword_idx);
word_bases = bases(word_idx);nonword_bases = bases(nonword_idx);


% Get three lines for each selection
word_t = mean(cell2mat(word_trials'));
word_std = std(cell2mat(word_trials'),0,1);
% get se out of std
word_se = word_std./ sqrt(size(word_idx,1));

figure; plot(word_t - word_se); hold on; plot(word_t); hold on; plot(word_t + word_se); % good

word_ta = {(word_t - word_se)', word_t', (word_t+ word_se)'};
word_t = word_ta;
%%% word trial finish

nonword_t = mean(cell2mat(nonword_trials'));
nonword_std = std(cell2mat(nonword_trials'),0,1);
nonword_se = nonword_std./sqrt(size(nonword_idx,1));

nonword_ta = {(nonword_t - nonword_se)', nonword_t', (nonword_t+ nonword_se)'};
nonword_t = nonword_ta;
%%% nonword trial finish

word_b = mean(cell2mat(word_bases'))';
nonword_b = mean(cell2mat(nonword_bases'))';

% don't normalize again

figure; plot(cell2mat(word_t)); %good
figure; plot(cell2mat(nonword_t)); %good
close all;

% select region_oi
word_tr = cellfun(@(x) x(1000:3000),word_t,'UniformOutput',0);
nonword_tr = cellfun(@(x) x(1000:3000),nonword_t,'UniformOutput',0);


% downsample
word_trd = cellfun(@(x) resample(x,4,1000),word_tr,'UniformOutput',0);
nonword_trd = cellfun(@(x) resample(x,4,1000),nonword_tr,'UniformOutput',0);

% plot
figure; plot(cell2mat(word_trd)); hold on; plot(cell2mat(nonword_trd)); % good

%%% use shadedErrorBar function

word_sef = word_trd{3} - word_trd{2};
nonword_sef = nonword_trd{3} - nonword_trd{2};

Tline = -1:0.25:1';

close all; figure (1); hold on; 
word_line = shadedErrorBar(Tline,word_trd{2},word_sef,'lineprops','-blue','patchSaturation',0.5);
word_line.mainLine.LineWidth = 2; word_line.mainLine.Color = [0.2,0.4,0.9];word_line.patch.FaceColor = [0.2,0.4,0.9];

nonword_line = shadedErrorBar(Tline,nonword_trd{2},nonword_sef,'lineprops','-r','patchSaturation',0.5);
nonword_line.mainLine.LineWidth = 2;nonword_line.mainLine.Color = [1,0,0];nonword_line.patch.FaceColor = [1,0,0];

% get the handle of the axes
figure (1); h_ax = gca;
set(h_ax,'XTick',-1:0.5:1);
set(h_ax,'box','on');
set(h_ax,'TickLength',[0.005,0.005]);
xlabel(h_ax,'Time Relative to Speech Onset (s)');
set(h_ax,'YLim',[-1,5]);
ylabel(h_ax,'High Gamma z-score');

% get average cue onset and word offset time
cue_all = epoch_oi.stimulus_starts - epoch_oi.onset_word;
word_cue_mean = mean(cue_all(word_idx));
nonword_cue_mean = mean(cue_all(nonword_idx));

spoff_all = epoch_oi.offset_word - epoch_oi.onset_word;
word_spoff_mean = mean(spoff_all(word_idx));
nonword_spoff_mean = mean(spoff_all(nonword_idx));

word_spoff_line = plot([word_spoff_mean,word_spoff_mean], ylim);
word_spoff_line.Color = [0.2,0.4,0.9];
word_spoff_line.LineStyle = '--';

nonword_spoff_line = plot([nonword_spoff_mean,nonword_spoff_mean], ylim);
nonword_spoff_line.Color = [1,0,0];
nonword_spoff_line.LineStyle = '--';

%%%% optional
% pp = patch([0 0.5 0.5 0],[-1 -1 5 5],[0.3 0.3 0.3]);
% pp.EdgeAlpha = 0;pp.FaceAlpha = 0.5;

%%% I think line maybe better

period2_line = plot([0,0.5],[4.2,4.2],'k-','LineWidth',3);

% add asterisk
aster = plot(0.25,4.5,'k*','MarkerSize',10);

% save as stage final
saveas(gcf,[dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/c50_s1_r_hg/stage_final.fig']);