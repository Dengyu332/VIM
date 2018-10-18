% First created on 10/04/2018
% Follows DW_wordnonword_contact_band_trial.m

% aims to generate a table of average z value for each contact each session
% each band and each period oi and each trial inclusion selection

% period1: 0.5s pre spon (DBS4039 0.5 - 1 post cue)
% period2: 0.5s post spon ( DBS4039 1-1.5 post cue)
% period3: -0.5 - 0.5 peri spon (DBS4039 0.5-1.5 post cue)

% so we use spct data only (except DBS4039 use cuect)

% generate z_table under VIM/datafiles/preprocessed_new/v2/WordVsNonword/

% specify machine to run
DW_machine;

% load in stat_table as a table reference, use the same row index
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/stat_table.mat']);

% band selection
band_selection = {'delta', 'theta', 'alpha','lowbeta','highbeta', 'beta', 'gamma', 'highgamma'};

% trial inclusion selection
inclusion_selection = {'120', '60'};

% period selection
period_selection = {'period1', 'period2' ,'period3'};
% period1: 0.5s pre spon (DBS4039 0.5 - 1 post cue)
% period2: 0.5s post spon ( DBS4039 1-1.5 post cue)
% period3: -0.5 - 0.5 peri spon (DBS4039 0.5-1.5 post cue)

% so we use spct data only (except DBS4039 use cuect)

% init z_table
z_table = table();

% loop through rows
for row_idx = 1:height(stat_table)
    clearvars -except band_selection dionysis dropbox inclusion_selection period_selection row_idx stat_table z_table
    contact_id = stat_table.contact_id(row_idx);
    z_table.contact_id(row_idx) = contact_id;
    z_table.ith_session(row_idx) = stat_table.ith_session(row_idx);
    
    % loop through band
    for band_id = 1:length(band_selection)
        band_name = band_selection{band_id};
        
        % loop through inclusion selection
        for inclusion_id = 1:length(inclusion_selection)
            inclusion_name = inclusion_selection{inclusion_id};
            
            % starts loading in data and fill in z_table
            
            % first deal with DBS4039
            if ismember(contact_id,[13:18]) % DBS4039
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity/' ...
                    'contact_' num2str(contact_id) '_session' num2str(z_table.ith_session{row_idx}) ...
                    '_' band_name '_ref_cuect_' inclusion_name '.mat']);
                % get z (1X4000) from -1.5 t 2.5 peri cue
                
                z_table{row_idx,['ref_' band_name '_period1_' inclusion_name]} = mean(z(2001:2500));
                z_table{row_idx,['ref_' band_name '_period2_' inclusion_name]} = mean(z(2501:3000));
                z_table{row_idx,['ref_' band_name '_period3_' inclusion_name]} = mean(z(2001:3000));
                
                % done for DBS4039
            else % other subjects
                if length(z_table.ith_session{row_idx}) == 1
                    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity/' ...
                        'contact_' num2str(contact_id) '_session' num2str(z_table.ith_session{row_idx}) ...
                        '_' band_name '_ref_spct_' inclusion_name '.mat']);
                else % two-session row
                    load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity/' ...
                        'contact_' num2str(contact_id) '_all_'...
                         band_name '_ref_spct_' inclusion_name '.mat']);
                end
                
                z_table{row_idx,['ref_' band_name '_period1_' inclusion_name]} = mean(z(1501:2000));
                z_table{row_idx,['ref_' band_name '_period2_' inclusion_name]} = mean(z(2001:2500));
                z_table{row_idx,['ref_' band_name '_period3_' inclusion_name]} = mean(z(1501:2500)); 
                %done
            end
        end
    end
end        

% save z_table
save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/z_table'],'z_table','-v7.3');