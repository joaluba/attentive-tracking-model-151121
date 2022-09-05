function signoise_bin=addnoise2sig(sig_bin,sConfNG)
% Function to set levels and add noise to the signal (if required)
% ---- Input: -----
% sig_bin - signal with 2 channels
% sConfNG - config struct for noise generation
% render - type of rendering in tascar 
% ---- Output: -----
% signoise_bin - 2-channel signal with adjusted level and noise added
% -------------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

% load noise file
[noise_bin, fs_noise]=audioread(sConfNG.noisefile);
% check if it has two channels
if any(size(noise_bin)==1)
    noise_bin=[noise_bin noise_bin];
end
% resample noise to fs of the sig
noise_bin=resample(noise_bin,sConfNG.fs,fs_noise);
% cut or extend the noise to fit the sig
noise_bin=repmat(noise_bin,ceil(length(sig_bin)/length(noise_bin)));
noise_bin=noise_bin(1:length(sig_bin),:);
% add noise
if sConfNG.SNR==Inf
    sig_bin=set_level(sig_bin,60);
    signoise_bin=sig_bin;
elseif sConfNG.SNR==-Inf
    noise_bin=set_level(noise_bin,60);
    signoise_bin=noise_bin;
else
    sig_bin=set_level(sig_bin,60);
    noise_bin=set_level(noise_bin,60-confN.SNR);
    signoise_bin=sig_bin+noise_bin;
end

end