% takes in contact_info_step2.mat
% group plot contacts to subcortical regions
DW_machine;

% windows server
load('E:\MATLAB\lead_v2.1.5\templates\space\MNI_ICBM_2009b_NLIN_ASYM\cortex\CortexHiRes.mat');
% local mac
load('/Users/Dengyu/Downloads/lead/templates/space/MNI_ICBM_2009b_NLIN_ASYM/cortex/CortexHiRes.mat');

%load([dionysis 'Users\dwang\VIM\datafiles\subcortical_atlases\atlases_new.mat']);

load([dionysis 'Users/dwang/VIM/datafiles/subcortical_atlases/atlases_old.mat']);

%load([dionysis 'Users/dwang/VIM/datafiles/subcortical_atlases/atlases_thal.mat']);

load([dionysis 'Users/dwang/VIM/Results/contact_loc/contact_info_step2.mat']);

% plot cortex
rh = patch('vertices',Vertices_rh,'faces',Faces_rh,...
    'facecolor',[.750 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);
camlight('headlight','infinite');
axis off; axis equal
hold on;

lh = patch('vertices',Vertices_lh,'faces',Faces_lh,...
    'facecolor',[.750 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);
camlight('headlight','infinite');
axis off; axis equal

%% plot thalamus & vim (distal medium atlas) #16 and #18

hold on;

thal_r = patch('vertices',atlases_thal.fv{16,1}.vertices,'faces',atlases_thal.fv{16,1}.faces,...
'facecolor',atlases_thal.colormap(16,:),'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.2);

thal_l = patch('vertices',atlases_thal.fv{16,2}.vertices,'faces',atlases_thal.fv{16,2}.faces,...
'facecolor',atlases_thal.colormap(16,:),'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.2);

vim_r = patch('vertices',atlases_thal.fv{18,1}.vertices,'faces',atlases_thal.fv{18,1}.faces,...
'facecolor',atlases_thal.colormap(18,:),'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.5);


vim_l = patch('vertices',atlases_thal.fv{18,2}.vertices,'faces',atlases_thal.fv{18,2}.faces,...
'facecolor',atlases_thal.colormap(18,:),'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.5);

% plot contacts
coords_mess = extractfield(contact_info,'mni_coords');
coords_all = reshape(coords_mess,[3,length(coords_mess)/3])'; % get all contacts' coordinates

plot3(coords_all(:,1), coords_all(:,2), coords_all(:,3), 'r.', 'markersize', 10)

saveas(gcf,'Z:\Users\dwang\VIM\Results\contact_loc\outlook.fig');


%% plot left thalamus and all left contacts
% plot cortex
rh = patch('vertices',Vertices_rh,'faces',Faces_rh,...
    'facecolor',[.750 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.01);
camlight('headlight','infinite');
axis off; axis equal
hold on;

lh = patch('vertices',Vertices_lh,'faces',Faces_lh,...
    'facecolor',[.750 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);
camlight('headlight','infinite');
axis off; axis equal
hold on;

thal_l = patch('vertices',atlases_thal.fv{16,2}.vertices,'faces',atlases_thal.fv{16,2}.faces,...
'facecolor',[1,0.3,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.2);

%left

hold on;
% VLa
temp = patch('vertices',atlases_old.fv{7,2}.vertices,'faces',atlases_old.fv{7,2}.faces,...
'facecolor',[0,1,1],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);
axis off; axis equal

temp = patch('vertices',atlases_old.fv{46,2}.vertices,'faces',atlases_old.fv{46,2}.faces,...
'facecolor',[0,1,1],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{49,2}.vertices,'faces',atlases_old.fv{49,2}.faces,...
'facecolor',[0,1,1],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

%VLp
temp = patch('vertices',atlases_old.fv{44,2}.vertices,'faces',atlases_old.fv{44,2}.faces,...
'facecolor',[0,1,1],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{45,2}.vertices,'faces',atlases_old.fv{45,2}.faces,...
'facecolor',[0,1,1],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{56,2}.vertices,'faces',atlases_old.fv{56,2}.faces,...
'facecolor',[0,1,1],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);


for contact_idx = 1:length(contact_info)
    if strcmp(contact_info(contact_idx).side,'left') && strcmp(contact_info(contact_idx).group_used,'VLa')
        
        plot3(contact_info(contact_idx).mni_coords(1),contact_info(contact_idx).mni_coords(2),contact_info(contact_idx).mni_coords(3),...
            'r.','MarkerSize',6);
    elseif strcmp(contact_info(contact_idx).side,'left') && strcmp(contact_info(contact_idx).group_used,'VLp')
        plot3(contact_info(contact_idx).mni_coords(1),contact_info(contact_idx).mni_coords(2),contact_info(contact_idx).mni_coords(3),...
            'r.','MarkerSize',6);
    end
end


%% plot contacts to VLa and VLp, and discriminate them by color
VLa = [7,46,49];
VLp = [44,45,56];

% left first

hold on;
% VLa
temp = patch('vertices',atlases_old.fv{7,2}.vertices,'faces',atlases_old.fv{7,2}.faces,...
'facecolor',[0,1,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);
axis off; axis equal

temp = patch('vertices',atlases_old.fv{46,2}.vertices,'faces',atlases_old.fv{46,2}.faces,...
'facecolor',[0,1,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{49,2}.vertices,'faces',atlases_old.fv{49,2}.faces,...
'facecolor',[0,1,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

%VLp
temp = patch('vertices',atlases_old.fv{44,2}.vertices,'faces',atlases_old.fv{44,2}.faces,...
'facecolor',[1,0,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{45,2}.vertices,'faces',atlases_old.fv{45,2}.faces,...
'facecolor',[1,0,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{56,2}.vertices,'faces',atlases_old.fv{56,2}.faces,...
'facecolor',[1,0,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

for contact_idx = 1:length(contact_info)
    if strcmp(contact_info(contact_idx).side,'left') && strcmp(contact_info(contact_idx).group_used,'VLa')
        
        plot3(contact_info(contact_idx).mni_coords(1),contact_info(contact_idx).mni_coords(2),contact_info(contact_idx).mni_coords(3),...
            'Color',[0,0,0],'Marker','x','MarkerSize',8);
    elseif strcmp(contact_info(contact_idx).side,'left') && strcmp(contact_info(contact_idx).group_used,'VLp')
        plot3(contact_info(contact_idx).mni_coords(1),contact_info(contact_idx).mni_coords(2),contact_info(contact_idx).mni_coords(3),...
            'b+','MarkerSize',8);
    end
end


% then right

hold on;
% VLa
temp = patch('vertices',atlases_old.fv{7,1}.vertices,'faces',atlases_old.fv{7,1}.faces,...
'facecolor',[0,1,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);
axis off; axis equal

temp = patch('vertices',atlases_old.fv{46,1}.vertices,'faces',atlases_old.fv{46,1}.faces,...
'facecolor',[0,1,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{49,1}.vertices,'faces',atlases_old.fv{49,1}.faces,...
'facecolor',[0,1,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

%VLp
temp = patch('vertices',atlases_old.fv{44,1}.vertices,'faces',atlases_old.fv{44,1}.faces,...
'facecolor',[1,0,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{45,1}.vertices,'faces',atlases_old.fv{45,1}.faces,...
'facecolor',[1,0,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

temp = patch('vertices',atlases_old.fv{56,1}.vertices,'faces',atlases_old.fv{56,1}.faces,...
'facecolor',[1,0,0],'edgecolor','none',...
'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.1);

for contact_idx = 1:length(contact_info)
    if strcmp(contact_info(contact_idx).side,'right') && strcmp(contact_info(contact_idx).group_used,'VLa')
        
        plot3(contact_info(contact_idx).mni_coords(1),contact_info(contact_idx).mni_coords(2),contact_info(contact_idx).mni_coords(3),...
            'Color',[0,0,0],'Marker','x','MarkerSize',8);
    elseif strcmp(contact_info(contact_idx).side,'right') && strcmp(contact_info(contact_idx).group_used,'VLp')
        plot3(contact_info(contact_idx).mni_coords(1),contact_info(contact_idx).mni_coords(2),contact_info(contact_idx).mni_coords(3),...
            'b+','MarkerSize',8);
    end
end