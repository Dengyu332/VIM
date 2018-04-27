clearvars -except Results;

DW_machine;

load([dionysis,'Users/dwang/VIM/datafiles/processed_data/Processed_all1.mat']); % referenced
Results1 = Results;
load([dionysis,'Users/dwang/VIM/datafiles/processed_data/Processed_all2.mat']); % non-referenced
Results2 = Results;

Session_info = readtable([dionysis,'Users/dwang/VIM/datafiles/Docs/Session_info.xlsx']);
cd([dionysis,'Users/dwang/VIM/datafiles/processed_data']);

% four example sessions. 1 9 15 28, for both CAR and non-CAR

% signal trial time series 20th trial of each session
figure; plot(Results2(1).Lead_LFP{20}(1,:)); hold on; plot(Results1(1).Lead_LFP{20}(1,:))

figure; plot(Results2(9).Lead_LFP{20}(1,:)); hold on; plot(Results1(9).Lead_LFP{20}(1,:))

figure; plot(Results2(15).Lead_LFP{20}(1,:)); hold on; plot(Results1(15).Lead_LFP{20}(1,:))

figure; plot(Results2(28).Lead_LFP{20}(1,:)); hold on; plot(Results1(28).Lead_LFP{20}(1,:))

%single trial FFT   20th trial of each session
fs = 1000;
L = length(Results2(1).Lead_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results2(1).Lead_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results1(1).Lead_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results1(1).Lead_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results2(9).Lead_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results2(9).Lead_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results1(9).Lead_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results1(9).Lead_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results2(15).Lead_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results2(15).Lead_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results1(15).Lead_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results1(15).Lead_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results2(28).Lead_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results2(28).Lead_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results1(28).Lead_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results1(28).Lead_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));


%single trial spectrogram  20th trial of each session
fq = 2:2:200;
fs = 1000;

input = [];
input{1,1} = abs(DW_fast_wavtransform(fq,Results2(1).Lead_LFP{20}(1,:),fs, 7));
input{1,2} = abs(DW_fast_wavtransform(fq,Results1(1).Lead_LFP{20}(1,:),fs, 7));
input{2,1} = abs(DW_fast_wavtransform(fq,Results2(9).Lead_LFP{20}(1,:),fs, 7));
input{2,2} = abs(DW_fast_wavtransform(fq,Results1(9).Lead_LFP{20}(1,:),fs, 7));
input{3,1} = abs(DW_fast_wavtransform(fq,Results2(15).Lead_LFP{20}(1,:),fs, 7));
input{3,2} = abs(DW_fast_wavtransform(fq,Results1(15).Lead_LFP{20}(1,:),fs, 7));
input{4,1} = abs(DW_fast_wavtransform(fq,Results2(28).Lead_LFP{20}(1,:),fs, 7));
input{4,2} = abs(DW_fast_wavtransform(fq,Results1(28).Lead_LFP{20}(1,:),fs, 7));

for fig_idx = 1:8;
    figure(fig_idx);
    img_dbs = imagesc(1:length(input{fig_idx}), fq, input{fig_idx}');set(gca, 'YDir', 'Normal');
    min(input{fig_idx}(:))
    max(input{fig_idx}(:))
    prctile(input{fig_idx}(:),90);
    colormap jet; caxis([prctile(input{fig_idx}(:),10),prctile(input{fig_idx}(:),90)])
end


% time series average across trial, sp_onset aligned

% -3 to 3 peri sp onset

session_used = [1:28];
fs = 1000;
for session_id = session_used;
    sp_onset_idx_i = num2cell(round((Results2(session_id).annot.coding.onset_word - Results2(session_id).annot.coding.starts)*fs));

    sp_center_trials_i =cellfun(@(x,y) x(1,y-3*fs:y+3*fs),Results2(session_id).Lead_LFP,sp_onset_idx_i','UniformOutput',0);
    sp_mean_i = mean(cell2mat(reshape(sp_center_trials_i,[1,1,length(sp_center_trials_i)])),3);
    figure(session_id); plot(sp_mean_i);
end

session_used = [1:28];
fs = 1000;
for session_id = session_used;
    sp_onset_idx_i = num2cell(round((Results1(session_id).annot.coding.onset_word - Results1(session_id).annot.coding.starts)*fs));

    sp_center_trials_i =cellfun(@(x,y) x(1,y-3*fs:y+3*fs),Results1(session_id).Lead_LFP,sp_onset_idx_i','UniformOutput',0);
    sp_mean_i = mean(cell2mat(reshape(sp_center_trials_i,[1,1,length(sp_center_trials_i)])),3);
    figure(session_id);hold on; plot(sp_mean_i);
end    
    

%% macrolfp

% four example sessions. 1 5 9 14, for both CAR and non-CAR

% signal trial time series 20th trial of each session
figure; plot(Results2(1).Macro_LFP{20}(1,:)); hold on; plot(Results1(1).Macro_LFP{20}(1,:))

figure; plot(Results2(5).Macro_LFP{20}(1,:)); hold on; plot(Results1(5).Macro_LFP{20}(1,:))

figure; plot(Results2(9).Macro_LFP{20}(1,:)); hold on; plot(Results1(9).Macro_LFP{20}(1,:))

figure; plot(Results2(14).Macro_LFP{20}(1,:)); hold on; plot(Results1(14).Macro_LFP{20}(1,:))



%single trial FFT   20th trial of each session
fs = 1000;
L = length(Results2(1).Macro_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results2(1).Macro_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results1(1).Macro_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results1(1).Macro_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results2(5).Macro_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results2(5).Macro_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results1(5).Macro_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results1(5).Macro_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results2(9).Macro_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results2(9).Macro_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results1(9).Macro_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results1(9).Macro_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results2(14).Macro_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results2(14).Macro_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

fs = 1000;
L = length(Results1(14).Macro_LFP{20}(1,:));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Results1(14).Macro_LFP{20}(1,:),NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
hold on; plot(f, log(smooth(2*abs(Y(1:NFFT/2+1)),20)));

% time series average across trial, sp_onset aligned

% -3 to 3 peri sp onset

session_used = [1:6,9:14];
fs = 1000;
for session_id = session_used;
    sp_onset_idx_i = num2cell(round((Results2(session_id).annot.coding.onset_word - Results2(session_id).annot.coding.starts)*fs));

    sp_center_trials_i =cellfun(@(x,y) x(1,y-3*fs:y+3*fs),Results2(session_id).Macro_LFP,sp_onset_idx_i','UniformOutput',0);
    sp_mean_i = mean(cell2mat(reshape(sp_center_trials_i,[1,1,length(sp_center_trials_i)])),3);
    figure(session_id);hold on; plot(sp_mean_i);
end

session_used = [1:6,9:14];
fs = 1000;
for session_id = session_used;
    sp_onset_idx_i = num2cell(round((Results1(session_id).annot.coding.onset_word - Results1(session_id).annot.coding.starts)*fs));

    sp_center_trials_i =cellfun(@(x,y) x(2,y-3*fs:y+3*fs),Results1(session_id).Macro_LFP,sp_onset_idx_i','UniformOutput',0);
    sp_mean_i = mean(cell2mat(reshape(sp_center_trials_i,[1,1,length(sp_center_trials_i)])),3);
    figure(session_id);hold on; plot(sp_mean_i);
end    
    