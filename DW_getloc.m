% Find the location of each contact in thalamus, use windows server to do
% the job
% preliminary analysis for SFN abstract submission

%set machine to windows
DW_machine;

% load in left hemisphere and subcortical atalases
load('E:\MATLAB\leaddbs-master\templates\space\MNI_ICBM_2009b_NLIN_ASYM\atlases\DISTAL compound DBS (Ewert 2016)/atlas_index.mat', 'atlases');
load('E:\MATLAB\lead\templates\space\MNI_ICBM_2009b_NLIN_ASYM\cortex/CortexHiRes.mat', 'Vertices_lh', 'Faces_lh');

%load in session info
Session_info = readtable([dionysis,'Users\dwang\VIM\datafiles\Docs\Session_info_lead.xlsx']);

% get patient list from Session_info
Patient_list_rddt = cellfun(@(x) x(1:7),Session_info.Session_id,'UniformOutput',0);
Patient_list = unique(Patient_list_rddt);

% loop through all subjects and find contact loc, inpolyhedron function used
dup_loc = [];
for Patient_idx = 1:length(Patient_list);
    lead_loc = load([dionysis,'Electrophysiology_Data\DBS_Intraop_Recordings\',Patient_list{Patient_idx},...
        '/Anatomy/Lead_',Patient_list{Patient_idx},'/ea_reconstruction.mat'], 'reco');
    
    loc_info(Patient_idx).Patient_id = Patient_list{Patient_idx};
    loc_info(Patient_idx).mni_coord = [lead_loc.reco.mni.coords_mm{2};lead_loc.reco.mni.coords_mm{1}];
    
    
    clear coord;
    for contact_idx = 1:size(loc_info(Patient_idx).mni_coord,1);
        coord(contact_idx,:) = loc_info(Patient_idx).mni_coord(contact_idx,:);
        if contact_idx <= 4;  % left
            sided_atlas = atlases.fv(:,2);
        else
            sided_atlas = atlases.fv(:,1); % right
        end
        atlas_idx = find(cell2mat(cellfun(@(x) inpolyhedron(x,coord(contact_idx,:)),sided_atlas,'UniformOutput',0)));
        
        if isempty(atlas_idx);
            atlas_idx = NaN;
        elseif length(atlas_idx) > 1;
            dup_loc{Patient_idx,contact_idx} = atlas_idx;
            atlas_idx = max(atlas_idx);
        end
        
        
        loc_info(Patient_idx).mni_loc_idx(contact_idx,1) = atlas_idx;
        if isnan(atlas_idx);
            loc_info(Patient_idx).mni_loc_name(contact_idx,1) = {[]};
        else
            loc_info(Patient_idx).mni_loc_name(contact_idx,1) = atlases.names(atlas_idx);
        end
    end
end
% then manually inspect contact with duplicate locations, and manually
% choose one

compact_loc_idx = extractfield(loc_info,'mni_loc_idx');
unique_loc_idx = unique(compact_loc_idx);
%remove NaN
unique_loc_idx = unique_loc_idx(find(~isnan(unique_loc_idx)));

%do a frequency stat;
atlas_freq = histc(compact_loc_idx,unique_loc_idx);

% atlas: 7,46, 49: VLa; atlas 44,45:VLp; atlas 38,40: VP

category(1) = {[7,46,49]};
category(2) = {[44,45]};
category(3) = {[38,40]};

category_name(1) = {'VLa'};
category_name(2) = {'VLp'};
category_name(3) = {'VP'};

% categorize contac location: VLa, VLp, VP
for Patient_idx = 1:length(Patient_list);
    for contact_idx = 1:size(loc_info(Patient_idx).mni_coord,1);
        if isnan(loc_info(Patient_idx).mni_loc_idx(contact_idx));
            loc_info(Patient_idx).category(contact_idx,1) = {[]};
        else
            fall_in_category = cell2mat(cellfun(@(x) ismember(loc_info(Patient_idx).mni_loc_idx(contact_idx),x),category,'UniformOutput',0));
            
            if ~isempty(find(fall_in_category));
                
                loc_info(Patient_idx).category(contact_idx,1) = category_name(find(fall_in_category));
            else
                loc_info(Patient_idx).category(contact_idx,1) = {[]};
            end
        end
    end
end

save([dionysis,'Users\dwang\VIM\datafiles\processed_data\lead_loc_info.mat'],'loc_info','-v7.3');