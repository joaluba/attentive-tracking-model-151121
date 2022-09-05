function varargout=plotmyspectrogram(sig,fs, titlestr)
% This function plots a spectrogram of a signal
% ---------- Input: ------------
% sig - signal in time domain
% fs - sampling frequency
% titlestr   - title string 
% ---------- Output: ------------
% varargout{1} - matrix representing a signal in STFT domain
% varargout{2} - vector with frequencies
% varargout{2} - vector with time instances
% ----------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

% parameters of the short time analysis
FrameLength=20;
FrameShift=20;
% create overlapping windows
[matFrames, v_time]= myWindowing(sig,fs,FrameLength,FrameShift);
% fft size
N=size(matFrames,1); 
FFTLength=N*4;
% create analysis window
win_hann= hann(N,'periodic');
vAnalysisWindow=sqrt(win_hann);
% transform to STFT domain
[matSTFT, v_freq] = mySTFT(matFrames, fs, FFTLength, vAnalysisWindow);
% log magnitude short time spectrum 
OUTIM=10*log10(max(abs(matSTFT).^2,10^(-50)));

% plot:
colormap(gray)
imagesc(v_time,v_freq,flipud(OUTIM));
title({'log magnitude spectrogram'; titlestr})
title(titlestr)
xlabel('time [s]')
ylabel('frequency [Hz]')
yticks(v_freq(1:100:end));
yticklabels(fliplr(v_freq(1:100:end)));

% add vertical line at a given time instance: 
% hold on 
% vline(sig_time(24),'r','n=24')

% output arguments 
varargout{1}=abs(matSTFT);
varargout{2}=v_freq;
varargout{3}=v_time;

end