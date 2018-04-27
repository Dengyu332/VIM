bml_defaults;
ft_defaults;
% set machine
DW_machine;
%read in session info
Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info.xlsx']);

for total_session_idx = 1:height(Session_info);
    
    
        disp(['processing ',Session_info.Session_id{total_session_idx}]);
    patient_id = Session_info.Session_id{total_session_idx}(1:7); % get patient id
    
    which_session = Session_info.Session_id{total_session_idx}(end); % get which session of this patient
    which_session = str2double(which_session);
    
    data_dir = dir([dionysis,'Electrophysiology_Data/DBS_Intraop_Recordings/',patient_id,'/Preprocessed Data/FieldTrip/*_ft_raw_session.mat']);
    cd(data_dir.folder);
    load([data_dir.folder,filesep,data_dir.name]); % load D.mat
    
    cue = bml_annot_read('annot/cue_presentation.txt');
    cue_oi = cue(find(cue.session_id == which_session),:)
    
    
    
    Lead_Side = Session_info.Lead_Side(total_session_idx);
    
    if strcmp('LR',Lead_Side);
        lead_ch = find(strcmp('dbs',cellfun(@(x) x(1:3),D.label,'UniformOutput',0)));
    else
        lead_temp = find(strcmp('dbs',cellfun(@(x) x(1:3),D.label,'UniformOutput',0)));
        lead_ch = lead_temp(1:4);
    end
    
    Lead_Label = D.label(lead_ch);
    
    for ch_idx = 1:length(lead_ch);
        
        
        
        figure (((ch_idx-1)*2+1));
        plot(D.time{which_session},D.trial{which_session}(lead_ch(ch_idx),:));
        hold on; plot([cue_oi.stimulus_starts,cue_oi.stimulus_starts],ylim,'k');
        
        
        Fs = 1000;
        L = length(D.trial{which_session}(lead_ch(ch_idx),:));
        NFFT = 2^nextpow2(L); % Next power of 2 from length of y
        Y = fft(D.trial{which_session}(lead_ch(ch_idx),:),NFFT)/L;
        f = Fs/2*linspace(0,1,NFFT/2+1);
        figure ((ch_idx*2)); plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));
        
    end
    a_c = input('??');
    close all;
    
    
    
end