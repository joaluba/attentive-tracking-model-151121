function sParticles_resampled= pf_when2res_Neff(sConfPF,sParticles,O)
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

% Condition - number of effective particles
N_eff1=1/sum(sParticles.W.^2);

% if condition fulfilled - resample 
if N_eff1<sConfPF.N_eff_tresh
    sParticles_resampled=sConfPF.resample.fun(sConfPF,sParticles,O);
else
    sParticles_resampled= sParticles;
end

end