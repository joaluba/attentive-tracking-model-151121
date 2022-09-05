function T= gen_traj(s,dur,sConfTG)
% ---- Input: -----
% s - cell of strings indicating how to generate a trajectory in each dimension.
% for example with s={'100','?w','?w'} we generate a trajectory with F0=100
% and varying F1 and F2. With s={'?w','350','2200'} a trajectory with varying F0
% and fixed vowel (F1=350 Hz, F2=2200Hz) is created. 
% The dynamic trajectories are randomly generated using a method of 
% smoothing the white noise (Woods&McDermott, 2015). 
% dur - duration of the signal in seconds
% sConfTG - config struct for trajectory generation 
% ---- Output: -----
% T - generated trajectory
% --------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

sConfTG.dur=dur*1000;
sConfTG.N=length(0:sConfTG.step_ms:sConfTG.dur);

% generate trajectories:
Twoods=f0f1f2_jl(sConfTG.dur,sConfTG.trajrate,sConfTG.pdf_init.range(1,:),sConfTG.step_ms);
% if a parameter value was specified (not random)
% then copy it to the trajectory matrix:
for j=1:length(s)
    if strcmp(s{j},'?w')
        T(:,j)=Twoods(:,j);
    else
        T(:,j)= ones(sConfTG.N,1)*str2double(s{j});
    end
end
end







