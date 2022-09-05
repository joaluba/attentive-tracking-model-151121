function [matSTFT, vFreq] = mySTFT(matFrames, SamplingRate, FFTLength, vAnalysisWindow)
% function to compute Short time fourier transform of the signal
% ---------- Input: ------------
% matFrames - overlapping signal frames (myWindowing.m)
% SamplingRate -  sampling rate in Hz
% FFTLength - number of DTF samplings points
% vAnalysisWindow - analysis window (should have the same length as the blocks in matFrames)
% ---------- Output: ------------
% matSTFT - matrix with complex short-time spectra 
% vFreq - vector with frequency in Hz corresponding to computed spectra
% -----------------------------------------------------------------------------
% Joanna Luberadzka 2016

vFreq = SamplingRate/2*linspace(0,1,FFTLength/2+1);

matSTFT=zeros((FFTLength/2)+1,size(matFrames,2));
for i=1:size(matFrames,2);
    v_block=matFrames(:,i);
    v_block_win=v_block.*vAnalysisWindow;
    v_fft= fft(v_block_win,FFTLength);
    matSTFT(:,i)=v_fft(1:round(length(v_fft)/2)+1); % half of the spectrum stored in each column  
end
end



