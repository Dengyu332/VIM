% follows DW_categorizing_contacts.m
% takes in contact_info_step2.mat under 'Users/dwang/VIM/datafiles/contact_loc/'
% Generate 3D plots of grand contact location
% one color for one subject
% left and right seperately

% mni coords: left - right; posterior - anterior; bottom - top

DW_machine;

load([dionysis 'Users/dwang/VIM/datafiles/contact_loc/contact_info_step2.mat']);

left_cords = [];
right_cords = [];

for i = 1:length(contact_info)
    if strcmp(contact_info(i).side,'left')
        left_cords = vertcat(left_cords,contact_info(i).mni_coords);
    else
        right_cords = vertcat(right_cords,contact_info(i).mni_coords);
    end
end

figure; plot3(left_cords(:,1),left_cords(:,2),left_cords(:,3),'o')
cam_pos_left = campos;

figure; plot3(right_cords(:,1),right_cords(:,2),right_cords(:,3),'o')
cam_pos_right = campos;

close all;

%
subject_list = unique(extractfield(contact_info,'subject_id'))';
color_list = {[1,0,0];[0,1,0];[0,0,1];[1,1,0];[1,0,1];[0,1,1];[0,0,0];[244/255,122/255,66/255];[143 66 24]/255;[0 128 128]/255;[0.5 0 0]; [0.5 0.5 0]}

for i = 1:length(contact_info)
    if strcmp(contact_info(i).side,'left') % left 
        figure (1); hold on;
        plot3(contact_info(i).mni_coords(1),contact_info(i).mni_coords(2),contact_info(i).mni_coords(3),'o','MarkerSize',12,'MarkerEdgeColor','k',...
            'MarkerFaceColor',cell2mat(color_list(strcmp(contact_info(i).subject_id,subject_list))));
        campos(cam_pos_left);
    else % right 
        figure (2); hold on;
        plot3(contact_info(i).mni_coords(1),contact_info(i).mni_coords(2),contact_info(i).mni_coords(3),'o','MarkerSize',12,'MarkerEdgeColor','k',...
            'MarkerFaceColor',cell2mat(color_list(strcmp(contact_info(i).subject_id,subject_list))));
        campos(cam_pos_left);
    end
end

saveas(figure (1),[dionysis 'Users/dwang/VIM/Results/New/v2/pos_power_relation/left'],'fig')
saveas(figure (2),[dionysis 'Users/dwang/VIM/Results/New/v2/pos_power_relation/right'],'fig')