%% % follow DW_batch_CAR; takes in step3 data files
%generate spectrogram for each subcortical contact
%%
%specify machine
DW_machine;
% data sampling frequency and spectral gradient (fq)
fs = 1000;
fq = 2:2:200;

%read in subject list
Subject_list = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Subject_list.xlsx']);
Subject_list([2,4],:) =[]; % DBS4043 no subcortical recordings; % 4039 not processed yet

% make a list of subjects who have contacts that record for two sessions
list_of_duplicate = {'DBS4049','DBS4051','DBS4052','DBS4053','DBS4054','DBS4055','DBS4056'};

contact_id = 0;
for Subject_idx = 1:height(Subject_list)
    Subject_id = cell2mat(Subject_list.Subject_id(Subject_idx));
    
    if ~any(strcmp(list_of_duplicate,Subject_id)) % dealing with simple subjects
        
        data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' Subject_id '_*_step3.mat']);
        %data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id '/subcort/*_step3.mat']); % v1
        
        for which_session = 1:length(data_dir) % deal with one session at a time
            load([data_dir(which_session).folder filesep data_dir(which_session).name]);% load in data of step3 session oi
            % 1st: remove bad trials
            D1 = D;
            D1.trial(:,D1.badtrial_final) = [];
            D1.time(D1.badtrial_final) = [];
            D1.epoch(D1.badtrial_final,:) = [];
                        %% ref + cue centered
            % amplitude 
            signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),D1.trial(2,:),'UniformOutput',0); % use referenced data
            
            % time X fq X ch                        
            %center on cue onset, -1.5 to + 2.5
            roi_starts = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) - 1.5*fs)';
            roi_ends = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) + 2.5*fs)';
            signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
            % average sinal_roi across trial
            avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
            avg_signal_roi = mean(avg_signal_roi,4);
            base = avg_signal_roi(501:1500,:,:); % 1s prior to cue onset as baseline
            z2 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
            ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
            avg_word_on2 = mean(D1.epoch.onset_word - D1.epoch.stimulus_starts);
            avg_word_off2 = mean(D1.epoch.offset_word - D1.epoch.stimulus_starts);   
            %% ref + word onset centered
            %center on word onset, -2 to + 2
            roi_starts = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) - 2*fs)';
            roi_ends = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) + 2*fs)';
            signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
            % average sinal_roi across trial
            avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
            avg_signal_roi = mean(avg_signal_roi,4); 
            
            z1 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
            ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
            avg_cue = mean(D1.epoch.stimulus_starts - D1.epoch.onset_word);
            avg_word_off = mean(D1.epoch.offset_word - D1.epoch.onset_word);
            
             %% unref + cue centered
            
            % amplitude 
            signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),D1.trial(1,:),'UniformOutput',0); % use unreferenced data
            % time X fq X ch
            
            %center on cue onset, -1.5 to + 2.5
            roi_starts = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) - 1.5*fs)';
            roi_ends = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) + 2.5*fs)';
            signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
            % average sinal_roi across trial
            avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
            avg_signal_roi = mean(avg_signal_roi,4);
            base = avg_signal_roi(501:1500,:,:); % 1s prior to cue onset as baseline            
            z4 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
            ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
            avg_word_on4 = mean(D1.epoch.onset_word - D1.epoch.stimulus_starts);
            avg_word_off4 = mean(D1.epoch.offset_word - D1.epoch.stimulus_starts);   
            
            %% unref + word onset centered 
            %center on word onset, -2 to + 2
            roi_starts = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) - 2*fs)';
            roi_ends = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) + 2*fs)';
            signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
            % average sinal_roi across trial
            avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
            avg_signal_roi = mean(avg_signal_roi,4);
            z3 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
            ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
            avg_cue3 = mean(D1.epoch.stimulus_starts - D1.epoch.onset_word);
            avg_word_off3 = mean(D1.epoch.offset_word - D1.epoch.onset_word);
            

            
            % we get z1-z4, each corresponding to one condition
        for ch_idx = 1:size(z1,3)
            contact_id = contact_id + 1;
            if contact_id > 12
                contact_id_used = contact_id + 6;
            else
                contact_id_used = contact_id;
            end
            z1_oi = z1(:,:,ch_idx);
            z2_oi = z2(:,:,ch_idx);
            z3_oi = z3(:,:,ch_idx);
            z4_oi = z4(:,:,ch_idx);
            
            readme1 = 'referenced, word onset centered, -2 to 2 peri word onset, 1s prior to cue as baseline';
            readme2 = 'referenced, cue onset centered, -1.5 to 2.5 peri cue onset, 1s prior to cue as baseline';
            readme3 = 'unreferenced, word onset centered, -2 to 2 peri word onset, 1s prior to cue as baseline';
            readme4 = 'unreferenced, cue onset centered, -1.5 to 2.5 peri cue onset, 1s prior to cue as baseline';
            
            save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id_used) '_ref_spct.mat'],'z1_oi','avg_cue','avg_word_off','readme1');
            save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id_used) '_ref_cuect.mat'],'z2_oi','avg_word_on2','avg_word_off2','readme2');
            save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id_used) '_unref_spct.mat'],'z3_oi','avg_cue3','avg_word_off3','readme3');
            save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id_used) '_unref_cuect.mat'],'z4_oi','avg_word_on4','avg_word_off4','readme4');
            
            % z1
            figure; colormap(jet)
            
            t=linspace(-2,2,size(z1,1));
            imagesc(t, fq, z1(:,:,ch_idx)');set(gca, 'YDir', 'Normal');
            
            caxis([-10,10]); box off;% remove upper and right lines
            
            hold on; plot([avg_cue,avg_cue],ylim,'k--');
            plot([0,0],ylim,'k--'); 
            plot([avg_word_off,avg_word_off],ylim,'k--');
            
            xlabel('Time (s)'); % x-axis label
            ylabel('Frequency (Hz)'); % y-axis label
            
            saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
                'contact_' num2str(contact_id_used) '_ref_spct','fig']);
            close all;
            
        % z2
            figure; colormap(jet)
            
            t=linspace(-1.5,2.5,size(z2,1));
            imagesc(t, fq, z2(:,:,ch_idx)');set(gca, 'YDir', 'Normal');
            
            caxis([-10,10]); box off;% remove upper and right lines
            
            hold on; plot([avg_word_on2,avg_word_on2],ylim,'k--');
            plot([0,0],ylim,'k--'); 
            plot([avg_word_off2,avg_word_off2],ylim,'k--');
            
            xlabel('Time (s)'); % x-axis label
            ylabel('Frequency (Hz)'); % y-axis label
            
            saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
                'contact_' num2str(contact_id_used) '_ref_cuect','fig']);
            close all;
            
        % z3
            figure; colormap(jet)
            
            t=linspace(-2,2,size(z3,1));
            imagesc(t, fq, z3(:,:,ch_idx)');set(gca, 'YDir', 'Normal');
            
            caxis([-10,10]); box off;% remove upper and right lines
            
            hold on; plot([avg_cue3,avg_cue3],ylim,'k--');
            plot([0,0],ylim,'k--'); 
            plot([avg_word_off3,avg_word_off3],ylim,'k--');
            
            xlabel('Time (s)'); % x-axis label
            ylabel('Frequency (Hz)'); % y-axis label
            
            saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
                'contact_' num2str(contact_id_used) '_unref_spct','fig']);
            close all;    
            
        % z4
            figure; colormap(jet)
            
            t=linspace(-1.5,2.5,size(z4,1));
            imagesc(t, fq, z4(:,:,ch_idx)');set(gca, 'YDir', 'Normal');
            
            caxis([-10,10]); box off;% remove upper and right lines
            
            hold on; plot([avg_word_on4,avg_word_on4],ylim,'k--');
            plot([0,0],ylim,'k--'); 
            plot([avg_word_off4,avg_word_off4],ylim,'k--');
            
            xlabel('Time (s)'); % x-axis label
            ylabel('Frequency (Hz)'); % y-axis label
            
            saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
                'contact_' num2str(contact_id_used) '_unref_cuect','fig']);
            close all;            
        
            disp(['contact_' num2str(contact_id_used)]);
        end
        end
    else % for lead recording subjects, merging two session's left side recording
        
        %v2
        data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/subcort/' Subject_id '_*_step3.mat']);
        
        %data_dir = dir([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/' Subject_id '/subcort/*_step3.mat']); % v1
        
        load([data_dir(1).folder filesep data_dir(1).name]);% load in data of step3 of session 1
        D1 = D;
        load([data_dir(2).folder filesep data_dir(2).name]);% load in data of step3 of session 2
        D2 = D;
        
        
        % remove bad trials
        D1.trial(:,D1.badtrial_final) = [];
        D1.time(D1.badtrial_final) = [];
        D1.epoch(D1.badtrial_final,:) = [];        
        
        D2.trial(:,D2.badtrial_final) = [];
        D2.time(D2.badtrial_final) = [];
        D2.epoch(D2.badtrial_final,:) = [];
        
        %% get left recording and right recording, seperately
        D_left.trial = [D1.trial,cellfun(@(x) x(1:4,:),D2.trial,'UniformOutput',0)];
        D_left.time = [D1.time,D2.time];
        D_left.epoch = [D1.epoch;D2.epoch];
        
        D_right.trial = cellfun(@(x) x(5:8,:),D2.trial,'UniformOutput',0);
        D_right.time = D2.time;
        D_right.epoch = D2.epoch;
        clearvars D D1 D2;
        
        for D1 = [D_left,D_right]
                        %% ref + cue centered
            % amplitude 
            signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),D1.trial(2,:),'UniformOutput',0); % use referenced data
            
            % time X fq X ch                        
            %center on cue onset, -1.5 to + 2.5
            roi_starts = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) - 1.5*fs)';
            roi_ends = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) + 2.5*fs)';
            signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
            % average sinal_roi across trial
            avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
            avg_signal_roi = mean(avg_signal_roi,4);
            base = avg_signal_roi(501:1500,:,:); % 1s prior to cue onset as baseline
            z2 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
            ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
            avg_word_on2 = mean(D1.epoch.onset_word - D1.epoch.stimulus_starts);
            avg_word_off2 = mean(D1.epoch.offset_word - D1.epoch.stimulus_starts);   
            %% ref + word onset centered
            %center on word onset, -2 to + 2
            roi_starts = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) - 2*fs)';
            roi_ends = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) + 2*fs)';
            signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
            % average sinal_roi across trial
            avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
            avg_signal_roi = mean(avg_signal_roi,4); 
            
            z1 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
            ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
            avg_cue = mean(D1.epoch.stimulus_starts - D1.epoch.onset_word);
            avg_word_off = mean(D1.epoch.offset_word - D1.epoch.onset_word);
            
             %% unref + cue centered
            
            % amplitude 
            signal = cellfun(@(x) abs(DW_fast_wavtransform(fq, x,fs, 7)),D1.trial(1,:),'UniformOutput',0); % use unreferenced data
            % time X fq X ch
            
            %center on cue onset, -1.5 to + 2.5
            roi_starts = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) - 1.5*fs)';
            roi_ends = num2cell(round(fs*(D1.epoch.stimulus_starts - D1.epoch.starts)) + 2.5*fs)';
            signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
            % average sinal_roi across trial
            avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
            avg_signal_roi = mean(avg_signal_roi,4);
            base = avg_signal_roi(501:1500,:,:); % 1s prior to cue onset as baseline            
            z4 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
            ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
            avg_word_on4 = mean(D1.epoch.onset_word - D1.epoch.stimulus_starts);
            avg_word_off4 = mean(D1.epoch.offset_word - D1.epoch.stimulus_starts);   
            
            %% unref + word onset centered 
            %center on word onset, -2 to + 2
            roi_starts = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) - 2*fs)';
            roi_ends = num2cell(round(fs*(D1.epoch.onset_word - D1.epoch.starts)) + 2*fs)';
            signal_roi =  cellfun(@(x,y,z) x(y:z,:,:),signal,roi_starts,roi_ends,'UniformOutput',0);
            % average sinal_roi across trial
            avg_signal_roi = cell2mat(reshape(signal_roi,[1,1,1,size(signal_roi,2)]));
            avg_signal_roi = mean(avg_signal_roi,4);
            z3 = (avg_signal_roi - repmat(mean(base,1),[length(avg_signal_roi),1]))...
            ./repmat(std(base,0,1),[length(avg_signal_roi),1]);
        %
            avg_cue3 = mean(D1.epoch.stimulus_starts - D1.epoch.onset_word);
            avg_word_off3 = mean(D1.epoch.offset_word - D1.epoch.onset_word);
            
            % we get z1-z4, each corresponding to one condition
            
            for ch_idx = 1:size(z1,3)
                contact_id = contact_id + 1;
                if contact_id > 12
                    contact_id_used = contact_id + 6;
                else
                    contact_id_used = contact_id;
                end
                
                z1_oi = z1(:,:,ch_idx);
                z2_oi = z2(:,:,ch_idx);
                z3_oi = z3(:,:,ch_idx);
                z4_oi = z4(:,:,ch_idx);

                readme1 = 'referenced, word onset centered, -2 to 2 peri word onset, 1s prior to cue as baseline';
                readme2 = 'referenced, cue onset centered, -1.5 to 2.5 peri cue onset, 1s prior to cue as baseline';
                readme3 = 'unreferenced, word onset centered, -2 to 2 peri word onset, 1s prior to cue as baseline';
                readme4 = 'unreferenced, cue onset centered, -1.5 to 2.5 peri cue onset, 1s prior to cue as baseline';

                save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id_used) '_ref_spct.mat'],'z1_oi','avg_cue','avg_word_off','readme1');
                save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id_used) '_ref_cuect.mat'],'z2_oi','avg_word_on2','avg_word_off2','readme2');
                save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id_used) '_unref_spct.mat'],'z3_oi','avg_cue3','avg_word_off3','readme3');
                save([dionysis,'Users/dwang/VIM/datafiles/preprocessed_new/v2/contact_level_spectrogram/' 'contact_' num2str(contact_id_used) '_unref_cuect.mat'],'z4_oi','avg_word_on4','avg_word_off4','readme4');

                % z1
                figure; colormap(jet)

                t=linspace(-2,2,size(z1,1));
                imagesc(t, fq, z1(:,:,ch_idx)');set(gca, 'YDir', 'Normal');

                caxis([-10,10]); box off;% remove upper and right lines

                hold on; plot([avg_cue,avg_cue],ylim,'k--');
                plot([0,0],ylim,'k--'); 
                plot([avg_word_off,avg_word_off],ylim,'k--');

                xlabel('Time (s)'); % x-axis label
                ylabel('Frequency (Hz)'); % y-axis label

                saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
                    'contact_' num2str(contact_id_used) '_ref_spct','fig']);
                close all;

            % z2
                figure; colormap(jet)

                t=linspace(-1.5,2.5,size(z2,1));
                imagesc(t, fq, z2(:,:,ch_idx)');set(gca, 'YDir', 'Normal');

                caxis([-10,10]); box off;% remove upper and right lines

                hold on; plot([avg_word_on2,avg_word_on2],ylim,'k--');
                plot([0,0],ylim,'k--'); 
                plot([avg_word_off2,avg_word_off2],ylim,'k--');

                xlabel('Time (s)'); % x-axis label
                ylabel('Frequency (Hz)'); % y-axis label

                saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
                    'contact_' num2str(contact_id_used) '_ref_cuect','fig']);
                close all;

            % z3
                figure; colormap(jet)

                t=linspace(-2,2,size(z3,1));
                imagesc(t, fq, z3(:,:,ch_idx)');set(gca, 'YDir', 'Normal');

                caxis([-10,10]); box off;% remove upper and right lines

                hold on; plot([avg_cue3,avg_cue3],ylim,'k--');
                plot([0,0],ylim,'k--'); 
                plot([avg_word_off3,avg_word_off3],ylim,'k--');

                xlabel('Time (s)'); % x-axis label
                ylabel('Frequency (Hz)'); % y-axis label

                saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
                    'contact_' num2str(contact_id_used) '_unref_spct','fig']);
                close all;    

            % z4
                figure; colormap(jet)

                t=linspace(-1.5,2.5,size(z4,1));
                imagesc(t, fq, z4(:,:,ch_idx)');set(gca, 'YDir', 'Normal');

                caxis([-10,10]); box off;% remove upper and right lines

                hold on; plot([avg_word_on4,avg_word_on4],ylim,'k--');
                plot([0,0],ylim,'k--'); 
                plot([avg_word_off4,avg_word_off4],ylim,'k--');

                xlabel('Time (s)'); % x-axis label
                ylabel('Frequency (Hz)'); % y-axis label

                saveas(gcf,[dionysis,'Users/dwang/VIM/Results/New/v2/subcort_spectrogram/'...
                    'contact_' num2str(contact_id_used) '_unref_cuect','fig']);
                close all;            

                disp(['contact_' num2str(contact_id_used)]);
            end
        end
    end
end