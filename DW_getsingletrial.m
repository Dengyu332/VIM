%upstream script: DW_process.m; parellel script: DW_leadmeantrial.m

clearvars -except Results;
DW_machine;

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/Processed_lead.mat']);
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info_lead.xlsx']);
%filter load
load([dropbox,'Functions/Dengyu/Filter/bpFilt.mat']);

cd([dionysis,'Users/dwang/VIM/datafiles/processed_data']);
fs = 1000;

clear signal mean_trial
total_contact = 0;
for total_session_idx = 1:length(Results);
    clear signal
    disp(['processing',Session_info.Session_id{total_session_idx}])
    %x' because function applys to the first dimension
    % time X ch, out trials
    signal(total_session_idx).Lead_b1 = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    
    %event index: iti-start, cue_pre, onset_word, offset_word, respectively
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.ITI_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,4) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
    
    for contact_idx = 1:size(signal(total_session_idx).Lead_b1{1},2);
        total_contact = 1+total_contact;
        
        base_temp = cell2mat(cellfun(@(x,y) mean(x(y-750:y,contact_idx)),signal(total_session_idx).Lead_b1,signal(total_session_idx).event_idx(:,2)','UniformOutput',0));
        
        roi_temp = cell2mat(cellfun(@(x,y,z) mean(x(y:z,contact_idx)),signal(total_session_idx).Lead_b1,signal(total_session_idx).event_idx(:,2)',signal(total_session_idx).event_idx(:,4)','UniformOutput',0));
        
        pair{total_contact} = [base_temp;roi_temp];
    end
end


[h(:),p(:)] = cellfun(@(x) ttest2(x(1,:),x(2,:),'Tail','right','Alpha',0.01),pair,'UniformOutput',0);


diff = cell2mat(cellfun(@(x) mean(x(2,:),2) - mean(x(1,:),2),pair,'UniformOutput',0));



contact_used  = find(cell2mat(h)>0);



total_contact = 0;
real_idx = 0;
for total_session_idx = 1:length(Results);
    clear signal
    disp(['processing ',Session_info.Session_id{total_session_idx}])
    %x' because function applys to the first dimension
    % time X ch, out trials
    signal(total_session_idx).Lead_alpha = cellfun(@(x) abs(hilbert(filtfilt(alphaFilt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_b1 = cellfun(@(x) abs(hilbert(filtfilt(beta1Filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_b2 = cellfun(@(x) abs(hilbert(filtfilt(beta2Filt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_gamma = cellfun(@(x) abs(hilbert(filtfilt(gammaFilt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    signal(total_session_idx).Lead_hg = cellfun(@(x) abs(hilbert(filtfilt(hgammaFilt,x'))),Results(total_session_idx).Lead_LFP_ref,'UniformOutput',0);
    
    %event index: iti-start, cue_pre, onset_word, offset_word, respectively
    signal(total_session_idx).event_idx(:,1) = num2cell(round((Results(total_session_idx).annot.coding.ITI_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,2) = num2cell(round((Results(total_session_idx).annot.coding.stimulus_starts - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,3) = num2cell(round((Results(total_session_idx).annot.coding.onset_word - Results(total_session_idx).annot.coding.starts)*fs));
    signal(total_session_idx).event_idx(:,4) = num2cell(round((Results(total_session_idx).annot.coding.offset_word - Results(total_session_idx).annot.coding.starts)*fs));
    
    
    
    for contact_idx = 1:size(signal(total_session_idx).Lead_hg{1},2);
        total_contact = 1+total_contact;
    if ismember(total_contact,contact_used);
        clear ltcy_order sorted_sp_ltncy sp_latency base_temp z_temp z_roi z_matrix z_sorted
        
        real_idx = real_idx +1;
        
        sorted_sgtrial(real_idx).session_id = Results(total_session_idx).session;
        sorted_sgtrial(real_idx).which_contact = contact_idx;
        sorted_sgtrial(real_idx).Side = Session_info.Lead_Side(total_session_idx);
        
        sp_latency = (cell2mat(signal(total_session_idx).event_idx(:,3)) - cell2mat(signal(total_session_idx).event_idx(:,2)))';
        [sorted_sp_ltncy,ltcy_order] = sort(sp_latency,'ascend');
        
        sorted_sgtrial(real_idx).sorted_sp_ltncy = sorted_sp_ltncy;
        
        
    
        base_temp = cellfun(@(x,y) x(y-750:y,contact_idx),signal(total_session_idx).Lead_alpha,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_temp = cellfun(@(x,y) (x(:,contact_idx)-mean(y))./std(y),signal(total_session_idx).Lead_alpha,base_temp,'UniformOutput',0);
        z_roi = cellfun(@(x,y) x(y-3000+1:y+3000),z_temp,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_matrix = cell2mat(z_roi);
        z_sorted = z_matrix(:,ltcy_order);
        
        sorted_sgtrial(real_idx).sorted_alpha = z_sorted;
        
        base_temp = cellfun(@(x,y) x(y-750:y,contact_idx),signal(total_session_idx).Lead_b1,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_temp = cellfun(@(x,y) (x(:,contact_idx)-mean(y))./std(y),signal(total_session_idx).Lead_b1,base_temp,'UniformOutput',0);
        z_roi = cellfun(@(x,y) x(y-3000+1:y+3000),z_temp,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_matrix = cell2mat(z_roi);
        z_sorted = z_matrix(:,ltcy_order);
        
        sorted_sgtrial(real_idx).sorted_b1 = z_sorted;
        
        
        base_temp = cellfun(@(x,y) x(y-750:y,contact_idx),signal(total_session_idx).Lead_b2,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_temp = cellfun(@(x,y) (x(:,contact_idx)-mean(y))./std(y),signal(total_session_idx).Lead_b2,base_temp,'UniformOutput',0);
        z_roi = cellfun(@(x,y) x(y-3000+1:y+3000),z_temp,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_matrix = cell2mat(z_roi);
        z_sorted = z_matrix(:,ltcy_order);
        
        sorted_sgtrial(real_idx).sorted_b2 = z_sorted;        
        
        base_temp = cellfun(@(x,y) x(y-750:y,contact_idx),signal(total_session_idx).Lead_gamma,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_temp = cellfun(@(x,y) (x(:,contact_idx)-mean(y))./std(y),signal(total_session_idx).Lead_gamma,base_temp,'UniformOutput',0);
        z_roi = cellfun(@(x,y) x(y-3000+1:y+3000),z_temp,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_matrix = cell2mat(z_roi);
        z_sorted = z_matrix(:,ltcy_order);
        
        sorted_sgtrial(real_idx).sorted_gamma = z_sorted;          
        
        base_temp = cellfun(@(x,y) x(y-750:y,contact_idx),signal(total_session_idx).Lead_hg,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_temp = cellfun(@(x,y) (x(:,contact_idx)-mean(y))./std(y),signal(total_session_idx).Lead_hg,base_temp,'UniformOutput',0);
        z_roi = cellfun(@(x,y) x(y-3000+1:y+3000),z_temp,signal(total_session_idx).event_idx(:,2)','UniformOutput',0);
        z_matrix = cell2mat(z_roi);
        z_sorted = z_matrix(:,ltcy_order);
        
        sorted_sgtrial(real_idx).sorted_hg = z_sorted;        
        
    else
        
    end
    end
end
save('single_trial.mat','sorted_sgtrial','-v7.3');