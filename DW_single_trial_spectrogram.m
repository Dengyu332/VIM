
DW_machine;
load([dionysis,'Users/dwang/VIM/datafiles/processed_data/single_trial_b1ttest.mat']);


tp = linspace(-3,3,6000);

 
 %smoothing

 
 
 for total_contact_idx = 1:58;
     clear smooth_result
     
     for trial_idx = 1:size(sorted_sgtrial(total_contact_idx).sorted_hg,2);
         smooth_result(trial_idx,:) = smooth(sorted_sgtrial(total_contact_idx).sorted_hg(:,trial_idx),200);
     end
     
     figure(total_contact_idx);
     hh(total_contact_idx) = imagesc(tp,1:size(sorted_sgtrial(total_contact_idx).sorted_hg,2),smooth_result); set(gca, 'YDir', 'Normal');
     c = jet; new_cm = c; new_cm(1:5,:)  = []; colormap(new_cm);
     caxis([-2,3]);
 end
 
 
  for total_contact_idx = 1:58;
     clear smooth_result
     
     for trial_idx = 1:size(sorted_sgtrial(total_contact_idx).sorted_b1,2);
         smooth_result(trial_idx,:) = smooth(sorted_sgtrial(total_contact_idx).sorted_b1(:,trial_idx),200);
     end
     
     figure(total_contact_idx);
     mm(total_contact_idx) = imagesc(tp,1:size(sorted_sgtrial(total_contact_idx).sorted_b1,2),smooth_result); set(gca, 'YDir', 'Normal');
     c = jet; new_cm = c; new_cm(1:5,:)  = []; colormap(new_cm);
     caxis([-2,3]);
  end