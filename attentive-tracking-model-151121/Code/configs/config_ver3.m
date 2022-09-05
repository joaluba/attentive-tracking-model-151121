function sResult = config_ver3

% ------------- Common params for all processing steps -------------
% fs
common.fs=16000;
% stepsize of data aquisition
common.step_ms=20;
% duration of the signal in ms
common.dur=2000;
% sampling frequency of particle filter
common.fs_pf=50;%Hz
% length of the state trajectory
common.N=length(0:common.step_ms:common.dur);

%% 1) Parameters for trajectory generation
% ---------------- TG parameters for both voices -------------------
TGboth=common;
% minimum distance between trajectories
TGboth.mindist=5.5;
% rate of the woods trajectory change
TGboth.trajrate=0.6;

% -------------- TG params specific for voice 1: ---------------
TGfg=TGboth;
% initial distribution
TGfg.pdf_init.range=[100 250;...
    300 700;...
    800 2200];
% -------------- TG params specific for voice 2: ---------------
TGbg=TGboth;
% initial distribution
TGbg.pdf_init.range=[250 400;...
    300 700;...
    800 2200];

% note: trajectories will start in different ranges

%% 2) Parameters for signal generation 
% -------------- SG params are for both voices the same ---------------
SG=common;
SG.r=1';
SG.render='tsc_ortf';

%% 3) Parameters for noise generation 
% -------------- NG params are for both voices the same ---------------
NG=common;
NG.SNR=Inf;
NG.noisefile='olnoise_44100.wav';

%% 3) Parameters for feature extraction 
% -------------- FE params are for both voices the same ---------------
FE=common;
FE.fs_new = FE.fs_pf;
treshvec =[0.9713 0.9611 0.9612 0.9753 0.9765 0.9545 0.9600 0.9137 0.8875 0.8700 0.8767 0.8633 0.6833 0.6825 0.5867 ...
    0.4550 0.3600 0.4000 0.4000 0.3967 0.4225 0.4129 0.3800]';
FE.T1=treshvec;
FE.T2=0.9;
FE.fomin = 80;
FE.fomax = 700;
FE.nmeanperiods = 8;
FE.Tfo = 1/FE.fs_new;

%% 3) Parameters for particle filtering 

% common parameters for all processing steps
PFboth=common;
% number of particles
PFboth.K=300;
% state names and dimensions
PFboth.state_names={'F0'};
PFboth.D_y=length(PFboth.state_names);
PFboth.D_x=1;
% ---------- ESTIMATION & RESAMPLING  ----------
% function to choose final estimate
PFboth.est='expval';
% when to resample
PFboth.resample.whenfun=@pf_when2res_Neff;
PFboth.N_eff_tresh=30;
% how to resample
PFboth.resample.fun=@pf_resample_datasample;

% -------- F-B SEGREGATION ---------
% function to segregate sPAF
PFboth.FGBGseg.fun=@pf_FGBGseg_ver3;
% should the function use ground truth?
PFboth.FGBGseg.GT=0;

% ---------- PREDICTION STEP -----------
% continuity model switched off
PFboth.constparticles=0;
% state transition model to predict particles
PFboth.pdf_sysdyn.fun=@pf_sysdyn_oneextrapolate;
% possible variation of consecutive F0 values
PFboth.pdf_sysdyn.sigma=50*(common.step_ms/1000);
% possible values of F0
PFboth.pdf_sysdyn.range=[100 400];

% ----------- UPDATE STEP ----------
% observation  model
PFboth.pdf_obsstat.fun=@pf_obsstat_F0model;
% likelihood of channel P_cn given F0 (von Mises model) 
PFboth.pdf_obsstat.evalfun=@pf_eval_VM_mix_normn;
% parameter of the von Mises distr. - kappa
PFboth.pdf_obsstat.kappa=5;
% function to integrate likelihood within a channel
PFboth.pdf_obsstat.accugli=@prod;
% function to integrate likelihood across all channels
PFboth.pdf_obsstat.accuchan=@pf_accuchan_sum_norm;
% rule for updating the weight based on previous one
PFboth.weightup.fun=@(Wnew,Wold)Wnew.*Wold;

% -------- PLOT  ---------
PFboth.plotfun=@plotparticleevol_online;
PFboth.plotname='F-B segreg: formant-guided';

% -------------- Parameters which differ for PF1 and PF2: ---------------
PFfg=PFboth;
PFbg=PFboth;
% ---- INITIALIZATION: Attention prior -----
% function to initialize particles 
PFfg.pdf_init.fun =@pf_init_attended;
PFbg.pdf_init.fun =@pf_init_unattended;
% parameters of initialization function
PFfg.pdf_init.sigma =10;
PFbg.pdf_init.sigma =40;
% initial range of the voice 
PFfg.pdf_init.range=[100 400];
PFbg.pdf_init.range=[100 400];


%%%%%%%%%%%%%%%% STORE EVERYTHING IN RESULT STRUCT %%%%%%%%%%%%%%%

sResult.TGfg=TGfg;
sResult.TGbg=TGbg;
sResult.SG=SG;
sResult.NG=NG;
sResult.FE=FE;
sResult.PFfg=PFfg;
sResult.PFbg=PFbg;

end
