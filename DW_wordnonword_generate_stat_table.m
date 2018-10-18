% first created on 09/29
% modified on 10/04/2018: add beta band
% This script is used to create statistical table of word vs. nonword
% comparison, containing each contact, each band and 3 time period

% We are intereset in 3 time periods: -0.5 - 0.5s peri-sp, 0.5s, post-sp and 0.5 pre-sp
% For DBS4039, we are interested in 3 periods: 0.5 - 1.5s post-cue, 1 - 1.5s post-cue and 0.5 - 1s post-cue
% For contact with 2 sessions, calculate each session separately and then
% combinely calculate (so there will be 3 rows for such contact)

% uses contact_info_step2.mat and files under 'VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/'
% generate stat_table.mat under 'VIM/datafiles/preprocessed_new/v2/WordVsNonword/'

% specify machine
DW_machine;

% load in contact_info
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% band selection
band_selection = {'delta', 'theta', 'alpha','lowbeta','highbeta','beta', 'gamma', 'highgamma'};

fs = 1000;

stat_table = table();
counter = 0;

% loop through contacts
for contact_id = 1:length(contact_info)
    clearvars -except band_selection contact_id contact_info counter dionysis dropbox fs stat_table
    
    if ~ismember(contact_id,[13:18]) % treat DBS4039 seperately
    
        if length(contact_info(contact_id).session) == 1 % contact having only 1 session
            counter = counter + 1;
            stat_table.contact_id(counter) = contact_id;
            stat_table.ith_session{counter} = 1; % has only one session

            % loop through bands
            for band_id = 1:length(band_selection)
                
                band_name = band_selection{band_id};
        
                % load in data_oi
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/' ...
                    'contact_' num2str(contact_id) '_' band_name '_ref.mat']);
                
                % deal with z_oi
                
                presp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs - 500))';
                sp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs))';
                postsp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs + 500))'; % convert to cell in order to call cellfun
                
                % We are interested in 3 periods: -0.5 - 0.5s peri-sp, 0.5s
                % post-sp and 0.5 pre-sp
                
                % Get one average value for each period and each trial
                
                p1_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,sp_idx,'UniformOutput',0))';
                p2_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,sp_idx,postsp_idx,'UniformOutput',0))';
                p3_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,postsp_idx,'UniformOutput',0))';
                
                
                % tear apart word and nonword trials, in the first 60 trials!
                
                % tip: even trial id is word, odd trial id is nonword
                
                nonword_idx = find(mod(epoch_oi.trial_id,2) & epoch_oi.trial_id <= 60); % 1 means odd, 0 means even
                word_idx = find((~mod(epoch_oi.trial_id,2)) & epoch_oi.trial_id <=60);
                
                p1_nonword = p1_val(nonword_idx); p1_word = p1_val(word_idx);
                p2_nonword = p2_val(nonword_idx); p2_word = p2_val(word_idx);
                p3_nonword = p3_val(nonword_idx); p3_word = p3_val(word_idx);
                
                % stat starts here; permutation test
                
                [p2,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'smaller');
                
                stat_table{counter,band_id * 6 - 3} = min(p2,p3);
                
                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6 - 2} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6 - 2} = 1;
                else
                    stat_table{counter,band_id * 6 - 2} = -1;
                end                

                [p2,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'smaller');
                
                stat_table{counter,band_id * 6 - 1} = min(p2,p3);
                
                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6} = 1;
                else
                    stat_table{counter,band_id * 6} = -1;
                end                
                
                [p2,~,~]= permTest(p3_word,p3_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p3_word,p3_nonword,10000,'sidedness', 'smaller');
                
                stat_table{counter,band_id * 6 + 1} = min(p2,p3);
                
                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6 + 2} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6 + 2} = 1;
                else
                    stat_table{counter,band_id * 6 + 2} = -1;
                end
            end
            
        else % contacts with 2 sessions
            
            % session 1
            counter = counter + 1;
            stat_table.contact_id(counter) = contact_id;
            stat_table.ith_session{counter} = 1; 

            
            % loop through bands
            for band_id = 1:length(band_selection)

                band_name = band_selection{band_id};

                % load in data_oi
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/' ...
                    'contact_' num2str(contact_id) '_session1_' band_name '_ref.mat']);

                % deal with z_oi

                presp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs - 500))';
                sp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs))';
                postsp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs + 500))'; % convert to cell in order to call cellfun

                % We are interested in 3 periods: -0.5 - 0.5s peri-sp, 0.5s
                % post-sp and 0.5 pre-sp

                % Get one average value for each period and each trial

                p1_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,sp_idx,'UniformOutput',0))';
                p2_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,sp_idx,postsp_idx,'UniformOutput',0))';
                p3_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,postsp_idx,'UniformOutput',0))';


                % tear apart word and nonword trials, in the first 60 trials!

                % tip: even trial id is word, odd trial id is nonword

                nonword_idx = find(mod(epoch_oi.trial_id,2) & epoch_oi.trial_id <= 60); % 1 means odd, 0 means even
                word_idx = find((~mod(epoch_oi.trial_id,2)) & epoch_oi.trial_id <=60);

                p1_nonword = p1_val(nonword_idx); p1_word = p1_val(word_idx);
                p2_nonword = p2_val(nonword_idx); p2_word = p2_val(word_idx);
                p3_nonword = p3_val(nonword_idx); p3_word = p3_val(word_idx);

                [p2,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 - 3} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6 - 2} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6 - 2} = 1;
                else
                    stat_table{counter,band_id * 6 - 2} = -1;
                end                

                [p2,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 - 1} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6} = 1;
                else
                    stat_table{counter,band_id * 6} = -1;
                end                

                [p2,~,~]= permTest(p3_word,p3_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p3_word,p3_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 + 1} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6 + 2} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6 + 2} = 1;
                else
                    stat_table{counter,band_id * 6 + 2} = -1;
                end
            end
            
            % session 2
            counter = counter + 1;
            stat_table.contact_id(counter) = contact_id;
            stat_table.ith_session{counter} = 2;

            % loop through bands
            for band_id = 1:length(band_selection)

                band_name = band_selection{band_id};

                % load in data_oi
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/' ...
                    'contact_' num2str(contact_id) '_session2_' band_name '_ref.mat']);

                % deal with z_oi

                presp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs - 500))';
                sp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs))';
                postsp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs + 500))'; % convert to cell in order to call cellfun

                % We are interested in 3 periods: -0.5 - 0.5s peri-sp, 0.5s
                % post-sp and 0.5 pre-sp

                % Get one average value for each period and each trial

                p1_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,sp_idx,'UniformOutput',0))';
                p2_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,sp_idx,postsp_idx,'UniformOutput',0))';
                p3_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,postsp_idx,'UniformOutput',0))';


                % tear apart word and nonword trials, in the first 60 trials!

                % tip: even trial id is word, odd trial id is nonword

                nonword_idx = find(mod(epoch_oi.trial_id,2) & epoch_oi.trial_id <= 60); % 1 means odd, 0 means even
                word_idx = find((~mod(epoch_oi.trial_id,2)) & epoch_oi.trial_id <=60);

                p1_nonword = p1_val(nonword_idx); p1_word = p1_val(word_idx);
                p2_nonword = p2_val(nonword_idx); p2_word = p2_val(word_idx);
                p3_nonword = p3_val(nonword_idx); p3_word = p3_val(word_idx);

                [p2,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 - 3} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6 - 2} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6 - 2} = 1;
                else
                    stat_table{counter,band_id * 6 - 2} = -1;
                end                

                [p2,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 - 1} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6} = 1;
                else
                    stat_table{counter,band_id * 6} = -1;
                end                

                [p2,~,~]= permTest(p3_word,p3_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p3_word,p3_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 + 1} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6 + 2} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6 + 2} = 1;
                else
                    stat_table{counter,band_id * 6 + 2} = -1;
                end
            end 
            
            % session 1 and 2 combined
            counter = counter + 1;
            stat_table.contact_id(counter) = contact_id;
            stat_table.ith_session{counter} = [1,2];

            % loop through bands
            for band_id = 1:length(band_selection)

                band_name = band_selection{band_id};

                % load in session 1 first
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/' ...
                    'contact_' num2str(contact_id) '_session1_' band_name '_ref.mat']);
                
                z_oi1 = z_oi; epoch_oi1 = epoch_oi;
                
                % then load in session 2
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/' ...
                    'contact_' num2str(contact_id) '_session2_' band_name '_ref.mat']);
                z_oi2 = z_oi; epoch_oi2 = epoch_oi;
                
                epoch_oi = vertcat(epoch_oi1,epoch_oi2);
                z_oi = [z_oi1,z_oi2];
                

                % deal with z_oi

                presp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs - 500))';
                sp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs))';
                postsp_idx = num2cell(round((epoch_oi.onset_word - epoch_oi.starts) * fs + 500))'; % convert to cell in order to call cellfun

                % We are interested in 3 periods: -0.5 - 0.5s peri-sp, 0.5s
                % post-sp and 0.5 pre-sp

                % Get one average value for each period and each trial

                p1_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,sp_idx,'UniformOutput',0))';
                p2_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,sp_idx,postsp_idx,'UniformOutput',0))';
                p3_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,postsp_idx,'UniformOutput',0))';


                % tear apart word and nonword trials, in the first 60 trials!

                % tip: even trial id is word, odd trial id is nonword

                nonword_idx = find(mod(epoch_oi.trial_id,2) & epoch_oi.trial_id <= 60); % 1 means odd, 0 means even
                word_idx = find((~mod(epoch_oi.trial_id,2)) & epoch_oi.trial_id <=60);

                p1_nonword = p1_val(nonword_idx); p1_word = p1_val(word_idx);
                p2_nonword = p2_val(nonword_idx); p2_word = p2_val(word_idx);
                p3_nonword = p3_val(nonword_idx); p3_word = p3_val(word_idx);

                [p2,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 - 3} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6 - 2} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6 - 2} = 1;
                else
                    stat_table{counter,band_id * 6 - 2} = -1;
                end                

                [p2,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 - 1} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6} = 1;
                else
                    stat_table{counter,band_id * 6} = -1;
                end                

                [p2,~,~]= permTest(p3_word,p3_nonword,10000,'sidedness', 'larger');
                [p3,~,~] = permTest(p3_word,p3_nonword,10000,'sidedness', 'smaller');

                stat_table{counter,band_id * 6 + 1} = min(p2,p3);

                if min(p2,p3) > 0.05
                    stat_table{counter,band_id * 6 + 2} = 0;
                elseif p2<p3
                    stat_table{counter,band_id * 6 + 2} = 1;
                else
                    stat_table{counter,band_id * 6 + 2} = -1;
                end
            end            
            

            
        end
    else
        counter = counter + 1;
        stat_table.contact_id(counter) = contact_id;
        stat_table.ith_session{counter} = 1; % has only one session    
        
        % loop through bands
        for band_id = 1:length(band_selection)

            band_name = band_selection{band_id};

            % load in data_oi
            load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_pertrial_band_activity/' ...
                'contact_' num2str(contact_id) '_' band_name '_ref.mat']);

            % deal with z_oi

            presp_idx = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs + 500))';
            sp_idx = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs + 1000))';
            postsp_idx = num2cell(round((epoch_oi.stimulus_starts - epoch_oi.starts) * fs + 1500))'; % convert to cell in order to call cellfun

            % For DBS4039, we are interested in 3 periods: 0.5 - 1.5s post-cue, 1 - 1.5s
            % post-cue and 0.5 - 1s post-cue

            % Get one average value for each period and each trial

            p1_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,sp_idx,'UniformOutput',0))';
            p2_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,sp_idx,postsp_idx,'UniformOutput',0))';
            p3_val = cell2mat(cellfun(@(x, y, z) mean(x(y+1:z)),z_oi,presp_idx,postsp_idx,'UniformOutput',0))';


            % tear apart word and nonword trials, in the first 60 trials!

            % tip: even trial id is word, odd trial id is nonword

            nonword_idx = find(mod(epoch_oi.trial_id,2) & epoch_oi.trial_id <= 60); % 1 means odd, 0 means even
            word_idx = find((~mod(epoch_oi.trial_id,2)) & epoch_oi.trial_id <=60);

            p1_nonword = p1_val(nonword_idx); p1_word = p1_val(word_idx);
            p2_nonword = p2_val(nonword_idx); p2_word = p2_val(word_idx);
            p3_nonword = p3_val(nonword_idx); p3_word = p3_val(word_idx);

            [p2,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'larger');
            [p3,~,~] = permTest(p1_word,p1_nonword,10000,'sidedness', 'smaller');

            stat_table{counter,band_id * 6 - 3} = min(p2,p3);

            if min(p2,p3) > 0.05
                stat_table{counter,band_id * 6 - 2} = 0;
            elseif p2<p3
                stat_table{counter,band_id * 6 - 2} = 1;
            else
                stat_table{counter,band_id * 6 - 2} = -1;
            end                

            [p2,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'larger');
            [p3,~,~] = permTest(p2_word,p2_nonword,10000,'sidedness', 'smaller');

            stat_table{counter,band_id * 6 - 1} = min(p2,p3);

            if min(p2,p3) > 0.05
                stat_table{counter,band_id * 6} = 0;
            elseif p2<p3
                stat_table{counter,band_id * 6} = 1;
            else
                stat_table{counter,band_id * 6} = -1;
            end                

            [p2,~,~]= permTest(p3_word,p3_nonword,10000,'sidedness', 'larger');
            [p3,~,~] = permTest(p3_word,p3_nonword,10000,'sidedness', 'smaller');

            stat_table{counter,band_id * 6 + 1} = min(p2,p3);

            if min(p2,p3) > 0.05
                stat_table{counter,band_id * 6 + 2} = 0;
            elseif p2<p3
                stat_table{counter,band_id * 6 + 2} = 1;
            else
                stat_table{counter,band_id * 6 + 2} = -1;
            end
        end
    end
end

stat_table.Properties.VariableNames = {'contact_id', 'ith_session', 'ref_delta_period1_p','ref_delta_period1_h',...
    'ref_delta_period2_p','ref_delta_period2_h','ref_delta_period3_p','ref_delta_period3_h',...
    'ref_theta_period1_p','ref_theta_period1_h','ref_theta_period2_p','ref_theta_period2_h', 'ref_theta_period3_p','ref_theta_period3_h',...
    'ref_alpha_period1_p','ref_alpha_period1_h','ref_alpha_period2_p','ref_alpha_period2_h', 'ref_alpha_period3_p','ref_alpha_period3_h',...
    'ref_lowbeta_period1_p','ref_lowbeta_period1_h','ref_lowbeta_period2_p','ref_lowbeta_period2_h', 'ref_lowbeta_period3_p','ref_lowbeta_period3_h',...
    'ref_highbeta_period1_p','ref_highbeta_period1_h','ref_highbeta_period2_p','ref_highbeta_period2_h', 'ref_highbeta_period3_p','ref_highbeta_period3_h',...
    'ref_beta_period1_p','ref_beta_period1_h','ref_beta_period2_p','ref_beta_period2_h', 'ref_beta_period3_p','ref_beta_period3_h',...
    'ref_gamma_period1_p','ref_gamma_period1_h','ref_gamma_period2_p','ref_gamma_period2_h', 'ref_gamma_period3_p','ref_gamma_period3_h',...
    'ref_highgamma_period1_p','ref_highgamma_period1_h','ref_highgamma_period2_p','ref_highgamma_period2_h', 'ref_highgamma_period3_p','ref_highgamma_period3_h'};

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat'], 'stat_table','-v7.3');                              