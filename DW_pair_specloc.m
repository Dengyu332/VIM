% Correlate spectrogram with loc, get spec_loc

DW_machine;
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_lead.xlsx']);

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/leadmeantrial_all.mat']);
load([dionysis,'Users/dwang/VIM/datafiles/processed_data/lead_loc_info.mat']);

% get subject list from session_info
Subject_list_rddt = cellfun(@(x) x(1:7),Session_info.Session_id,'UniformOutput',0);
Subject_list = unique(Subject_list_rddt);

contact_total = 0;
for subject_idx = 1:length(Subject_list);
    for contact_idx = 1:size(loc_info(subject_idx).mni_loc_idx,1);
        contact_total = contact_total + 1;
        spec_loc(contact_total).contact_id = [Subject_list{subject_idx},'_',num2str(contact_idx)];
        
        spec_loc(contact_total).category = loc_info(subject_idx).category(contact_idx);
        
        session_oi = find( strcmp(Subject_list(subject_idx),Subject_list_rddt));
        % for loc with more than one session, get average session
        if contact_idx <=4;
            spec_loc(contact_total).sp_ref_avgfirst = mean(cat(3,mean_trial(session_oi(1)).sp_ref_avgfirst(:,:,contact_idx),mean_trial(session_oi(2)).sp_ref_avgfirst(:,:,contact_idx)),3);
            spec_loc(contact_total).sp_ref = mean(cat(3,mean_trial(session_oi(1)).sp_ref(:,:,contact_idx),mean_trial(session_oi(2)).sp_ref(:,:,contact_idx)),3);
        else
            spec_loc(contact_total).sp_ref_avgfirst = mean_trial(session_oi(2)).sp_ref_avgfirst(:,:,contact_idx);
            spec_loc(contact_total).sp_ref = mean_trial(session_oi(2)).sp_ref(:,:,contact_idx);
        end
    end
end

save([dionysis,'Users/dwang/VIM/datafiles/processed_data/leadspec_loc.mat'],'spec_loc','-v7.3');

loc_category = extractfield(spec_loc,'category');
loc_category = cellfun(@(x) cell2mat(x),loc_category,'UniformOutput',0);

VLP_idx = find(strcmp({'VLp'},loc_category));

all_VLP = [];
for i = VLP_idx;

    all_VLP = cat(3,all_VLP,spec_loc(i).sp_ref_avgfirst);
end
VLP_avg = mean(all_VLP,3);


VLA_idx = find(strcmp({'VLa'},loc_category));

all_VLA = [];
for i = VLA_idx;

    all_VLA = cat(3,all_VLA,spec_loc(i).sp_ref_avgfirst);
end
VLA_avg = mean(all_VLA,3);


VP_idx = find(strcmp({'VP'},loc_category));
all_VP = [];
for i = VP_idx;

    all_VP = cat(3,all_VP,spec_loc(i).sp_ref_avgfirst);
end
VP_avg = mean(all_VP,3);



fs = 1000;
fq = 2:2:200;

t = linspace(-3,3,6000);

figure;
imagesc(t, fq,VP_avg');set(gca, 'YDir', 'Normal');

caxis([-5,3]);colorbar