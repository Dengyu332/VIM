% First created on 10/19/2018

% takes in files in
% VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity/,
% generate figures for each of them

DW_machine;
data_dir = dir([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/contact_band_activity/' ...
    '*.mat']);
for file_id = 1:length(data_dir)
    clearvars -except data_dir dionysis dropbox file_id
    % load in file oi
    load([data_dir(file_id).folder filesep data_dir(file_id).name])
    
    % using exist() function to determine the file type
    
    if exist('avg_word_off') == 0 % indicating contacts of 13 - 18, which has only cuect figure, without any timing
        % data processing: smooth with rlowess, 200ms window, then 4hz resampling
        z_s = smoothdata(z, 'rlowess',200);
        z_sd = resample(z_s, 4, 1000);
        
        figure; plot(-1.5:0.25:2.5, z_sd);
        h_ax = gca;
        set(h_ax,'XTick',-1.5:0.5:2.5);
        set(h_ax,'box','on');
        set(h_ax,'TickLength',[0.005,0.005]);
        xlabel(h_ax,'Time (s)');
        ylabel(h_ax,'z-score');
        
        hold on;plot([0,0], ylim, 'k--');
        saveas(gcf, [dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/contact_band_plot/'...
            data_dir(file_id).name(1:end-4)]);
        close all
    else
        z_s = smoothdata(z, 'rlowess',200);
        z_sd = resample(z_s, 4, 1000);
        
        if exist('avg_cue_on') == 0
            
            figure; plot(-1.5:0.25:2.5, z_sd);
            h_ax = gca;
            set(h_ax,'XTick',-1.5:0.5:2.5);
            set(h_ax,'box','on');
            set(h_ax,'TickLength',[0.005,0.005]);
            xlabel(h_ax,'Time (s)');
            ylabel(h_ax,'z-score');    
            
            hold on;plot([0,0], ylim, 'k--');plot([avg_word_on,avg_word_on],ylim, 'k--');...
                plot([0,0], ylim, 'k--');plot([avg_word_off,avg_word_off],ylim, 'k--');
            
            saveas(gcf, [dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/contact_band_plot/'...
            data_dir(file_id).name(1:end-4)]);
            close all            
            
        elseif exist('avg_word_on') == 0
            
            figure; plot(-2:0.25:2, z_sd);
            h_ax = gca;
            set(h_ax,'XTick',-2:0.5:2);
            set(h_ax,'box','on');
            set(h_ax,'TickLength',[0.005,0.005]);
            xlabel(h_ax,'Time (s)');
            ylabel(h_ax,'z-score');  
            
            hold on;plot([0,0], ylim, 'k--');plot([avg_cue_on,avg_cue_on],ylim, 'k--');...
                plot([0,0], ylim, 'k--');plot([avg_word_off,avg_word_off],ylim, 'k--');  
            
            saveas(gcf, [dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/contact_band_plot/'...
                data_dir(file_id).name(1:end-4)]);
            close all            
            
        else % locked to vowel
            
            figure; plot(-2:0.25:2, z_sd);
            h_ax = gca;
            set(h_ax,'XTick',-2:0.5:2);
            set(h_ax,'box','on');
            set(h_ax,'TickLength',[0.005,0.005]);
            xlabel(h_ax,'Time (s)');
            ylabel(h_ax,'z-score');  
            
            hold on;plot([0,0], ylim, 'k--');plot([avg_cue_on,avg_cue_on],ylim, 'k--');...
                plot([0,0], ylim, 'k--');plot([avg_word_off,avg_word_off],ylim, 'k--');
            saveas(gcf, [dionysis 'Users/dwang/VIM/Results/New/v2/WordVsNonword/contact_band_plot/'...
                data_dir(file_id).name(1:end-4)]);
            close all 
        end
    end
end