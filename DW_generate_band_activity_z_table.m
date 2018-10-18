% first created on 08/07/2018

% follows DW_batch_subcort_single_contact_hilbert.m

% For each contact, generate an overall activity of each band (alpha, lowbeta, highbeta, highgamma)
% For each contact and each band, Roi is 0.5s post spon, except for
% DBS4039 (1-1.5s post cue)
% output is a z_table
% generate z_table.mat under 'datafiles/preprocessed_new/v2/'

% edit on 09/17/2018
% we also generate z_table2, with Roi -0.5-0.5 peri spon, DBS4039(0.5-1.5 post cue)

%specify machine
DW_machine;

% sampling frequency
fs = 1000;
% load in contact location and side information
load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

% loop control variables
band_selection = {'alpha','lowbeta','highbeta','highgamma'};
ref_selection = {'unref','ref'};


z_table = []; % initiation

% loop through contacts
for contact_id = 1:length(contact_info)
    
    z_table(contact_id,1) = contact_id; % contact_id in first column
    
    contact_id % counting
    
    clearvars -except band_selection Choice contact_id contact_info dionysis dropbox z_table fs ref_selection;
    
    if ismember(contact_id,[13:18])  % treat DBS4039 seperately
        
        % loop through ref 
        for ref_id = 1:2
            ref_name = ref_selection{ref_id};
            
            % then loop through band
            for band_id = 1:4
                band_name = band_selection{band_id};

  
                % load in data, for DBS 4039, load in cuect
                % only
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
                    num2str(contact_id) '_' band_name '_' ref_name '_cuect.mat']);
                % 1-1.5s post cue are regarded as region of interest
                z_val = mean(z(2501:3000));
                z_table(contact_id, band_id*2 + ref_id - 1) = z_val;
            end
        end
        
    else % normal contacts
        for ref_id = 1:2
            ref_name = ref_selection{ref_id};
            for band_id = 1:4
                band_name = band_selection{band_id};

                % load spct
                load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_band_activity/contact_'...
                            num2str(contact_id) '_' band_name '_' ref_name '_spct.mat']);

                z_val = mean(z(2001:2500)); % 0.5s post spon
                z_table(contact_id, band_id*2 + ref_id - 1) = z_val;
                
            end
        end
    end
end

% convert z_table from matrix to struct

clearvars temp;
for i = 1:size(z_table,1)
    temp(i).contact_id = z_table(i,1);
    temp(i).unref_alpha = z_table(i,2);
    temp(i).ref_alpha = z_table(i,3);
    temp(i).unref_lowbeta = z_table(i,4);
    temp(i).ref_lowbeta = z_table(i,5);
    temp(i).unref_highbeta = z_table(i,6);
    temp(i).ref_highbeta = z_table(i,7);
    temp(i).unref_highgamma = z_table(i,8);
    temp(i).ref_highgamma = z_table(i,9);
end

z_table = temp;
readme = 'Roi is 0.5s post spon, except for DBS4039 (1-1.5s post cue onset)';
save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/z_table.mat'],'z_table','readme');