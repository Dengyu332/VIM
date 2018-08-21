% This script follows DW_group_lead_loc. Group contacts to VA, VLa, VLp and VP
% use atlases of V-1.6
% generate contact_info_step2.mat

% specify machine to run on
DW_machine;
% load in contacts information and atlases

load('E:\MATLAB\lead_v2.1.5\templates\space\MNI_ICBM_2009b_NLIN_ASYM\cortex\CortexHiRes.mat');

%load([dionysis 'Users\dwang\VIM\datafiles\subcortical_atlases\atlases_new.mat']);

load([dionysis 'Users\dwang\VIM\datafiles\subcortical_atlases\atlases_old.mat']);

%load([dionysis 'Users\dwang\VIM\datafiles\subcortical_atlases\atlases_thal.mat']);

load([dionysis 'Users\dwang\VIM\Results\contact_loc\contact_info.mat']);


% get all contacts' coordinates
coords_mess = extractfield(contact_info,'mni_coords');
coords_all = reshape(coords_mess,[3,length(coords_mess)/3])';

% loop through all contacts and for each contact find the structure it is in, for each atlas
% inpolyhedron function used
for contact_idx = 1:length(contact_info)
    if strcmp(contact_info(contact_idx).side,'left')
        disp('left atlases used'); % use left atlases
           
        contact_info(contact_idx).atlases_old_idx = find(cell2mat(cellfun(@(x) inpolyhedron(x,contact_info(contact_idx).mni_coords),atlases_old.fv(:,2),'UniformOutput',0)));
    else
        disp('right atlases used'); % use right atlases

        
        contact_info(contact_idx).atlases_old_idx = find(cell2mat(cellfun(@(x) inpolyhedron(x,contact_info(contact_idx).mni_coords),atlases_old.fv(:,1),'UniformOutput',0)));
    end
end

% show involved structures and the frequency
unique(extractfield(contact_info,'atlases_old_idx'))
atlas_freq = histc(extractfield(contact_info,'atlases_old_idx'),unique(extractfield(contact_info,'atlases_old_idx')))

% include region of interests only

% atlases_new_oi = [36,41,58,64:79,82,89:93,95:101];
atlases_old_oi = [3:7,15,35:40,42:47,49:50,53,54,55,56,57,58,59];
% atlases_thal_oi = [17,18,19];


for contact_idx = 1:length(contact_info)
    
    %contact_info(contact_idx).atlases_thal_idx = intersect(atlases_thal_oi,contact_info(contact_idx).atlases_thal_idx);

    contact_info(contact_idx).atlases_old_idx_oi = intersect(atlases_old_oi,contact_info(contact_idx).atlases_old_idx);

    %contact_info(contact_idx).atlases_new_idx = intersect(atlases_new_oi,contact_info(contact_idx).atlases_new_idx);
end

unique(extractfield(contact_info,'atlases_old_idx_oi'))

%% Give name to region
for contact_idx = 1:length(contact_info);
    if isempty(contact_info(contact_idx).atlases_old_idx)
        contact_info(contact_idx).region = [];
    else 
        contact_info(contact_idx).region = atlases_old.names{contact_info(contact_idx).atlases_old_idx}(1:end-7);
    end
end
%% group contacts to VA, VLa, VLp, VP
VA = 5;
VLa = [7,46,49];
VLp = [44,45,56];
VP = [36,38,40];
region_group = {VA,VLa,VLp,VP};
label = {'VA','VLa','VLp','VP'};
for contact_idx = 1:length(contact_info);
    if isempty(contact_info(contact_idx).atlases_old_idx_oi)
        contact_info(contact_idx).group = [];
    else 
        contact_info(contact_idx).group = cell2mat(label(find(cell2mat(cellfun(@(x) ismember(contact_info(contact_idx).atlases_old_idx_oi,x),region_group,'UniformOutput',0)))));
    end
end
%% There are some ungrouped contacts, try grouping them manually
atlas_oi = [7,46,49,44,45,56]; % index of VLa and VLp

for contact_idx = 1:length(contact_info)
    if isempty(contact_info(contact_idx).atlases_old_idx_oi)
        disp(['this is contact ' num2str(contact_idx)])
        if strcmp(contact_info(contact_idx).side,'left')
            side = 2;
        else
            side = 1;
        end
        
        rh = patch('vertices',Vertices_rh,'faces',Faces_rh,...
    'facecolor',[.750 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.01);
camlight('headlight','infinite');
axis off; axis equal
hold on;

lh = patch('vertices',Vertices_lh,'faces',Faces_lh,...
    'facecolor',[.750 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.01);
camlight('headlight','infinite');
axis off; axis equal

hold on;
        
        plot3( contact_info(contact_idx).mni_coords(1), contact_info(contact_idx).mni_coords(2), contact_info(contact_idx).mni_coords(3), 'r.', 'markersize', 8)
        
        
         i = 0;
        for structure_id = atlas_oi(1:3)
            i = i +1;
            hold on;
            temp = patch('vertices',atlases_old.fv{structure_id,side}.vertices,'faces',atlases_old.fv{structure_id,side}.faces,...
            'facecolor',[0,0+i*(1/3),0],'edgecolor','none',...
            'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 1);
            axis off; axis equal 
        end
        
         i = 0;
        for structure_id = atlas_oi(4:6)
            i = i +1;
            hold on;
            temp = patch('vertices',atlases_old.fv{structure_id,side}.vertices,'faces',atlases_old.fv{structure_id,side}.faces,...
            'facecolor',[0+i*(1/3),0,0],'edgecolor','none',...
            'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 1);
            axis off; axis equal 
        end        
        
        pause;
        alpha 0.5;
        pause;
        
        contact_info(contact_idx).screened_new = input('this contact belongs to structure #: ');
        
        close all;
        
    end
end

%%
for contact_idx = 1:length(contact_info);
    if isequal(contact_info(contact_idx).screened_new,VLa)
        contact_info(contact_idx).screened_new = 'VLa';
    elseif isequal(contact_info(contact_idx).screened_new,VLp)
        contact_info(contact_idx).screened_new = 'VLp';
    end
end
%% create field "group_used"
for contact_idx = 1:length(contact_info);
    contact_info(contact_idx).group_used = contact_info(contact_idx).group;
    if isempty(contact_info(contact_idx).group_used)
        contact_info(contact_idx).group_used = contact_info(contact_idx).screened_new;
    end
end
contact_info(14).group_used = [];

save([dionysis 'Users\dwang\VIM\Results\contact_loc\contact_info_step2.mat'],'contact_info','-v7.3');