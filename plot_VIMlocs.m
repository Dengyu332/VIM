load('/Volumes/Nexus/Users/akappel/_Downloads/leaddbs/templates/space/MNI_ICBM_2009b_NLIN_ASYM/atlases/DISTAL compound DBS (Ewert 2016)/atlas_index.mat', 'atlases')
load('/Volumes/Nexus/Users/akappel/_Downloads/leaddbs/templates/space/MNI_ICBM_2009b_NLIN_ASYM/cortex/CortexHiRes.mat', 'Vertices_lh', 'Faces_lh')

figure; hold on

Hp = patch('vertices',Vertices_lh,'faces',Faces_lh,...
    'facecolor',[.750 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.25);
camlight('headlight','infinite');
axis off; axis equal

set(gca,'CameraPosition',DispCamPos.cp,...
'CameraTarget',DispCamPos.ct,...
'CameraViewAngle',DispCamPos.cva,...
'CameraUpVector',DispCamPos.uv);

for side=1:2
    Hp = patch('vertices',atlases.fv{43,side}.vertices,'faces',atlases.fv{43,side}.faces,...
        'facecolor',[.50 .50 .750],'edgecolor','none',...
        'facelighting', 'gouraud', 'specularstrength', .50, 'diffusestrength', 0.1, 'facealpha', 0.35);
    %camlight('headlight','infinite');
    %axis on; axis equal
    hold on;
    Hp = patch('vertices',atlases.fv{44,side}.vertices,'faces',atlases.fv{44,side}.faces,...
        'facecolor',[.50 .50 .750],'edgecolor','none',...
        'facelighting', 'gouraud', 'specularstrength', .50, 'diffusestrength', 0.1, 'facealpha', 0.35);
    %camlight('headlight','infinite');
    %axis on; axis equal
    Hp = patch('vertices',atlases.fv{45,side}.vertices,'faces',atlases.fv{45,side}.faces,...
        'facecolor',[.50 .50 .750],'edgecolor','none',...
        'facelighting', 'gouraud', 'specularstrength', .50, 'diffusestrength', 0.1, 'facealpha', 0.35);
    %camlight('headlight','infinite');
    %axis on; axis equal
    
     %alpha 0.75
    

end

Voa = find(contains(atlases.names, 'Ventrooralis'));

for side=1:2
    
    for reg = Voa
        Hp = patch('vertices',atlases.fv{reg,side}.vertices,'faces',atlases.fv{reg,side}.faces,...
            'facecolor',[.50 .750 .50],'edgecolor','none',...
            'facelighting', 'gouraud', 'specularstrength', .50, 'diffusestrength', 0.1, 'facealpha', 0.35);
        %camlight('headlight','infinite');
        %axis on; axis equal
        %hold on;
    end

end

for side=1:length(lead_loc.reco.mni.coords_mm)
    plot3(lead_loc.reco.mni.coords_mm{side}(:,1), lead_loc.reco.mni.coords_mm{side}(:,2), lead_loc.reco.mni.coords_mm{side}(:,3), 'r.', 'markersize', 18)
    % plot3(lead_loc.reco.mni.trajectory{side}(:,1), lead_loc.reco.mni.trajectory{side}(:,2), lead_loc.reco.mni.trajectory{side}(:,3), 'k', 'linewidth', 1)
end

saveas(gcf,[subjects{s},'.pdf'], 'pdf');

set(gca,'CameraPosition',DispCamPos.cp,...
'CameraTarget',DispCamPos.ct,...
'CameraViewAngle',DispCamPos.cva,...
'CameraUpVector',DispCamPos.uv);

DispCamPos.cp = campos;
DispCamPos.cva = camva;
DispCamPos.ct = camtarget;
DispCamPos.uv = camup;


Voa = find(contains(atlases.names, 'Ventrooralis'));

for side=1:2
    
    for reg = Voa
        Hp = patch('vertices',atlases.fv{reg,side}.vertices,'faces',atlases.fv{reg,side}.faces,...
            'facecolor',[.50 .750 .50],'edgecolor','none',...
            'facelighting', 'gouraud', 'specularstrength', .50, 'diffusestrength', 0.1, 'facealpha', 0.35);
        camlight('headlight','infinite');
        axis on; axis equal
        hold on;
    end

end


cd('/Volumes/Nexus/Electrophysiology_Data/DBS_Intraop_Recordings/')

for s = 1:length(subjects)
    lead_loc = load([subjects{s},'/Anatomy/Lead_',subjects{s},'/ea_reconstruction.mat'], 'reco');
    if isempty(lead_loc)
        fprintf('Could not find recon for Subject %s\n', subjects{s});
    else
        for side=1:length(lead_loc.reco.mni.coords_mm)
            plot3(lead_loc.reco.mni.coords_mm{side}(:,1), lead_loc.reco.mni.coords_mm{side}(:,2), lead_loc.reco.mni.coords_mm{side}(:,3), 'r.', 'markersize', 25)
           % plot3(lead_loc.reco.mni.trajectory{side}(:,1), lead_loc.reco.mni.trajectory{side}(:,2), lead_loc.reco.mni.trajectory{side}(:,3), 'k', 'linewidth', 1)
        end
    end
end

for side=1:2
     Hp = patch('vertices',atlases.fv{12,side}.vertices,'faces',atlases.fv{12,side}.faces,...
        'facecolor',[.50 .750 .50],'edgecolor','none',...
        'facelighting', 'gouraud', 'specularstrength', .50);
end


Hp = patch('vertices',Vertices_lh,'faces',Faces_lh,...
    'facecolor',[.750 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50, 'facealpha', 0.25);
camlight('headlight','infinite');
axis on; axis equal

alpha 0.25
    
    
    
    
    
for i=1:Vol.dim(1)
    for j=1:Vol.dim(2)
        for k=1:Vol.dim(3)
            MNImm{} = ()
        end
    end
end

MNImm = [1 1 1; Vol.dim(1), Vol.dim(2), Vol.dim(3)];

MNImm = Vol.mat*[MNImm(:,1) MNImm(:,2) MNImm(:,3) ones(size(MNImm,1),1)]';
MNImm = MNImm';
MNImm(:,4) = [];

MNIaxes{1} = linspace(MNImm(1,1), MNImm(2,1), Vol.dim(1));
MNIaxes{2} = linspace(MNImm(1,2), MNImm(2,2), Vol.dim(2));
MNIaxes{3} = linspace(MNImm(1,3), MNImm(2,3), Vol.dim(3));

figure; imagesc(MNIaxes{2}, MNIaxes{1}, Vol.img(:,:,145)); 
axis equal; colormap bone