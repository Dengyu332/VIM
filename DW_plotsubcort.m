%group plot contacts to subcortical regions
DW_machine;

load('E:\MATLAB\lead_v2.1.5\templates\space\MNI_ICBM_2009b_NLIN_ASYM\cortex\CortexHiRes.mat');

%load([dionysis 'Users\dwang\VIM\datafiles\subcortical_atlases\atlases_new.mat']);

load([dionysis 'Users\dwang\VIM\datafiles\subcortical_atlases\atlases_old.mat']);

%load([dionysis 'Users\dwang\VIM\datafiles\subcortical_atlases\atlases_thal.mat']);

load([dionysis 'Users\dwang\VIM\Results\contact_loc\contact_info.mat']);

% plot cortex
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

% plot thalamus & vim (distal medium atlas) #16 and #18

hold on;

thal_r = patch('vertices',atlases_thal.fv{16,1}.vertices,'faces',atlases_thal.fv{16,1}.faces,...
'facecolor',atlases_thal.colormap(16,:),'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

thal_l = patch('vertices',atlases_thal.fv{16,2}.vertices,'faces',atlases_thal.fv{16,2}.faces,...
'facecolor',atlases_thal.colormap(16,:),'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

vim_r = patch('vertices',atlases_thal.fv{18,1}.vertices,'faces',atlases_thal.fv{18,1}.faces,...
'facecolor',atlases_thal.colormap(18,:),'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.3);


vim_l = patch('vertices',atlases_thal.fv{18,2}.vertices,'faces',atlases_thal.fv{18,2}.faces,...
'facecolor',atlases_thal.colormap(18,:),'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.3);

% plot contacts
coords_mess = extractfield(contact_info,'mni_coords');
coords_all = reshape(coords_mess,[3,length(coords_mess)/3])'; % get all contacts' coordinates

plot3(coords_all(:,1), coords_all(:,2), coords_all(:,3), 'r.', 'markersize', 8)

saveas(gcf,'Z:\Users\dwang\VIM\Results\contact_loc\outlook.fig');