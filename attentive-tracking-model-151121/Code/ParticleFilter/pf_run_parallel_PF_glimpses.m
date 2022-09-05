function [T_EST_fg,T_EST_bg,sConfPF_fg,sConfPF_bg,T_O_fg,T_O_bg]=pf_run_parallel_PF_glimpses(T_O_mix,b_plot,sConfPF_fg,sConfPF_bg)
% Function to track foreground and background using parallel particle
% filters and sPAF from the mixture signal. 
% ------------------- Input: -----------------
% T_O_mix - cell array containing glimpses extracted for each point in time
% b_plot - 0 : no plots, 1: plotting function specified in config struct
% sConfPF_fg, sConfPF_bg  - config structs for fg and bg particle filter
% ------------------- Output: -----------------
% T_EST_fg  - vector with estimated foreground F0 trajectory
% T_EST_bg - vector estimated background F0 trajectory
% T_O_fg  - cell array containing segregated fg glimpses for each point in time
% T_O_bg - cell array containing segregated BG glimpses for each point in time
% sConfPF_fg, sConfPF_bg - config structs for fg and bg particle filter (some 
% parameters can be attached here during particle filtering process)
% ------------------------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

% prepare axes for the plots
if b_plot~=0
[ax1,fig1,colormaps]=ax_prep(sConfPF_fg);
end 


% %%%%%%%%%%%%%%%%  INITIALIZATION %%%%%%%%%%%%%%%%%%%%

% initialize foreground particle filter
sParticles_old_fg=sConfPF_fg.pdf_init.fun(sConfPF_fg,sConfPF_bg);
sParticles_oldold_fg=sParticles_old_fg;
s_ESTold_fg=sConfPF_fg.T_GT(1,1:sConfPF_fg.D_y);
s_ESToldold_fg=s_ESTold_fg;
% initialize background particle filter
sParticles_old_bg=sConfPF_bg.pdf_init.fun(sConfPF_bg,sConfPF_fg);
sParticles_oldold_bg=sParticles_old_bg;
s_ESTold_bg=sParticles_old_bg.H(:,randi(sConfPF_fg.K));
s_ESToldold_bg=s_ESTold_bg;
% initialize variables in the script
T_O_fg=cell(sConfPF_fg.N,1);
T_O_bg=cell(sConfPF_bg.N,1);
T_EST_fg=zeros(sConfPF_fg.N,sConfPF_fg.D_y);
T_EST_bg=zeros(sConfPF_bg.N,sConfPF_bg.D_y);
T_EST_fg(1,:)=s_ESTold_fg;T_EST_bg(1,:)=s_ESTold_bg;

% %%%%%%%%%%  ITERATION STARTS HERE %%%%%%%%%%%%%
for n=2:length(T_O_mix)
    
    sConfPF_fg.n=n;
    sConfPF_bg.n=n;
    
    % %%%%%%%%%%%%%%%%%%%%%%%%% STATE PREDICTION %%%%%%%%%%%%%%%%%%%%%%%

    if  sConfPF_fg.constparticles
        % Particles stay constant
        sParticles_temp_fg=sParticles_old_fg;
    else
        % Draw samples from the transition pdf 
        sParticles_temp_fg=sConfPF_fg.pdf_sysdyn.fun(sConfPF_fg,sParticles_old_fg,sParticles_oldold_fg);
        
    end
    if  sConfPF_bg.constparticles
        % Particles stay constant
        sParticles_temp_bg=sParticles_old_bg;
    else
        % Draw samples from the transition pdf 
        sParticles_temp_bg=sConfPF_bg.pdf_sysdyn.fun(sConfPF_bg,sParticles_old_bg,sParticles_oldold_bg);
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%%% F-B SEGREGATION %%%%%%%%%%%%%%%%%%%%%%%%
    
    % sPAF features observed in this time instance
    O_mix=T_O_mix{n};
    
    if strcmp(num2str(sConfPF_fg.FGBGseg.GT),'1')
        % Use ground truth F0 to segregate glimpses
        [O_fg, O_bg]=sConfPF_fg.FGBGseg.fun(sConfPF_fg,sConfPF_bg,O_mix,sConfPF_fg.T_GT(n-1,:),sConfPF_bg.T_GT(n-1,:));
    elseif  strcmp(num2str(sConfPF_fg.FGBGseg.GT),'0')
        % Use estimated F0 to segregate voices
        [O_fg, O_bg]=sConfPF_fg.FGBGseg.fun(sConfPF_fg,sConfPF_bg,O_mix,s_ESTold_fg,s_ESTold_bg);
    elseif  strcmp(num2str(sConfPF_fg.FGBGseg.GT),'nobg')
        % if there is only one voice - assign everything to fg
        O_fg=O_mix;
        O_bg=[];
    end
    
    % store segregated sPAF features
    T_O_fg{n}=O_fg;
    T_O_bg{n}=O_bg;
    
    % %%%%%%%%%%%%%%%%%%%%%%% UPDATE PARTICLES %%%%%%%%%%%%%%%%%%%%%%%%%
    sParticles_temp_bg=sConfPF_bg.pdf_obsstat.fun(sConfPF_bg,sParticles_temp_bg,O_bg);
    sParticles_temp_fg=sConfPF_fg.pdf_obsstat.fun(sConfPF_fg,sParticles_temp_fg,O_fg);
    
    % %%%%%%%%%%%%%%%%%%%%%%%% ESTIMATE  STATE %%%%%%%%%%%%%%%%%%%%%%%%%
     if strcmp(sConfPF_fg.est,'expval')
        s_EST_fg=sParticles_temp_fg.H*sParticles_temp_fg.W';
    elseif strcmp(sConfPF_fg.est,'MAP')
        s_EST_fg=MAPestimate(sParticles_temp_fg);
    end
    if strcmp(sConfPF_bg.est,'expval')
        s_EST_bg=sParticles_temp_bg.H*sParticles_temp_bg.W';
    elseif strcmp(sConfPF_bg.est,'MAP')
        s_EST_bg=MAPestimate(sParticles_temp_bg);
    end
    
    
    % %%%%%%%%%%%%%%%%%%%%%% PLOT INSIDE THE LOOP %%%%%%%%%%%%%%%%%%%%%%
    if b_plot~=0
        sConfPF_fg.plotfun(ax1,sConfPF_fg,sConfPF_bg,sParticles_temp_fg,sParticles_temp_bg,...
            s_EST_fg,s_EST_bg, colormaps)
    end
     
    % %%%%%%%%%%%%%%%%%%%%%%% RESAMPLE PARTILCES %%%%%%%%%%%%%%%%%%%%%%%
    if  ~sConfPF_fg.constparticles
        sParticles_resampled_fg=sConfPF_fg.resample.whenfun(sConfPF_fg,sParticles_temp_fg,O_fg);
    else
        sParticles_resampled_fg=sParticles_temp_fg;
    end
    if  ~sConfPF_bg.constparticles
        sParticles_resampled_bg=sConfPF_bg.resample.whenfun(sConfPF_bg,sParticles_temp_bg,O_bg);
    else
        sParticles_resampled_bg=sParticles_temp_bg;
    end
    
    % %%%%%%%%%%%%%%%%%%%% UPDATE VARIABLES %%%%%%%%%%%%%%%%%%%%
    sParticles_oldold_fg=sParticles_old_fg;
    sParticles_oldold_bg=sParticles_old_bg;
    sParticles_old_fg=sParticles_resampled_fg;
    sParticles_old_bg=sParticles_resampled_bg;
    s_ESToldold_fg=s_ESTold_fg;s_ESToldold_bg=s_ESTold_bg;
    s_ESTold_fg=s_EST_fg;s_ESTold_bg=s_EST_bg;
    T_EST_fg(n,:)=s_EST_fg;
    T_EST_bg(n,:)=s_EST_bg;
end

end















