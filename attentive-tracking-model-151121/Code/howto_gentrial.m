% This script shows how to use functions in this 
% code package to generate signals 
% with time varying parameters 
% ----------------------------------------
% author: joanna.luberadzka@uni-oldenburg.de


% -------  Generating trajectory --------

% default configuration struct
sConfTG=config_TG_default;
% trajectory with varying F0, F1=400, F2=2100
s={'?w','400','2100'};
% duration in seconds
dur=2;
% generate trajectory
T_GT_fg= gen_traj(s,dur,sConfTG);
T_GT_bg=gen_traj(s,dur,sConfTG);

% -------  Generating acoustic signal --------

% default configuration struct
sConfSG=config_SG_default;
% generate signals based on trajectories
sig_fg= traj2sig(T_GT_fg,sConfSG);
sig_bg=traj2sig(T_GT_bg,sConfSG);

% -------  Adding noise --------

% default configuration struct
sConfNG=config_NG_default;
% generate signal based on trajectory
sig_mix= addnoise2sig(sig_fg+sig_bg,sConfNG);

% -------  Extracting sPAF --------

% default configuration struct
sConfFE=config_FE_default;
% extract sPAF (in a matrix format) 
[matfeat,vfc,vP, vT] = sPAFEmono(sig_mix(:,1),sConfFE);
% transform sPAF in a matrix format
% to sPAF in a cell format  
feat= matfeat2cellfeat(matfeat,vP,vT,vfc);

% -------  Parallel particle filtering  --------

% default configuration struct
sConfPF=config_PF_default;
% attach GT trajectories to config struct for comparison
sConfPF.PFfg.T_GT=T_GT_fg;
sConfPF.PFbg.T_GT=T_GT_bg;
% do you want to plot particle filtering or not?
b_plot=1;
[T_EST_fg,T_EST_bg,~,~,T_O_fg,T_O_bg]=pf_run_parallel_PF_glimpses(feat.o,b_plot,sConfPF.PFfg,sConfPF.PFbg);


% plot to show the estimated trajectories:
figure;
set(0,'defaultAxesFontSize',10); 
plotF0traj(T_GT_fg,'blue','')
plotF0traj(T_EST_fg,'cyan','')
plotF0traj(T_GT_bg,'red','')
plotF0traj(T_EST_bg,'magenta','')
l=legend(gca, 'T_GT_fg','T_EST_fg','T_GT_bg','T_EST_bg');
set(l,'Interpreter','None');



