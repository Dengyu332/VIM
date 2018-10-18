% first created on 08/25/2018

% follows DW_generate_response_table.m and DW_batch_subcort_single_contact_hilb_pertrial.m
% takes in speech_response_table.mat, contact_info_step2.mat

% purpose: experiment with several methods of detecting single trial
% activation

% strategy: First identify contacts of significant change during activation
% Then do response timing analysis (either locking analysis or latency analysis)

%specify machine
DW_machine;

%%%%%%%%%%%%%%%%%%%%%% identify significant contacts of band_oi %%%%%%%%%%
% read in speech response table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/speech_response_table.mat']);

% extract ref_highgamma's p and h
pvals = extractfield(speech_response_table,'ref_highgamma_p');
hvals = extractfield(speech_response_table,'ref_highgamma_h');

adj_pvals = pvals * length(pvals); % Bonferroni correction for multiple comparisons

sgnf_contacts = find(hvals == 1 & adj_pvals < 0.05); % get contacts of positive, significant changes

% None of DBS4039's contact is in sgnf_contacts, so no need to worry

% load in contact info table
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% sampling frequency
fs = 1000;

clearvars -except contact_info dionysis dropbox readme sgnf_contacts speech_response_table fs

%% start the super loop
contact_id = 94;
    
% get dir for possible sessions of this contact
temp = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_pertrial_band_activity/'...
'contact_' num2str(contact_id) '_*highgamma_ref.mat']);

session_id = 1;
% load in data: z_oi, epoch_oi, time_oi
load([temp(session_id).folder filesep temp(session_id).name]);
%% sort according to speech latency

reactionT = epoch_oi.onset_word - epoch_oi.stimulus_starts; % reaction time

[st_reactionT, st_order]  = sort(reactionT);

% st_reactionT: sorted reaction time
% order used to sort z_oi

% get sorted z and sorted epoch
st_z = z_oi(st_order); % each trial is 2s precue to 2s post speech offset
st_epoch = epoch_oi(st_order,:);
st_cue2finish = st_epoch.offset_word - st_epoch.stimulus_starts; % duration between cue and word off

clearvars reactionT; 
%%%%%%%%%%%%%%%%% activation detection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% method 1: moving bins detection

%%% firstly detect the maximal activation time
%area to detect: between cue onset to speech offset
%strategy: nested bin method: 200ms bins to first-run locate the target, then 25ms bins of smoothed data within it to pinpoint the target
% first-run bins too short may get short, false activation, too long is not proper either, may get non-activated period

detect_starts = num2cell((st_epoch.stimulus_starts - st_epoch.starts) * fs + 1)';
detect_ends = num2cell(round((st_epoch.offset_word - st_epoch.starts) * fs))';

st_z_detect_used = cellfun(@(x,y,z) z(x:y), detect_starts, detect_ends, st_z,'UniformOutput',0);

% first run
num_bin = cellfun(@(x) floor(length(x) - 199),st_z_detect_used,'UniformOutput',0);

% first identify the maximal bin index for each trial
for tr = 1:length(st_z_detect_used);
    for bin_idx = 1:num_bin{tr};
        bin_val{tr,bin_idx} = st_z_detect_used{tr}(bin_idx:bin_idx+199);
    end
end

mean_bin = cellfun(@(x) mean(x),bin_val);
[max_bin_val, max_bin_idx] = max(mean_bin,[],2);

time2max_init = max_bin_idx/1000 + 0.1  - 0.001; % middle of the bin is set as time2max, relative to cue onset


%%% second-run with 25ms bins        
st_z_smooth = cellfun(@(x) smooth(x',200)',st_z,'UniformOutput',0); % now the period is still 2s precue to 2s post speech off

num_2ndbin = 200 - 24;
bin_starts = 1:176;
bin_ends = 25:200;

clearvars time2max_method1
for tr = 1:length(st_z_smooth)
    maxbin_oi = st_z_smooth{tr}(detect_starts{tr} + max_bin_idx(tr) - 1:detect_starts{tr} + max_bin_idx(tr) - 1+199);
    secondbins = cell2mat(arrayfun(@(x,y) maxbin_oi(x:y),bin_starts,bin_ends,'UniformOutput',0)');            
    [~,max_2ndbin_idx] = max(mean(secondbins,2));
    time2max_method1(tr,1) = max_bin_idx(tr)/1000 - 0.001 + max_2ndbin_idx/1000 - 0.001 + 0.0125;
end        

[rho, p] = corr(time2max_init,st_reactionT); % test the correlation between time2max and reaction time
[rho, p] = corr(time2max_method1,st_reactionT); % test the correlation between time2max and reaction time

clearvars num_bin bin_idx bin_val mean_bin max_bin_val max_bin_idx num_2ndbin bin_starts bin_ends maxbin_oi secondbins ...
    max_2ndbin_idx detect_starts detect_ends;

%%% then identify activation onset time
% need to use smoothed data, region oi is cue to time2max_method1

detect_starts = num2cell((st_epoch.stimulus_starts - st_epoch.starts) * fs + 1)';
detect_ends = num2cell(cell2mat(detect_starts) + round(time2max_method1' * fs) - 1);

z_acton_used = cellfun(@(x,y,z) z(x:y), detect_starts, detect_ends, st_z_smooth,'UniformOutput',0);

clearvars detect_starts detect_ends

% strategy: divide trials to 25ms bins and calculate adjiacent difference, bins with changing starts; trials too close to cueonset just use 0 as acton
for tr = 1:length(z_acton_used)
    if length(z_acton_used{tr}) <= 100
        ActOnset_method1(tr,1) = 0;
    else

        for mving_idx = 1:25
            num_bin = floor((length(z_acton_used{tr}) - mving_idx + 1)/25);
            bins_matrix = reshape(z_acton_used{tr}(mving_idx : num_bin * 25 + mving_idx - 1),25,[]);
        % each bin is a column
            bins_mean = mean(bins_matrix);

            diff_mean = diff(bins_mean,1,2);
            [max_diff_val(mving_idx),max_diff_idx(mving_idx)] = max(diff_mean);
        end

        [max_2_judge,mving_idx_togo] = max(max_diff_val); % mving_idx_togo

        if max_2_judge < 0
            ActOnset_method1(tr,1) = 0;
        else

            ActOnset_method1(tr, 1) = max_diff_idx(mving_idx_togo) * 0.025 + (mving_idx_togo-1) * 0.001;
        end
    end
end

[rho, p] = corr(ActOnset_method1,st_reactionT); % test the correlation between ActOnset and reaction time

clearvars z_acton_used tr mving_idx num_bin bins_matrix bins_mean diff_mean max_diff_val max_diff_idx max_2_judge mving_idx_togo;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end method 1%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% method 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adapted from Ahmad's single trial detection

% smooth the "raw" data
st_z_smooth = cellfun(@(x) smooth(x',200)',st_z,'UniformOutput',0);

base = cellfun(@(x) x(1001:2000), st_z_smooth, 'UniformOutput',0); %baseline (which is 1s pre-cue)

% normalize to baseline
st_z_smooth_norm = cellfun(@(x,y) (x-mean(y))./std(y), st_z_smooth, base,'UniformOutput',0);

detect_starts = num2cell((st_epoch.stimulus_starts - st_epoch.starts) * fs + 1)';
detect_ends = num2cell(round((st_epoch.offset_word - st_epoch.starts) * fs))';

zz = cellfun(@(x,y,z) z(x:y), detect_starts, detect_ends, st_z_smooth_norm,'UniformOutput',0);

% zb = cellfun(@(x) x(1001:2000), st_z_smooth_norm, 'UniformOutput',0);

%thresh=1.645:0.05:6;
thresh = 1.645;


% for t=1:length(thresh)
%     bdec=sum(cell2mat(cellfun(@(x) prctile(x,100),zb,'UniformOutput',0))> thresh(t));
%     tdec=sum(cell2mat(cellfun(@(x) prctile(x,100),zz,'UniformOutput',0))> thresh(t));
%     detdiff(t)=tdec-bdec;
% end
% [~,mi]=max(detdiff);
% zthresh = thresh(mi);

tmp = cellfun(@(x) bwconncomp(x > thresh),zz,'UniformOutput',0);

%% edition1
for i=1:length(tmp)
   [detlen]=arrayfun(@(x) sum(zz{i}(tmp{i}.PixelIdxList{x})),1:length(tmp{i}.PixelIdxList));
   if isempty(detlen)
       Act_idx(i)=NaN;
   else
       
       [~,mi]=max(detlen);
           
       Act_idx(i)=tmp{i}.PixelIdxList{mi}(1);
   end

end

ActOnset_method2 = (Act_idx -1)/1000;



%% edition 2
PixelIdxList = cellfun(@(x) x.PixelIdxList,tmp,'UniformOutput',0);

clearvars conn_pixel

for i = 1:length(PixelIdxList)
    if length(PixelIdxList{i}) <= 1
        conn_pixel{i} = PixelIdxList{i};
    else
        alldots_i = cell2mat(PixelIdxList{i}');
        breaks = find(diff(alldots_i)>=49);
        
        if isempty(breaks)
            conn_pixel{i}{1} = (min(alldots_i):max(alldots_i))';
        else
        
            for i2 = 1:length(breaks)
                if i2 == 1
                    conn_pixel{i}{i2} = (min(alldots_i(1:breaks(i2))):1:max(alldots_i(1:breaks(i2))))';  
                else
                    conn_pixel{i}{i2} = (alldots_i(breaks(i2-1)+1):alldots_i(breaks(i2)))'; 
                end

                if i2 == length(breaks)
                    conn_pixel{i}{i2+1} = (alldots_i(breaks(i2)+1):alldots_i(end))';
                end
            end
            
        end
    end
end

% get conn_pixel

for i = 1:length(conn_pixel)
    [detlen] = cell2mat(cellfun(@(x) sum(zz{i}(x)),conn_pixel{i},'UniformOutput',0));
    if isempty(detlen)
       Act_idx(i)=NaN;    
    else
       
       [~,mi]=max(detlen);
        Act_idx(i)= conn_pixel{i}{mi}(1);
    end
end

ActOnset_method2 = (Act_idx -1)/1000;
               
%% edition 3
PixelIdxList = cellfun(@(x) x.PixelIdxList,tmp,'UniformOutput',0);

clearvars conn_pixel

for i = 1:length(PixelIdxList)
    if length(PixelIdxList{i}) <= 1
        conn_pixel{i} = PixelIdxList{i};
    else
        alldots_i = cell2mat(PixelIdxList{i}');
        breaks = find(diff(alldots_i)>=49);
        
        if isempty(breaks)
            conn_pixel{i}{1} = (min(alldots_i):max(alldots_i))';
        else
        
            for i2 = 1:length(breaks)
                if i2 == 1
                    conn_pixel{i}{i2} = (min(alldots_i(1:breaks(i2))):1:max(alldots_i(1:breaks(i2))))';  
                else
                    conn_pixel{i}{i2} = (alldots_i(breaks(i2-1)+1):alldots_i(breaks(i2)))'; 
                end

                if i2 == length(breaks)
                    conn_pixel{i}{i2+1} = (alldots_i(breaks(i2)+1):alldots_i(end))';
                end
            end
            
        end
    end
end

% get conn_pixel

for i = 1:length(conn_pixel)
    [detlen] = cell2mat(cellfun(@(x) sum(zz{i}(x)),conn_pixel{i},'UniformOutput',0));
    if isempty(detlen)
       Act_idx(i)=NaN;    
    else
       
       [~,mi]=max(detlen);
       if length(conn_pixel{i}{mi}) < 50
           Act_idx(i) = NaN;
       else
           Act_idx(i)= conn_pixel{i}{mi}(1);
       end
    end
end

ActOnset_method2 = (Act_idx -1)/1000;



st_reactionT_here = st_reactionT;
st_reactionT_here(find(isnan(ActOnset_method2))) = [];

ActOnset_method2_here = ActOnset_method2;
ActOnset_method2_here(find(isnan(ActOnset_method2))) = [];


[rho, p] = corr(ActOnset_method2_here',st_reactionT_here) % test the correlation between ActOnset and reaction time




% create variables to be plotted

       % as different contacts timing differs a lot, customize the length
% to be plotted for each contact, but the plan is to cover each
% trial's cue-spoff the best we can   
% because plotting trials require same length of each trial, so here
% we should trim trials to same length
% roi_starts is 1s pre cue, roi_ends may vary with contacts
st_z_smooth = cellfun(@(x) smooth(x',200)',st_z,'UniformOutput',0); % now the period is still 2s precue to 2s post speech off

roi_starts = num2cell((st_epoch.stimulus_starts - st_epoch.starts - 1) * fs)'; % 1s precue 

% default roi_ends is 3s post cue, but if the min length of trials
% is less than 5s, then use the shortest trial length as common
% length
if min(cell2mat(cellfun(@length, st_z_smooth, 'UniformOutput',0))) < 5000 %  
   length_used = floor(min(cell2mat(cellfun(@length, st_z_smooth, 'UniformOutput',0)))/100) * 100;

   roi_ends = num2cell(repmat(length_used,[1 length(st_z_smooth)]));

else
   roi_ends = num2cell((st_epoch.stimulus_starts - st_epoch.starts + 3) * fs)';
end

st_z_crop = cellfun(@(x,y,z) z(x:y), roi_starts, roi_ends, st_z_smooth,'UniformOutput',0);

plot_mat = cell2mat(st_z_crop');

% for i = 1:size(plot_mat,1)
%     smooth_plot_mat(i,:) = smooth(plot_mat(i,:),200);
% end



figure;
tp = linspace(-1,3,length(plot_mat));
imagesc(tp,[1:size(plot_mat,1)],plot_mat); set(gca, 'YDir', 'Normal');

hold on; time_spon =plot(st_reactionT,(1:length(st_reactionT)),'-k');
%hold on; plot(time2max,(1:length(time2max)),'k*','MarkerSize',5);
hold on; plot(ActMax,(1:length(ActMax)),'k*','MarkerSize',3);
hold on; plot(ActOff,(1:length(ActOff)),'b*','MarkerSize',3);
hold on; plot(ActOn,(1:length(ActOn)),'m*','MarkerSize',3);
hold on; plot(ActOnset_method2,(1:length(ActOnset_method2)),'m*','MarkerSize',3);


c = jet; new_cm = c; new_cm(1:5,:)  = []; colormap(new_cm);
caxis([-2,2])
colormap(new_cm);
caxis([-1,1])
  