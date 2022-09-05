% %%%%%%% default parameters for trajectory generation : %%%%%%%%
function sConfTG = config_TG_default
% fs
sConfTG.fs=16000;
% stepsize of data aquisition
sConfTG.step_ms=20;
% duration of the signal in ms
sConfTG.dur=2000;
% sampling frequency of particle filter
sConfTG.fs_pf=50;%Hz
% length of the state trajectory
sConfTG.N=length(0:sConfTG.step_ms:sConfTG.dur);
% minimum distance between trajectories
sConfTG.mindist=5.5;
% rate of the woods trajectory change
sConfTG.trajrate=0.6;
% initial distribution
sConfTG.pdf_init.range=[100 400;...
    300 700;...
    800 2200;...
    -90 90];
sConfTG.mindist=5.5;
sConfTG.trajrate=0.6;
end
