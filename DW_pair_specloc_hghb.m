% Correlate hg hb power line with loc, get spec_loc

DW_machine;
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_lead.xlsx']);

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/leadmeantrial_hilb.mat']);
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
            spec_loc(contact_total).delta_sp = mean(cat(2,mean_trial(session_oi(1)).delta_sp_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).delta_sp_ref_avgfirst(:,contact_idx)),2);
            spec_loc(contact_total).theta_sp = mean(cat(2,mean_trial(session_oi(1)).theta_sp_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).theta_sp_ref_avgfirst(:,contact_idx)),2);            
            spec_loc(contact_total).alpha_sp = mean(cat(2,mean_trial(session_oi(1)).alpha_sp_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).alpha_sp_ref_avgfirst(:,contact_idx)),2);
            spec_loc(contact_total).b1_sp = mean(cat(2,mean_trial(session_oi(1)).b1_sp_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).b1_sp_ref_avgfirst(:,contact_idx)),2);            
            spec_loc(contact_total).b2_sp = mean(cat(2,mean_trial(session_oi(1)).b2_sp_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).b2_sp_ref_avgfirst(:,contact_idx)),2);
            spec_loc(contact_total).gamma_sp = mean(cat(2,mean_trial(session_oi(1)).gamma_sp_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).gamma_sp_ref_avgfirst(:,contact_idx)),2);            
            spec_loc(contact_total).hg_sp = mean(cat(2,mean_trial(session_oi(1)).hg_sp_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).hg_sp_ref_avgfirst(:,contact_idx)),2);

            spec_loc(contact_total).delta_cue = mean(cat(2,mean_trial(session_oi(1)).delta_cue_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).delta_cue_ref_avgfirst(:,contact_idx)),2);
            spec_loc(contact_total).theta_cue = mean(cat(2,mean_trial(session_oi(1)).theta_cue_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).theta_cue_ref_avgfirst(:,contact_idx)),2);  
            spec_loc(contact_total).alpha_cue = mean(cat(2,mean_trial(session_oi(1)).alpha_cue_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).alpha_cue_ref_avgfirst(:,contact_idx)),2);
            spec_loc(contact_total).b1_cue = mean(cat(2,mean_trial(session_oi(1)).b1_cue_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).b1_cue_ref_avgfirst(:,contact_idx)),2);             
            spec_loc(contact_total).b2_cue = mean(cat(2,mean_trial(session_oi(1)).b2_cue_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).b2_cue_ref_avgfirst(:,contact_idx)),2);
            spec_loc(contact_total).gamma_cue = mean(cat(2,mean_trial(session_oi(1)).gamma_cue_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).gamma_cue_ref_avgfirst(:,contact_idx)),2);             
            spec_loc(contact_total).hg_cue = mean(cat(2,mean_trial(session_oi(1)).hg_cue_ref_avgfirst(:,contact_idx),mean_trial(session_oi(2)).hg_cue_ref_avgfirst(:,contact_idx)),2);   
        else
            spec_loc(contact_total).delta_sp = mean_trial(session_oi(2)).delta_sp_ref_avgfirst(:,contact_idx);
            spec_loc(contact_total).theta_sp = mean_trial(session_oi(2)).theta_sp_ref_avgfirst(:,contact_idx);
            spec_loc(contact_total).alpha_sp = mean_trial(session_oi(2)).alpha_sp_ref_avgfirst(:,contact_idx);
            spec_loc(contact_total).b1_sp = mean_trial(session_oi(2)).b1_sp_ref_avgfirst(:,contact_idx);            
            spec_loc(contact_total).b2_sp = mean_trial(session_oi(2)).b2_sp_ref_avgfirst(:,contact_idx);
            spec_loc(contact_total).gamma_sp = mean_trial(session_oi(2)).gamma_sp_ref_avgfirst(:,contact_idx);            
            spec_loc(contact_total).hg_sp = mean_trial(session_oi(2)).hg_sp_ref_avgfirst(:,contact_idx);
           
            spec_loc(contact_total).delta_cue = mean_trial(session_oi(2)).delta_cue_ref_avgfirst(:,contact_idx);            
            spec_loc(contact_total).theta_cue = mean_trial(session_oi(2)).theta_cue_ref_avgfirst(:,contact_idx);
            spec_loc(contact_total).alpha_cue = mean_trial(session_oi(2)).alpha_cue_ref_avgfirst(:,contact_idx);            
            spec_loc(contact_total).b1_cue = mean_trial(session_oi(2)).b1_cue_ref_avgfirst(:,contact_idx);
            spec_loc(contact_total).b2_cue = mean_trial(session_oi(2)).b2_cue_ref_avgfirst(:,contact_idx);            
            spec_loc(contact_total).gamma_cue = mean_trial(session_oi(2)).gamma_cue_ref_avgfirst(:,contact_idx);
            spec_loc(contact_total).hg_cue = mean_trial(session_oi(2)).hg_cue_ref_avgfirst(:,contact_idx);            
        end
    end
end

save([dionysis,'Users/dwang/VIM/datafiles/processed_data/leadspec_loc_hilb.mat'],'spec_loc','-v7.3');

%sp
loc_category = extractfield(spec_loc,'category');
loc_category = cellfun(@(x) cell2mat(x),loc_category,'UniformOutput',0);

VLP_idx = find(strcmp({'VLp'},loc_category));


all_VLP_delta = [];
all_VLP_theta = [];
all_VLP_alpha = [];
all_VLP_b1 = [];
all_VLP_b2 = [];
all_VLP_gamma = [];
all_VLP_hg = [];


for i = VLP_idx;

    all_VLP_delta = cat(2,all_VLP_delta,spec_loc(i).delta_sp);
    all_VLP_theta = cat(2,all_VLP_theta,spec_loc(i).theta_sp);
    all_VLP_alpha = cat(2,all_VLP_alpha,spec_loc(i).alpha_sp);
    all_VLP_b1 = cat(2,all_VLP_b1,spec_loc(i).b1_sp);
    all_VLP_b2 = cat(2,all_VLP_b2,spec_loc(i).b2_sp);
    all_VLP_gamma = cat(2,all_VLP_gamma,spec_loc(i).gamma_sp);
    all_VLP_hg = cat(2,all_VLP_hg,spec_loc(i).hg_sp);

end
VLP_delta_avg = mean(all_VLP_delta,2);
VLP_theta_avg = mean(all_VLP_theta,2);
VLP_alpha_avg = mean(all_VLP_alpha,2);
VLP_b1_avg = mean(all_VLP_b1,2);
VLP_b2_avg = mean(all_VLP_b2,2);
VLP_gamma_avg = mean(all_VLP_gamma,2);
VLP_hg_avg = mean(all_VLP_hg,2);



VLA_idx = find(strcmp({'VLa'},loc_category));

all_VLA_delta = [];
all_VLA_theta = [];
all_VLA_alpha = [];
all_VLA_b1 = [];
all_VLA_b2 = [];
all_VLA_gamma = [];
all_VLA_hg = [];
for i = VLA_idx;

    all_VLA_delta = cat(2,all_VLA_delta,spec_loc(i).delta_sp);
    all_VLA_theta = cat(2,all_VLA_theta,spec_loc(i).theta_sp);
    all_VLA_alpha = cat(2,all_VLA_alpha,spec_loc(i).alpha_sp);
    all_VLA_b1 = cat(2,all_VLA_b1,spec_loc(i).b1_sp);
    all_VLA_b2 = cat(2,all_VLA_b2,spec_loc(i).b2_sp);
    all_VLA_gamma = cat(2,all_VLA_gamma,spec_loc(i).gamma_sp);    
    all_VLA_hg = cat(2,all_VLA_hg,spec_loc(i).hg_sp);   
     
end
VLA_delta_avg = mean(all_VLA_delta,2);
VLA_theta_avg = mean(all_VLA_theta,2);
VLA_alpha_avg = mean(all_VLA_alpha,2);
VLA_b1_avg = mean(all_VLA_b1,2);
VLA_b2_avg = mean(all_VLA_b2,2);
VLA_gamma_avg = mean(all_VLA_gamma,2);
VLA_hg_avg = mean(all_VLA_hg,2);


VP_idx = find(strcmp({'VP'},loc_category));



all_VP_delta = [];
all_VP_theta = [];
all_VP_alpha = [];
all_VP_b1 = [];
all_VP_b2 = [];
all_VP_gamma = [];
all_VP_hg = [];
for i = VP_idx;

    all_VP_delta = cat(2,all_VP_delta,spec_loc(i).delta_sp);
    all_VP_theta = cat(2,all_VP_theta,spec_loc(i).theta_sp);    
    all_VP_alpha = cat(2,all_VP_alpha,spec_loc(i).alpha_sp);
    all_VP_b1 = cat(2,all_VP_b1,spec_loc(i).b1_sp);    
    all_VP_b2 = cat(2,all_VP_b2,spec_loc(i).b2_sp);
    all_VP_gamma = cat(2,all_VP_gamma,spec_loc(i).gamma_sp);
    all_VP_hg = cat(2,all_VP_hg,spec_loc(i).hg_sp);
end
VP_delta_avg = mean(all_VP_delta,2);
VP_theta_avg = mean(all_VP_theta,2);
VP_alpha_avg = mean(all_VP_alpha,2);
VP_b1_avg = mean(all_VP_b1,2);
VP_b2_avg = mean(all_VP_b2,2);
VP_gamma_avg = mean(all_VP_gamma,2);
VP_hg_avg = mean(all_VP_hg,2);



figure;
plot(VLA_delta_avg);hold on;plot(VLP_delta_avg);plot(VP_delta_avg);
figure;
plot(VLA_theta_avg);hold on;plot(VLP_theta_avg);plot(VP_theta_avg);
figure;
plot(VLA_alpha_avg);hold on;plot(VLP_alpha_avg);plot(VP_alpha_avg);
figure;
plot(VLA_b1_avg);hold on;plot(VLP_b1_avg);plot(VP_b1_avg);
figure;
plot(VLA_b2_avg);hold on;plot(VLP_b2_avg);plot(VP_b2_avg);
figure;
plot(VLA_gamma_avg);hold on;plot(VLP_gamma_avg);plot(VP_gamma_avg);
figure;
plot(VLA_hg_avg);hold on;plot(VLP_hg_avg);plot(VP_hg_avg);




%cue
loc_category = extractfield(spec_loc,'category');
loc_category = cellfun(@(x) cell2mat(x),loc_category,'UniformOutput',0);

VLP_idx = find(strcmp({'VLp'},loc_category));


all_VLP_delta = [];
all_VLP_theta = [];
all_VLP_alpha = [];
all_VLP_b1 = [];
all_VLP_b2 = [];
all_VLP_gamma = [];
all_VLP_hg = [];


for i = VLP_idx;

    all_VLP_delta = cat(2,all_VLP_delta,spec_loc(i).delta_cue);
    all_VLP_theta = cat(2,all_VLP_theta,spec_loc(i).theta_cue);
    all_VLP_alpha = cat(2,all_VLP_alpha,spec_loc(i).alpha_cue);
    all_VLP_b1 = cat(2,all_VLP_b1,spec_loc(i).b1_cue);
    all_VLP_b2 = cat(2,all_VLP_b2,spec_loc(i).b2_cue);
    all_VLP_gamma = cat(2,all_VLP_gamma,spec_loc(i).gamma_cue);
    all_VLP_hg = cat(2,all_VLP_hg,spec_loc(i).hg_cue);

end
VLP_delta_avg = mean(all_VLP_delta,2);
VLP_theta_avg = mean(all_VLP_theta,2);
VLP_alpha_avg = mean(all_VLP_alpha,2);
VLP_b1_avg = mean(all_VLP_b1,2);
VLP_b2_avg = mean(all_VLP_b2,2);
VLP_gamma_avg = mean(all_VLP_gamma,2);
VLP_hg_avg = mean(all_VLP_hg,2);



VLA_idx = find(strcmp({'VLa'},loc_category));

all_VLA_delta = [];
all_VLA_theta = [];
all_VLA_alpha = [];
all_VLA_b1 = [];
all_VLA_b2 = [];
all_VLA_gamma = [];
all_VLA_hg = [];
for i = VLA_idx;

    all_VLA_delta = cat(2,all_VLA_delta,spec_loc(i).delta_cue);
    all_VLA_theta = cat(2,all_VLA_theta,spec_loc(i).theta_cue);
    all_VLA_alpha = cat(2,all_VLA_alpha,spec_loc(i).alpha_cue);
    all_VLA_b1 = cat(2,all_VLA_b1,spec_loc(i).b1_cue);
    all_VLA_b2 = cat(2,all_VLA_b2,spec_loc(i).b2_cue);
    all_VLA_gamma = cat(2,all_VLA_gamma,spec_loc(i).gamma_cue);    
    all_VLA_hg = cat(2,all_VLA_hg,spec_loc(i).hg_cue);   
     
end
VLA_delta_avg = mean(all_VLA_delta,2);
VLA_theta_avg = mean(all_VLA_theta,2);
VLA_alpha_avg = mean(all_VLA_alpha,2);
VLA_b1_avg = mean(all_VLA_b1,2);
VLA_b2_avg = mean(all_VLA_b2,2);
VLA_gamma_avg = mean(all_VLA_gamma,2);
VLA_hg_avg = mean(all_VLA_hg,2);


VP_idx = find(strcmp({'VP'},loc_category));



all_VP_delta = [];
all_VP_theta = [];
all_VP_alpha = [];
all_VP_b1 = [];
all_VP_b2 = [];
all_VP_gamma = [];
all_VP_hg = [];
for i = VP_idx;

    all_VP_delta = cat(2,all_VP_delta,spec_loc(i).delta_cue);
    all_VP_theta = cat(2,all_VP_theta,spec_loc(i).theta_cue);    
    all_VP_alpha = cat(2,all_VP_alpha,spec_loc(i).alpha_cue);
    all_VP_b1 = cat(2,all_VP_b1,spec_loc(i).b1_cue);    
    all_VP_b2 = cat(2,all_VP_b2,spec_loc(i).b2_cue);
    all_VP_gamma = cat(2,all_VP_gamma,spec_loc(i).gamma_cue);
    all_VP_hg = cat(2,all_VP_hg,spec_loc(i).hg_cue);
end
VP_delta_avg = mean(all_VP_delta,2);
VP_theta_avg = mean(all_VP_theta,2);
VP_alpha_avg = mean(all_VP_alpha,2);
VP_b1_avg = mean(all_VP_b1,2);
VP_b2_avg = mean(all_VP_b2,2);
VP_gamma_avg = mean(all_VP_gamma,2);
VP_hg_avg = mean(all_VP_hg,2);


figure;
plot(VLA_delta_avg);hold on;plot(VLP_delta_avg);plot(VP_delta_avg);
figure;
plot(VLA_theta_avg);hold on;plot(VLP_theta_avg);plot(VP_theta_avg);
figure;
plot(VLA_alpha_avg);hold on;plot(VLP_alpha_avg);plot(VP_alpha_avg);
figure;
plot(VLA_b1_avg);hold on;plot(VLP_b1_avg);plot(VP_b1_avg);
figure;
plot(VLA_b2_avg);hold on;plot(VLP_b2_avg);plot(VP_b2_avg);
figure;
plot(VLA_gamma_avg);hold on;plot(VLP_gamma_avg);plot(VP_gamma_avg);
figure;
plot(VLA_hg_avg);hold on;plot(VLP_hg_avg);plot(VP_hg_avg);