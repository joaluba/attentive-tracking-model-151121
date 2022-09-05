% %%%%%%% default parameters for parallel particle filtering: %%%%%%%
function sResult = config_PF_default
% ------------- Common params for all processing steps -------------
% fs
PFboth.fs=16000;
% stepsize of data aquisition
PFboth.step_ms=20;
% duration of the signal in ms
PFboth.dur=2000;
% sampling frequency of particle filter
PFboth.fs_pf=50;%Hz
% length of the state trajectory
PFboth.N=length(0:PFboth.step_ms:PFboth.dur);

% common parameters for all processing steps
PFboth=PFboth;
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
PFboth.FGBGseg.fun=@pf_FGBGseg_ver1ver2;
% should the function use ground truth?
PFboth.FGBGseg.GT=0;

% ---------- PREDICTION STEP -----------
% continuity model switched off
PFboth.constparticles=0;
% state transition model to predict particles
PFboth.pdf_sysdyn.fun=@pf_sysdyn_oneextrapolate;
% possible variation of consecutive F0 values
PFboth.pdf_sysdyn.sigma=50*(PFboth.step_ms/1000);
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
PFboth.plotname='';

% -------------- Parameters which differ for PF1 and PF2: ---------------
PFfg=PFboth;
PFbg=PFboth;
% ---- INITIALIZATION: Attention prior -----
% function to initialize particles 
PFfg.pdf_init.fun =@pf_init_all_uniform;
PFbg.pdf_init.fun =@pf_init_all_uniform;
% parameters of initialization function
PFfg.pdf_init.sigma =10;
PFbg.pdf_init.sigma =40;
% initial range of the voice 
PFfg.pdf_init.range=[100 250];
PFbg.pdf_init.range=[250 400];

sResult.PFfg=PFfg;
sResult.PFbg=PFbg;

end
