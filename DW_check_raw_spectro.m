% test the raw condition of each channel in D.mat file

% first load in D for a subject

for Session_idx = 1:length(D.trial);
    close all;
    for ch_idx = 1:size(D.trial{Session_idx},1);
        
        figure (ch_idx);
        
        fs = 1000;
        
        L = length(D.trial{Session_idx}(ch_idx,:));
        
        NFFT = 2^nextpow2(L); % Next power of 2 from length of y, use to enhance fft performance

        Y = fft(D.trial{Session_idx}(ch_idx,:),NFFT);
        
        f = fs/2*linspace(0,1,NFFT/2+1);
        P = abs(Y/NFFT);
        
        plot(f, log(smooth(2*P(1:NFFT/2+1),20)));
        ylim([-10,4])
    end
    pause;
end