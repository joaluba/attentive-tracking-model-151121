% %%%%%%% default parameters for feature extraction : %%%%%%%
function sConfFE=config_FE_default
% sampling frequency
sConfFE.fs=16000;
% stepsize of data aquisition
sConfFE.step_ms=20;
% sampling frequency of data aquisition
sConfFE.fs_new = 50;
sConfFE.Tfo = 1/sConfFE.fs_new;
% first threshold values
sConfFE.T1 =[0.9713 0.9611 0.9612 0.9753 0.9765 0.9545 0.9600 0.9137 0.8875 0.8700 0.8767 0.8633 0.6833 0.6825 0.5867 ...
    0.4550 0.3600 0.4000 0.4000 0.3967 0.4225 0.4129 0.3800]';
% second threhsold - % of the first threshols
sConfFE.T2=0.9;
% range of searching period values:
sConfFE.fomin = 80;
sConfFE.fomax = 700;
% nr of segments used in the normalized synchrogram computation
sConfFE.nmeanperiods = 8;
end