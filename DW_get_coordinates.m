% very first step of getting contact location
% make a list of all contacts and the corresponding anatomical information
% generate contact_info

%set machine to windows
DW_machine;

%load in subject list
Subject_list = readtable([dionysis,'Users\dwang\VIM\datafiles\Docs\Subject_list.xlsx']);

Subject_list(4,:) = []; % DBS4043 has no subcortical recording

contact_id = 0;

merlabel_list = {'macro_a','macro_c','macro_p','macro_m'};

Side_list = {'left','right'};
session_list = {[1,2],2};


for Subject_idx = 1:height(Subject_list)
    Subject_id = Subject_list.Subject_id(Subject_idx);
    Subject_id = cell2mat(Subject_id);
    if Subject_idx <= 5 % MER recording subjects
        % path of data oi
        data_dir = dir(['E:\LeadDBSpractice\Dengyu\Subject\' Subject_id filesep '*_reco1' filesep 'ea_mermarkers.mat']);
        
        load([data_dir.folder filesep data_dir.name]); % load in mermarkers
        mer = squeeze(struct2cell(mermarkers)); % tranform to cell array
        
        futile_col = find(cellfun(@isempty,mer(5,:)));
        
        mer(:,futile_col) = []; % delete columns that are not cotacts
        
        % then sort the contact according to a c p m

        
        mer = mer';
        
        mer(:,2) = strrep(mer(:,2),'anterior','1');
        mer(:,2) = strrep(mer(:,2),'central','2');
        mer(:,2) = strrep(mer(:,2),'posterior','3');
        mer(:,2) = strrep(mer(:,2),'medial','4');
        
        
        mer = sortrows(mer,[5,2]); % sorting done
        % contact X info
        
        for contact_i = 1:size(mer,1)
            contact_id = contact_id + 1;
            
            contact_info(contact_id).contact_id = contact_id; % contact_id get
            
            label_order = str2num(cell2mat(mer(contact_i,2)));
            
            label_i = cell2mat(merlabel_list(label_order));
            
            contact_info(contact_id).label = label_i; % label get
            
            contact_info(contact_id).subject_id = Subject_id; % subject_id get
            
            contact_info(contact_id).side = cell2mat(mer(contact_i,1)); % side get
            
            contact_info(contact_id).session = str2num(cell2mat(mer(contact_i,5))); % session get

            contact_info(contact_id).mni_coords = cell2mat(mer(contact_i,10)); % mni coordinates get
            
        end
    else % lead recording subjects
        
        data_dir = dir(['E:\LeadDBSpractice\Dengyu\Subject\' Subject_id filesep '*_reco1' filesep 'ea_reconstruction.mat']);
        
        load([data_dir.folder filesep data_dir.name]); % load in reco
        coords_i = cell2mat(reco.mni.coords_mm(2:-1:1)'); % from left to right, bottom to top
        for contact_i = 1:8
            contact_id = contact_id + 1;
            
            contact_info(contact_id).contact_id = contact_id; % contact_id get
            
            contact_info(contact_id).label = ['dbs_0' num2str(contact_i)]; % label get
            
            contact_info(contact_id).subject_id = Subject_id; % subject_id get
        
            contact_info(contact_id).side = cell2mat(Side_list(ceil(contact_i/4))); % side get
            
            contact_info(contact_id).session = cell2mat(session_list(ceil(contact_i/4))); % session get
         
            contact_info(contact_id).mni_coords = coords_i(contact_i,:); % mni coordinates get
        end
        
    end
end

save('Z:\Users\dwang\VIM\Results\contact_loc\contact_info.mat','contact_info','-v7.3');