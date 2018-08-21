% first create 08/03/2018
%% follow DW_batch_CAR; takes in step3 data files
% generate a stat table counting contacts activity significance during
% speech. Method: permutation test
% generate stat_table.mat under 'datafiles/preprocessed_new/v2/'
% h value: 0 means no significance, 1 means significantly largert than
% baseline, -1 means significantly smaller than baseline

%specify machine
DW_machine;

% remove fieldtrip package to make sure that we use built-in filtfilt and hilbert 
rmpath(genpath([dropbox 'Functions/Dengyu/git/fieldtrip']));



% data sampling frequency
fs = 1000;

%filter load
load([dropbox,'Functions/Dengyu/Filter/bpFilt.mat']);

% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% band selection and ref selection
band_selection = {'alpha','lowbeta','highbeta','highgamma'};

ref_selection = {'unref','ref'};


stat_table = []; % initiation
% loop through contacts
for contact_id = 1:length(contact_info)
    stat_table(contact_id,1) = contact_id;
    
    contact_id
    clearvars -except alphaFilt band_selection beta1Filt beta2Filt Choice contact_id  contact_info ...
        deltaFilt dionysis dropbox fs gammaFilt hgammaFilt ref_selection thetaFilt stat_table;
    
    if ismember(contact_id,[13:18])  % treat DBS4039 seperately
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session) '_subcort_trials_step3.mat']);
        
        D1 = D;
        D1.trial(:,D1.badtrial_final) = [];
        D1.time(D1.badtrial_final) = [];
        D1.epoch(D1.badtrial_final,:) = [];
        
        i_oi = find(strcmp(contact_info(contact_id).label,D1.label));
        
        D_used = [];
        
        D_used.trial = cellfun(@(x) x(i_oi,:),D1.trial,'UniformOutput',0);
        
        D_used.epoch = D1.epoch;
        
        D_used.time = D1.time;
        
        
        clearvars D D1 D2 i1_oi i2_oi
        
        % get frequency bands signals
        
        clearvars signal
        
        signal{1} = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x')))',D_used.trial,'UniformOutput',0);
        signal{2} = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x')))',D_used.trial,'UniformOutput',0);
        signal{3} = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x')))',D_used.trial,'UniformOutput',0);
        signal{4} = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x')))',D_used.trial,'UniformOutput',0);
        

        
        % loop through bands
        
        for band_id = 1:4
            band_name = band_selection{band_id};
            
            % loop through ref and unref
            for ref_id = 1:2
                
                ref_name = ref_selection{ref_id};
                
                % so data oi is signal{band_id}(ref_id,:)
                
                % get baseline, which is define as 1s precue
                clearvars roi_starts roi_ends base1 base_mean base_std base_z base_val;
                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                
                base1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                base_mean = cellfun(@(x) mean(x),base1,'UniformOutput',0);
                
                base_std = cellfun(@(x) std(x),base1,'UniformOutput',0);
                
                base_z = cellfun(@(x,y,z) (x-y)./z,base1,base_mean,base_std,'UniformOutput',0);
                
                base_val = cell2mat(cellfun(@(x) mean(x),base_z,'UniformOutput',0))';
                
                
                % get post cue 1-1.5s % select this period to calculate
                % activity
                
                clearvars roi_starts roi_ends data_1 data_z data_val;

                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) + 1 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) + 1.5 * fs)';
                
                data_1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                data_z = cellfun(@(x,y,z) (x-y)./z,data_1,base_mean,base_std,'UniformOutput',0);
                
                data_val = cell2mat(cellfun(@(x) mean(x),data_z,'UniformOutput',0))';
                
                % permutation test
                [p2,~,~] = permTest(data_val,base_val,10000,'sidedness','larger');
                [p3,~,~] = permTest(data_val,base_val,10000,'sidedness','smaller');
                
                
                
                stat_table(contact_id,band_id*4+ref_id*2-4) = min(p2,p3);
                
                % 0 means no significance, 1 means significantly larger
                % than baseline, -1 means significantly smaller than
                % baseline
                if min(p2,p3) > 0.05
                    stat_table(contact_id,band_id*4+ref_id*2-3) = 0;
                elseif p2<p3
                    stat_table(contact_id,band_id*4+ref_id*2-3) = 1;
                else
                    stat_table(contact_id,band_id*4+ref_id*2-3) = -1;
                end
            end
        end        
        
        
        
        
        
        
    else % ordinary contacts
        if length(contact_info(contact_id).session) == 1 % contacts which have only one session
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session) '_subcort_trials_step3.mat']);
            
            % 1st: remove bad trials
            D1 = D;
            D1.trial(:,D1.badtrial_final) = [];
            D1.time(D1.badtrial_final) = [];
            D1.epoch(D1.badtrial_final,:) = [];
            
            % 2nd: find contact oi
            i_oi = find(strcmp(contact_info(contact_id).label,D1.label));
            
            % 3rd: extract data of contact oi and get D_used
            D_used = [];
            
            D_used.trial = cellfun(@(x) x(i_oi,:),D1.trial,'UniformOutput',0);
            
            D_used.epoch = D1.epoch;
            D_used.time = D1.time;
            
        else % contacts which have two sessions
            
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session(1)) '_subcort_trials_step3.mat']);
            D1 = D;
            
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session(2)) '_subcort_trials_step3.mat']);
            D2 = D;
            
            % 1st: remove bad trials
            
            D1.trial(:,D1.badtrial_final) = [];
            D1.time(D1.badtrial_final) = [];
            D1.epoch(D1.badtrial_final,:) = [];            
            
            D2.trial(:,D2.badtrial_final) = [];
            D2.time(D2.badtrial_final) = [];
            D2.epoch(D2.badtrial_final,:) = [];    
            
            % 2nd: find contact oi
            
            i1_oi = find(strcmp(contact_info(contact_id).label,D1.label));

            i2_oi = find(strcmp(contact_info(contact_id).label,D2.label));
            
            % 3rd: extract data of contact oi and get D_used
            D_used = [];
            
            D_used.trial = [cellfun(@(x) x(i1_oi,:),D1.trial,'UniformOutput',0),cellfun(@(x) x(i2_oi,:),D2.trial,'UniformOutput',0)];
            
            D_used.epoch = [D1.epoch;D2.epoch];
            
            D_used.time = [D1.time, D2.time];
        end % D_used got
        
        clearvars D D1 D2 i1_oi i2_oi
        
        % get frequency bands signals
        
        clearvars signal
        
        signal{1} = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x')))',D_used.trial,'UniformOutput',0);
        signal{2} = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x')))',D_used.trial,'UniformOutput',0);
        signal{3} = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x')))',D_used.trial,'UniformOutput',0);
        signal{4} = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x')))',D_used.trial,'UniformOutput',0);
        

        
        % loop through bands
        
        for band_id = 1:4
            band_name = band_selection{band_id};
            
            % loop through ref and unref
            for ref_id = 1:2
                
                ref_name = ref_selection{ref_id};
                
                % so data oi is signal{band_id}(ref_id,:)
                
                % get baseline, which is define as 1s precue
                clearvars roi_starts roi_ends base1 base_mean base_std base_z base_val;
                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) - 1 * fs)';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                
                base1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                base_mean = cellfun(@(x) mean(x),base1,'UniformOutput',0);
                
                base_std = cellfun(@(x) std(x),base1,'UniformOutput',0);
                
                base_z = cellfun(@(x,y,z) (x-y)./z,base1,base_mean,base_std,'UniformOutput',0);
                
                base_val = cell2mat(cellfun(@(x) mean(x),base_z,'UniformOutput',0))';                
                
                
                % sp centered, 0.5s post spon
                
                clearvars roi_starts roi_ends data_1 data_z data_val;

                roi_starts = num2cell(round(fs*(D_used.epoch.onset_word - D_used.epoch.starts)))';
                roi_ends = num2cell(round(fs*(D_used.epoch.onset_word - D_used.epoch.starts)) + 0.5*fs)';
                
                data_1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                data_z = cellfun(@(x,y,z) (x-y)./z,data_1,base_mean,base_std,'UniformOutput',0);
                
                data_val = cell2mat(cellfun(@(x) mean(x),data_z,'UniformOutput',0))';
                
                % permutation test
                [p2,~,~] = permTest(data_val,base_val,10000,'sidedness','larger');
                [p3,~,~] = permTest(data_val,base_val,10000,'sidedness','smaller');

                stat_table(contact_id,band_id*4+ref_id*2-4) = min(p2,p3);
                
                % 0 means no significance, 1 means significantly larger
                % than baseline, -1 means significantly smaller than
                % baseline                
                if min(p2,p3) > 0.05
                    stat_table(contact_id,band_id*4+ref_id*2-3) = 0;
                elseif p2<p3
                    stat_table(contact_id,band_id*4+ref_id*2-3) = 1;
                else
                    stat_table(contact_id,band_id*4+ref_id*2-3) = -1;
                end                
                
            end
        end
    end
end


% convert stat_table from matrix to struct

clearvars temp;
for i = 1:size(stat_table,1)
    temp(i).contact_id = stat_table(i,1);
    temp(i).unref_alpha_p = stat_table(i,2);
    temp(i).unref_alpha_h = stat_table(i,3);
    temp(i).ref_alpha_p = stat_table(i,4);
    temp(i).ref_alpha_h = stat_table(i,5);
    temp(i).unref_lowbeta_p = stat_table(i,6);
    temp(i).unref_lowbeta_h = stat_table(i,7);
    temp(i).ref_lowbeta_p = stat_table(i,8);
    temp(i).ref_lowbeta_h = stat_table(i,9);
    temp(i).unref_highbeta_p = stat_table(i,10);
    temp(i).unref_highbeta_h = stat_table(i,11);
    temp(i).ref_highbeta_p = stat_table(i,12);
    temp(i).ref_highbeta_h = stat_table(i,13);
    temp(i).unref_highgamma_p = stat_table(i,14);
    temp(i).unref_highgamma_h = stat_table(i,15);
    temp(i).ref_highgamma_p = stat_table(i,16);
    temp(i).ref_highgamma_h = stat_table(i,17);
end

stat_table = temp;
readme = 'single-sided permutation test, no FDR, Roi is 0.5s post spon, except for DBS4039 (1-1.5s post cue onset)';
save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/stat_table.mat'],'stat_table','readme');