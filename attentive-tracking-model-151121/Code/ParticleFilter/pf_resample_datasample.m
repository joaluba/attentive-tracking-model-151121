function sParticles_out=pf_resample_datasample(sConfPF,sParticles_in,O)
% Function defining a requirement for resampling a particle filter: 
% Number of effective particles exceeds a defined threshold
% ----------- Input: ------------
% sConfPF - config struct of a particle filter 
% sParticles - current particles
% O - current sPAF features
% ----------- Output: ------------
% sParticles_resampled - resampled particles
% --------------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

sParticles_out.H= datasample(sParticles_in.H,sConfPF.K,2,'Weights',sParticles_in.W);
sParticles_out.W=ones(1,sConfPF.K)./sConfPF.K;
    
end