% first created on 09/11/2018
% follows DW_generate_response_table.m and DW_batch_subcort_single_contact_hilb_pertrial.m
% takes in speech_response_table.mat, contact_info_step2.mat

% purpose: generate activation timing table of ref_highgamma for
% significant contacts

% methods: adapted from Ahamd's single_trial_detection

% specify machine
DW_machine;
%%%%%%%%%%%% identify significant contacts of band_oi %%%%%%%%%%%
% read in speech response table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/speech_response_table.mat']);
% extract ref_highgamma's p and h
pvals = extractfield(speech_response_table,'ref_highgamma_p');
hvals = extractfield(speech_response_table,'ref_highgamma_h');
% Bonferroni correction for multiple comparisons
adj_pvals = pvals * length(pvals); 
% get contacts of positive, significant changes
sgnf_contacts = find(hvals == 1 & adj_pvals < 0.05); 

% None of DBS4039's contact is in sgnf_contacts, so no need to worry

% load in contact info table
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);
% sampling frequency
fs = 1000;

%% start the super loop
for contact_id = sgnf_contacts % loop through significant contact
    
    % get dir for possible sessions of this contact
    temp = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_pertrial_band_activity/'...
    'contact_' num2str(contact_id) '_*highgamma_ref.mat']);

    for session_num = 1:length(temp)
        
        clearvars -except contact_info dionysis dropbox sgnf_contacts speech_response_table fs contact_id session_num temp
        
        % load in data: z_oi, epoch_oi, time_oi
        load([temp(session_num).folder filesep temp(session_num).name]);
%%%%%%%%%%%%%%% Step 1: sort trials according to response latency
        % reaction time is defined as interval between cue and speech onset
        reactionT = epoch_oi.onset_word - epoch_oi.stimulus_starts;
        % sort it from small to big
        [st_reactionT, st_order]  = sort(reactionT);
        
        % get sorted z and sorted epoch
        st_z = z_oi(st_order); % each trial is 2s precue to 2s post speech offset
        st_epoch = epoch_oi(st_order,:);
        % get duration between cue and word off under this order   
        st_cue2finish = st_epoch.offset_word - st_epoch.stimulus_starts;
        % always clear futile variables
        clearvars reactionT z_oi epoch_oi;
%%%%%%%%%%%%%%% Step 2: prepare data for ActOn detection

        
        % smooth the "raw" data, although the "raw" data is already
        % normalized once; necessary to smooth because single-trial data is
        % noisy
        st_z_smooth = cellfun(@(x) smooth(x',200)',st_z,'UniformOutput',0);% each trial is 2s precue to 2s post speech offset
        
        %after smoothing, data is diluted, so we need to re-normalize it
        
        %baseline (which is 1s pre-cue)
        Bt = cellfun(@(x) x(1001:2000), st_z_smooth, 'UniformOutput',0);
        
        % normalize to baseline
        zz = cellfun(@(x,y) (x-mean(y))./std(y), st_z_smooth, Bt,'UniformOutput',0);
        
        % extract the period that is used to do detection, which is cue2speechoff
        detect_starts = num2cell(((st_epoch.stimulus_starts - st_epoch.starts) * fs) + 1)';
        detect_ends = num2cell(round((st_epoch.offset_word - st_epoch.starts) * fs))';
        % get detection-using zz: zzDet
        zzDet = cellfun(@(x,y,z) z(x:y), detect_starts, detect_ends, zz,'UniformOutput',0);
        clearvars detect_starts detect_ends;        
%%%%%%%%%%%%%%% Step 3: ActOn and ActOff detection
% method: detect continuous activation period that give the biggest summed power value; continuity tolerate at most 50ms breaks        

        % threshold of activation
        thresh = 1.645;
        % find periods of activation for each trial 
        ActPeriods = cellfun(@(x) bwconncomp(x > thresh),zzDet,'UniformOutput',0);
        PixelIdxList = cellfun(@(x) x.PixelIdxList,ActPeriods,'UniformOutput',0);
        
        % starts the concatenate algorithm:
        clearvars conn_pixel mi ActOn_idx ActOff_idx
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
        % This gives conn_pixel

        % find the maximal summed activity period for each trial
        for i = 1:length(conn_pixel)
            [detlen] = cell2mat(cellfun(@(x) sum(zzDet{i}(x)),conn_pixel{i},'UniformOutput',0));
            if isempty(detlen)
               ActOn_idx(i)=NaN;
               ActOff_idx(i)=NaN;
               mi(i) = NaN;
            else
               [~,mi(i)]=max(detlen);
                ActOn_idx(i)= conn_pixel{i}{mi(i)}(1);
                ActOff_idx(i) = conn_pixel{i}{mi(i)}(end);
            end
        end
        
        % Get array of activation onset and offset time, relative to cue onset
        ActOn = (ActOn_idx - 1)/1000;
        ActOff = ActOff_idx/1000;    
%%%%%%%%%%%%%%% Step 4: ActMax detection
% method: similar to method 1 in DW_SingleTrialDetectionTrial.m
        clearvars ActMax bins
        for i = 1:length(conn_pixel)
            if isnan(mi(i))
                ActMax(i) = NaN;
            elseif length(conn_pixel{i}{mi(i)}) <=25
                ActMax(i) = ActOn(i) + length(conn_pixel{i}{mi(i)})/2000;
                
            else
                bin_num = length(conn_pixel{i}{mi(i)}) - 24;
                
                clearvars bins
                for bin_idx = 1:bin_num
                    bins{bin_idx} = zzDet{i}(conn_pixel{i}{mi(i)}(1) + bin_idx - 1:conn_pixel{i}{mi(i)}(1) + bin_idx+23);
                end
                
                mean_bins = cellfun(@(x) mean(x),bins);
               [~, max_bin_idx] = max(mean_bins,[],2);
                ActMax(i) = max_bin_idx/1000 - 0.001 + 0.0125 + ActOn(i);
            end
        end
        
        % brief correlation
        st_reactionT_here = st_reactionT; st_reactionT_here(find(isnan(ActOn))) = [];
        ActOn_here = ActOn; ActOn_here(find(isnan(ActOn))) = [];
        ActOff_here = ActOff; ActOff_here(find(isnan(ActOff))) = [];
        ActMax_here = ActMax; ActMax_here(find(isnan(ActMax))) = [];
        
       [rho1, p1] = corr(ActOn_here',st_reactionT_here) % test the correlation between ActOn and reaction time
       [rho2, p2] = corr(ActOff_here',st_reactionT_here) % test the correlation between ActOff and reaction time
       [rho3, p3] = corr(ActMax_here',st_reactionT_here) % test the correlation between ActMax and reaction time
%%%%%%%%%%%%%%% Step 5: Store the result for each contact (each session if multiple)
        TrialOrder = st_order;
        ReactionT = st_reactionT;
        Cue2Finish = st_cue2finish;
        ActOn = ActOn';
        ActMax = ActMax';
        ActOff = ActOff';
        ephy_timing = table(TrialOrder, ReactionT, Cue2Finish, ActOn,ActMax, ActOff);
        
        rhos = [rho1; rho2; rho3]; ps = [p1; p2; p3];
        
        stats.rhos = rhos;
        stats.ps = ps;
        
        readme = 'TrialOrder refers to the original order in z_oi; stats are simple corr results; order: on, max, off';
        
        if length(temp) == 1
            save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/TimingAnalysis2/'...
                'contact_' num2str(contact_id) '_highgamma_ref'],'ephy_timing', 'stats', 'readme', '-v7.3');
        else
            save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/TimingAnalysis2/'...
                'contact_' num2str(contact_id) '_session' num2str(session_num) '_highgamma_ref'],'ephy_timing', 'stats', 'readme', '-v7.3');
        end
    end
end 