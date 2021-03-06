% first created on 09/11/2018
% inspect on 09/13/2018
% edit on 09/14/2018: add ref_lowbeta and do a loop through ref_lowbeta and ref_highgamma

% follows DW_generate_response_table_v2.m and DW_batch_subcort_single_contact_hilb_pertrial.m
% takes in speech_response_table.mat, contact_info_step2.mat

% purpose: generate activation timing table of ref_highgamma and ref_lowbeta for
% significant contacts (per session base)

% methods: adapted from Ahamd's single_trial_detection, edition 1

% specify machine
DW_machine;
%%%%%%%%%%%% identify significant contacts of band_oi %%%%%%%%%%%
% read in speech response table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/speech_response_table.mat']);

% exclude 13:18, i.e.  contacts without speech timing data (DBS4039)
speech_response_table = struct2table(speech_response_table);
speech_response_table(find (ismember(speech_response_table.contact_id,13:18)),:) = [];

% load in contact info table
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);
% sampling frequency
fs = 1000;

band_selection = {'ref_lowbeta', 'ref_highgamma'};
h_selection = {-1,1};

% start the outer loop of band selection
for band_id  = 1:2
    clearvars -except band_id band_selection contact_info dionysis dropbox fs h_selection speech_response_table;
    
    band_name = band_selection{band_id};
    
    % find the columns of p and h of band_oi in speech_response_table
    
    p_idx = find(strcmp([band_name '_p'], speech_response_table.Properties.VariableNames));
    h_idx = find(strcmp([band_name '_h'], speech_response_table.Properties.VariableNames));

    % extract band_oi's p and h
    pvals = speech_response_table{:,p_idx};
    hvals = speech_response_table{:,h_idx};
    % Bonferroni correction for multiple comparisons
    adj_pvals = pvals * length(pvals); 
    % get contacts of significant changes of the right direction
    sgnf_ids = find(hvals == h_selection{band_id} & adj_pvals < 0.05);
    % table of ref_highgamma sig act contacts and sessions
    sgnf_table = speech_response_table(sgnf_ids,:);
    
    % initialize SumTimingTable
    SumTimingTable = table();
    SumTimingTable.contact_id = sgnf_table.contact_id;
    SumTimingTable.nSessionOfSite = sgnf_table.nSessionOfSite;
    
    %% start the super loop
    for i_order = 1:height(sgnf_table) % loop through significant contacts and sessions

        clearvars -except band_id band_name band_selection contact_info dionysis dropbox ...
            fs h_selection i_order sgnf_table speech_response_table SumTimingTable;

        contact_id = sgnf_table.contact_id(i_order);

        % get dir for possible sessions of this contact
        temp = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_pertrial_band_activity/'...
        'contact_' num2str(contact_id) '_*' band_name(5:end) '_ref.mat']);

        % load in data: z_oi, epoch_oi, time_oi    
        if length(temp) == 1
            load([temp.folder filesep temp.name]);
        else
            load([temp(sgnf_table.nSessionOfSite(i_order)).folder filesep temp(sgnf_table.nSessionOfSite(i_order)).name]);
        end


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
        clearvars reactionT z_oi epoch_oi time_oi;
    %%%%%%%%%%%%%%% Step 2: prepare data for ActOn detection


        % smooth the "raw" data, although the "raw" data is already
        % normalized once; necessary to smooth because single-trial data is
        % noisy

        % st_z is 1 X trial number
        % check it make sure smooth is from matlab toolbox
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
    % method: detect continuous activation period that give the biggest/lowest summed power value; continuity tolerate at most 50ms breaks        

        % threshold of activation
        thresh = h_selection{band_id} * 1.645;
        % find periods of activation for each trial

        % zzDet is 1 X trial number
        % make sure the bwconncomp function is from matlab toolbox
        % find the continuously activated period for each trial
        switch band_id
            case 1 % lowbeta
                ActPeriods = cellfun(@(x) bwconncomp(x < thresh),zzDet,'UniformOutput',0);
            case 2 % highgamma
                ActPeriods = cellfun(@(x) bwconncomp(x > thresh),zzDet,'UniformOutput',0);
        end
        
        PixelIdxList = cellfun(@(x) x.PixelIdxList,ActPeriods,'UniformOutput',0);

        clearvars conn_pixel mi ActOn_idx ActOff_idx
        
        conn_pixel = PixelIdxList; % This gives conn_pixel
        
        
        % The following is a little differ between hg and lb, becase one
        % for positive maximal one for negative maximal
        
        if band_id == 1 % lowbeta
            % find the minimal summed activity period for each trial
            for i = 1:length(conn_pixel)
                [detlen] = cell2mat(cellfun(@(x) sum(zzDet{i}(x)),conn_pixel{i},'UniformOutput',0));
                if isempty(detlen)
                   ActOn_idx(i)=NaN;
                   ActOff_idx(i)=NaN;
                   mi(i) = NaN;
                else
                   [~,mi(i)]=min(detlen);
                    ActOn_idx(i)= conn_pixel{i}{mi(i)}(1);
                    ActOff_idx(i) = conn_pixel{i}{mi(i)}(end);
                end
            end

            % Get array of activation onset and offset time, relative to cue onset
            ActOn = (ActOn_idx - 1)/1000;
            ActOff = ActOff_idx/1000;    
%%%%%%%%%%%%%%%%%%%%%%%%%% Step 4: ActMax detection
%%%%%%%%%%%%%%% method: similar to method 1 in DW_SingleTrialDetectionTrial.m
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
                   [~, max_bin_idx] = min(mean_bins,[],2);
                    ActMax(i) = max_bin_idx/1000 - 0.001 + 0.0125 + ActOn(i);
                end
            end
        elseif band_id ==2 % highgamma
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
%%%%%%%%%%%%%%%%%%%%%%%%%% Step 4: ActMax detection
%%%%%%%%%%%%%%% method: similar to method 1 in DW_SingleTrialDetectionTrial.m
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
        end

        ActOn = ActOn'; ActMax = ActMax'; ActOff = ActOff'; % turn to column vector


        % brief correlation
        st_reactionT_here = st_reactionT; st_reactionT_here(find(isnan(ActOn))) = [];
        ActOn_here = ActOn; ActOn_here(find(isnan(ActOn))) = [];
        ActOn2P_here = st_reactionT - ActOn; ActOn2P_here(find(isnan(ActOn))) = [];  
        ActMax_here = ActMax; ActMax_here(find(isnan(ActMax))) = [];
        ActMax2P_here = st_reactionT - ActMax; ActMax2P_here(find(isnan(ActMax))) = [];
        ActOff_here = ActOff; ActOff_here(find(isnan(ActOff))) = [];
        ActOff2P_here = st_reactionT - ActOff; ActOff2P_here(find(isnan(ActOff))) = [];      

       [rho1, p1] = corr(ActOn_here, st_reactionT_here) % test the correlation between ActOn and reaction time
       [rho2, p2] = corr(ActOn2P_here, st_reactionT_here) % test the correlation between ActOn2P and reaction time

       [rho3, p3] = corr(ActMax_here, st_reactionT_here) % test the correlation between ActMax and reaction time
       [rho4, p4] = corr(ActMax2P_here, st_reactionT_here) % test the correlation between ActMax2P and reaction time    

       [rho5, p5] = corr(ActOff_here, st_reactionT_here) % test the correlation between ActOff and reaction time
       [rho6, p6] = corr(ActOff2P_here, st_reactionT_here) % test the correlation between ActOff2P and reaction time

    %%%%%%%%%%%%%%% Step 5: Store the result for each contact (each session if multiple)
        TrialOrder = st_order;
        ReactionT = st_reactionT;
        Cue2Finish = st_cue2finish;
        ActOn = ActOn;
        ActMax = ActMax;
        ActOff = ActOff;
        ephy_timing = table(TrialOrder, ReactionT, Cue2Finish, ActOn,ActMax, ActOff);

        rhos = [rho1; rho2; rho3; rho4; rho5; rho6]; ps = [p1; p2; p3; p4; p5; p6];

        stats.rhos = rhos;
        stats.ps = ps;

        readme = 'TrialOrder refers to the original order in z_oi; stats are simple corr results; order: on, on2P, max, max2P, off, off2P';

        if length(temp) == 1
            save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/TimingAnalysis12/ContactsLatency/'...
                'contact_' num2str(contact_id) '_' band_name(5:end) '_ref'],'ephy_timing', 'stats', 'readme', '-v7.3');
        else
            save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/TimingAnalysis12/ContactsLatency/'...
                'contact_' num2str(contact_id) '_session' num2str(sgnf_table.nSessionOfSite(i_order)) '_' band_name(5:end) '_ref'],'ephy_timing', 'stats', 'readme', '-v7.3');
        end

        SumTimingTable.ActOn(i_order) = nanmean(ActOn);
        SumTimingTable.ActOn2P(i_order) = nanmean((ReactionT - ActOn));    
        SumTimingTable.ActOnCorrRho(i_order) = rho1;
        SumTimingTable.ActOnCorrP(i_order) = p1;
        SumTimingTable.ActOn2PCorrRho(i_order) = rho2;
        SumTimingTable.ActOn2PCorrP(i_order) = p2;

        SumTimingTable.ActMax(i_order) = nanmean(ActMax);
        SumTimingTable.ActMax2P(i_order) = nanmean((ReactionT - ActMax));    
        SumTimingTable.ActMaxCorrRho(i_order) = rho3;
        SumTimingTable.ActMaxCorrP(i_order) = p3;
        SumTimingTable.ActMax2PCorrRho(i_order) = rho4;
        SumTimingTable.ActMax2PCorrP(i_order) = p4;

        SumTimingTable.ActOff(i_order) = nanmean(ActOff);
        SumTimingTable.ActOff2P(i_order) = nanmean((ReactionT - ActOff));
        SumTimingTable.ActOffCorrRho(i_order) = rho5;
        SumTimingTable.ActOffCorrP(i_order) = p5;
        SumTimingTable.ActOff2PCorrRho(i_order) = rho6;
        SumTimingTable.ActOff2PCorrP(i_order) = p6;

        SumTimingTable.ActDur(i_order) = nanmean(ActOff - ActOn);  
    end

    readme = ['Mean timing data for all ' band_name '-significant contacts sessions; X2P = P - X'];

    save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/TimingAnalysis12/'...
    'SumTimingTable_' band_name(5:end) '_ref'],'SumTimingTable', 'readme', '-v7.3');
end