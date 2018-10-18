% first create 08/03/2018
% renamed on 08/25/2018
% refine on 09/12/2018
% inspect on 09/13/2018
%% follow DW_batch_CAR; takes in step3 data files
% generate a stat table counting contacts activity significance during
% speech. Method: permutation test
% generate speech_response_table.mat under 'datafiles/preprocessed_new/v2/'
% h value: 0 means no significance, 1 means significantly largert than
% baseline, -1 means significantly smaller than baseline
% region of activation chosen: subject to change, 0.5s post spon & 1-1.5
% post cue (result 1) or cue2spoff & 0-3 post cue (result 2) is used now
% This is version2, namely separate sessions if there are multiple sessions
% for a recording sites

%specify machine
DW_machine;

% remove fieldtrip package and spm12 to make sure that we use built-in filtfilt and hilbert 
rmpath(genpath([dropbox 'Functions/Dengyu/git/fieldtrip']));
rmpath(genpath('/Users/Dengyu/Downloads/spm12'));
% make sure filtfilt and hilbert is from matlab toolbox

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
count = 0;
% loop through contacts
for contact_id = 1:length(contact_info)
    
    
    contact_id
    clearvars -except alphaFilt band_selection beta1Filt beta2Filt Choice contact_id  contact_info count...
        deltaFilt dionysis dropbox fs gammaFilt hgammaFilt ref_selection thetaFilt stat_table
    
    if ismember(contact_id,[13:18])  % treat DBS4039 seperately
        count = count + 1;
        stat_table(count,1) = contact_id;
        
        load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(contact_info(contact_id).session) '_subcort_trials_step3.mat']);
        
        % D.trial is 2 (unref and ref) X trial number;
        % D.trial{i} is ch X time
        
        D1 = D;
        D1.trial(:,D1.badtrial_final) = [];
        D1.time(D1.badtrial_final) = [];
        D1.epoch(D1.badtrial_final,:) = [];
        
        i_oi = find(strcmp(contact_info(contact_id).label,D1.label));
        
        D_used = [];
        
        D_used.trial = cellfun(@(x) x(i_oi,:),D1.trial,'UniformOutput',0);
        
        D_used.epoch = D1.epoch;
        
        D_used.time = D1.time;
        
        
        clearvars D D1 i_oi
        
        % get frequency bands signals
        
        clearvars signal
        
        % filtfilt operate along the first  n>1 dimension
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
                
                
                % get post cue 0-3s % select this period to calculate
                % activity
                
                clearvars roi_starts roi_ends data_1 data_z data_val;

                roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                roi_ends = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)) + 3 * fs)';
                
                data_1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);
                
                data_z = cellfun(@(x,y,z) (x-y)./z,data_1,base_mean,base_std,'UniformOutput',0);
                
                data_val = cell2mat(cellfun(@(x) mean(x),data_z,'UniformOutput',0))';
                
                % permutation test
                [p2,~,~] = permTest(data_val,base_val,10000,'sidedness','larger');
                [p3,~,~] = permTest(data_val,base_val,10000,'sidedness','smaller');
                
                
                
                stat_table(count,band_id*4+ref_id*2-4) = min(p2,p3);
                
                % 0 means no significance, 1 means significantly larger
                % than baseline, -1 means significantly smaller than
                % baseline
                if min(p2,p3) > 0.05
                    stat_table(count,band_id*4+ref_id*2-3) = 0;
                elseif p2<p3
                    stat_table(count,band_id*4+ref_id*2-3) = 1;
                else
                    stat_table(count,band_id*4+ref_id*2-3) = -1;
                end
            end
        end        
        stat_table(count,18) = 1;
        
        
        
        
        
    else % ordinary contacts
        if length(contact_info(contact_id).session) == 1 % contacts which have only one session
            count = count + 1;
            stat_table(count,1) = contact_id;
            
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
            
            clearvars D D1 i_oi

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


                    % region chosen: cue2spoff

                    clearvars roi_starts roi_ends data_1 data_z data_val;

                    roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                    roi_ends = num2cell(round(fs*(D_used.epoch.offset_word - D_used.epoch.starts)))';

                    data_1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);

                    data_z = cellfun(@(x,y,z) (x-y)./z,data_1,base_mean,base_std,'UniformOutput',0);

                    data_val = cell2mat(cellfun(@(x) mean(x),data_z,'UniformOutput',0))';

                    % permutation test
                    [p2,~,~] = permTest(data_val,base_val,10000,'sidedness','larger');
                    [p3,~,~] = permTest(data_val,base_val,10000,'sidedness','smaller');

                    stat_table(count,band_id*4+ref_id*2-4) = min(p2,p3);

                    % 0 means no significance, 1 means significantly larger
                    % than baseline, -1 means significantly smaller than
                    % baseline                
                    if min(p2,p3) > 0.05
                        stat_table(count,band_id*4+ref_id*2-3) = 0;
                    elseif p2<p3
                        stat_table(count,band_id*4+ref_id*2-3) = 1;
                    else
                        stat_table(count,band_id*4+ref_id*2-3) = -1;
                    end                

                end
            end
            stat_table(count,18) = 1;
            
        else % contacts which have two sessions
            for session_id = contact_info(contact_id).session
                count = count + 1;
                stat_table(count,1) = contact_id;
                
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' contact_info(contact_id).subject_id '_session' num2str(session_id) '_subcort_trials_step3.mat']);

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
            
        
                clearvars D D1 i_oi

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


                        % region chosen: cue2spoff

                        clearvars roi_starts roi_ends data_1 data_z data_val;

                        roi_starts = num2cell(round(fs*(D_used.epoch.stimulus_starts - D_used.epoch.starts)))';
                        roi_ends = num2cell(round(fs*(D_used.epoch.offset_word - D_used.epoch.starts)))';

                        data_1 = cellfun(@(x,y,z) x(:,y:z),signal{band_id}(ref_id,:),roi_starts,roi_ends,'UniformOutput',0);

                        data_z = cellfun(@(x,y,z) (x-y)./z,data_1,base_mean,base_std,'UniformOutput',0);

                        data_val = cell2mat(cellfun(@(x) mean(x),data_z,'UniformOutput',0))';

                        % permutation test
                        [p2,~,~] = permTest(data_val,base_val,10000,'sidedness','larger');
                        [p3,~,~] = permTest(data_val,base_val,10000,'sidedness','smaller');

                        stat_table(count,band_id*4+ref_id*2-4) = min(p2,p3);

                        % 0 means no significance, 1 means significantly larger
                        % than baseline, -1 means significantly smaller than
                        % baseline                
                        if min(p2,p3) > 0.05
                            stat_table(count,band_id*4+ref_id*2-3) = 0;
                        elseif p2<p3
                            stat_table(count,band_id*4+ref_id*2-3) = 1;
                        else
                            stat_table(count,band_id*4+ref_id*2-3) = -1;
                        end                

                    end
                end
                stat_table(count,18) = session_id;
            end
        end
    end
end


% convert stat_table from matrix to struct

clearvars temp;
for i = 1:size(stat_table,1)
    temp(i).contact_id = stat_table(i,1);
    temp(i).nSessionOfSite = stat_table(i,18);
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
speech_response_table = stat_table;
readme = 'single-sided permutation test, no FDR, Roi is cue2spoff, except for DBS4039 (0-3s post cue onset), session-based';
save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/speech_response_table.mat'],'speech_response_table','readme');