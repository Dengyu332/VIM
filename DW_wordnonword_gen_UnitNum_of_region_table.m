% First created on 10/15/2018
% Generate a table, of which each row is a ref_band, and each 
% column is a region of interest, and the value in each cell represents the
% number of units in this region
% use period2 (-0.5 to 0.5 peri speech onset) window to decide
% significance, and bofferoni corrected (p multiply by 123)

%
DW_machine;
% load in speech_response_table
load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table.mat']);
%%% remove session_combined rows
unique_contact = unique(speech_response_table.contact_id);
hasi = 0;
discard_idx = [];
for i = 1:length(unique_contact)
    contact_i = unique_contact(i);
    temp = find(speech_response_table.contact_id == contact_i);
    if length(temp) == 1
    else
        hasi = hasi + 1;
    discard_idx(hasi) =  temp(3);
    end
end
speech_response_table(discard_idx,:) = []; % 123 units in total
%%%

%%%% generate combination matrix
band_selection = {'delta', 'theta', 'alpha','lowbeta','highbeta', 'beta', 'gamma', 'highgamma'};

sig_selection = {'All', 'Sig', 'SigUp', 'SigDown'};
recording_selection = {'','MER','Lead'};
side_selection = {'','Left','Right'};

recording_idxs = {1:height(speech_response_table),1:39,40:height(speech_response_table)};
side_idxs = {1:height(speech_response_table), ...
    find(strcmp('left',speech_response_table.side)), ...
    find(strcmp('right',speech_response_table.side))};

table_oi = table();
counter = 0;

%%% loop through rows
 for band_id = 1:length(band_selection)
     band_name = band_selection{band_id};
     counter = counter + 1;
         
     % use period2_120 of this band to judge if this band is
     % significantly modulated
     p_oi = speech_response_table{:,['ref_' band_name '_period2_120_p']};
     h_oi = speech_response_table{:,['ref_' band_name '_period2_120_h']};
         
     sig_idxs{1} = 1:height(speech_response_table); % all
     sig_idxs{2} = find(p_oi * height(speech_response_table) < 0.05); % sig
     sig_idxs{3} = find(p_oi * height(speech_response_table) < 0.05 & h_oi == 1); % SigUp
     sig_idxs{4} = find(p_oi * height(speech_response_table) < 0.05 & h_oi == -1); % SigDown

     table_oi{counter,'category'} = {['ref_' band_name]};
         
     %%% loop through columns
         
     for sig_id = 1:length(sig_selection)
         sig_name = sig_selection{sig_id};
         sig_idx_oi = sig_idxs{sig_id};

         for recording_id = 1:length(recording_selection)
             recording_name = recording_selection{recording_id};
             recording_idx_oi = recording_idxs{recording_id};

             for side_id = 1:length(side_selection)
                 side_name = side_selection{side_id};
                 side_idx_oi = side_idxs{side_id};

                 idx_final = intersect(intersect(sig_idx_oi, recording_idx_oi),side_idx_oi);
                 name_final = [sig_name recording_name side_name];
                 table_oi{counter,name_final} = length(idx_final);  
             end
         end
     end
 end

 UnitNum_of_region_table = table_oi;
 
 readme = 'Each row is a ref_band, each column is a region of interest, value is number of units in this region';
 save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/UnitNum_of_region_table.mat'], 'UnitNum_of_region_table',...
     'readme');