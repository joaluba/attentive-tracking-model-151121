% %%%%%%%%%% DEMO: Compuatational model of attentive voice tracking %%%%%%%%%%
% author: joanna.luberadzka@uni-oldenburg.de
clear
close all

addpath(genpath('../Code/'))
addpath(genpath('../Data/'))

%% -------- Hello info: --------
disp('------------------------------------------------------------------------------')
hello_prompt=sprintf('%s\n',...
    'Hello to a demo of our computational model of attentive tracking!',...
    '',...
    'This computer model simulates how the attentive tracking is solved by the human auditory system.',...
    'Our model combines sparse periodicity-based auditory features (sPAF), tracking with particle filters,',...
    'and statistical models of voice fundamental frequency.',...
    '',...
    'To demonstrate how the model works we use stimuli from attentive tracking paradigm (Woods & McDermott, 2015):',...
    'two synthetic competing voices with time varying parameters (F0, F1, F2), which cross over time.' );
disp(hello_prompt);
input('Press enter to start!');


%% -------- Choose 1 trajectory condition: --------
disp('------------------------------------------------------------------------------')
condition_prompt=sprintf('%s\n',...
    'First, choose one trajectory condition to generate stimuli:',...
    'type <x-V> for 2 voices with crossing F0, and F1 & F2 varying over time',...
    'type <x-I>  for 2 voices with crossing F0, and F1 & F2 identical for both voices',...
    'type <dist0.5_x-V> for 2 voices with minimum distance of 0.5 semitones',...
    'type <dist2.5_x-V> for 2 voices with minimum distance of 2.5 semitones',...
    'type <dist5.5_x-V> for 2 voices with minimum distances of 5.5 semitones ',...
    'type <dist7.5_x-V> for 2 voices with minimum distance of 7.5 semitones',...
    'type <V-1v> for 1 voice with varying F0, F1 & F2');

condition=input(condition_prompt,'s');

% ------------ Load condition data: -----------
% foreground voice trajectories
load([condition,'_T_GT_fg_mat.mat']);
% background voice trajectories
load([condition,'_T_GT_bg_mat.mat']);

% -------- Trajectories of 1 random trial -------
trial_nr= randi(length(T_GT_fg_mat),1);
%  trial trajectories
T_GT_fg=T_GT_fg_mat{trial_nr};
T_GT_bg=T_GT_bg_mat{trial_nr};

%% ------------- Plot trajectories -------------
str_condtrial=['condition: ',condition, ', trial: ',num2str(trial_nr),'/',num2str(length(T_GT_fg_mat))];
disp('------------------------------------------------------------------------------')
disp('A random trial from this condition has been chosen.')
p=input('Do you want to plot trajectories?y/n','s');
if strcmp(p, 'y')
    figure;
    set(0,'defaultAxesFontSize',10); set(0,'defaultTextInterpreter','None');
    plottraj2d(T_GT_bg,'red','')
    plottraj2d(T_GT_fg,'blue',str_condtrial)
    l=legend('T_GT_bg','T_GT_fg');
    set(l, 'Interpreter', 'none')
end

%% ------- Choose model configuration : --------
disp('------------------------------------------------------------------------------')
config_prompt=sprintf('%s\n',...
    'Now, choose one model configuration (they differ in F-B segregation methods):',...
    'type <config_ver1> for F0-guided tracking',...
    'type <config_ver2> for tracking without oracle information',...
    'type <config_ver3> for formant-guided tracking',...
    'type <config_1voice> for singe-voice tracking');
sConf=input(config_prompt);

%% -------Generate signals based on traj. -------
sig_bin_fg= traj2sig(T_GT_fg,sConf.SG);
sig_bin_bg= traj2sig(T_GT_bg,sConf.SG);

%% ------- Set signal levels (or add noise) -------
sig_bin_mix=addnoise2sig(sig_bin_fg+sig_bin_bg,sConf.NG);

%% --------- Playing back mixed signal ---------
disp('------------------------------------------------------------------------------')
disp('Based on state trajectories, the voice signals have been synthesized and mixed.');
p=input('Do you want to play the mixture signal?y/n','s');
if strcmp(p, 'y')
    soundsc(sig_bin_mix,16000)
end

%% --------- Extract sPAF from the mix ---------
disp('------------------------------------------------------------------------------')
p=input('Now the sPAF features will be extracted from the mixture. Press enter to start feature extraction...');
[matfeat,vfc,vP, vT] = sPAFEmono(sig_bin_mix(:,1),sConf.FE);
feat= matfeat2cellfeat(matfeat,vP,vT,vfc);

%% ------------ Plot sPAF features -------------
disp('------------------------------------------------------------------------------')
p=input('sPAF have been extracted. Do you want to plot non-segregated glimpses?y/n','s');
if strcmp(p, 'y')
    figure;
    implot_3dscatter_noE(feat.o, vfc, vP, vT, [0.3 0.3 0.3; 1 1 1], [str_condtrial, ', before segregation'])
end

%% ------------ Particle filtering -------------
disp('------------------------------------------------------------------------------')
expa_prompt=sprintf('%s\n',...
    'The task of the model is to attentively track the fundamental frequency of a foreground voice',...
    'using the sPAF features from the mixture.',...
    '',...
    'To know which voice to follow, human listeners in attentive tracking paradigm heard a probe signal',...
    'coming from one of the voices. This is simulated here by informed initialization of the particle filter',...
    'responsible for tracking the foreground.');
disp(expa_prompt);

disp('------------------------------------------------------------------------------')
pf_prompt=sprintf('%s\n',...
    '',...
    'Press enter to start parallel particle filtering...');
p=input(pf_prompt);
% attach ground truth trajectories to the config struct
% (needed for initialization and in some of the
% F-B segregation methods) :
sConf.PFfg.T_GT=T_GT_fg;
sConf.PFbg.T_GT=T_GT_bg;
% create an extended plot name:
sConf.PFfg.plotname={sConf.PFfg.plotname; str_condtrial};
sConf.PFbg.plotname={sConf.PFbg.plotname;str_condtrial};

[T_EST_fg,T_EST_bg,~,~,T_O_fg,T_O_bg]=pf_run_parallel_PF_glimpses(feat.o,1,sConf.PFfg,sConf.PFbg);

%% ------------ Plot estimated F0 -------------
disp('------------------------------------------------------------------------------')
p=input('Particle filter finished. Do you want to plot the estimated trajectories?y/n','s');
if strcmp(p, 'y')
    figure;
    set(0,'defaultAxesFontSize',10); set(0,'defaultTextInterpreter','None');
    plotF0traj(T_GT_fg,'blue','')
    plotF0traj(T_EST_fg,'cyan','')
    plotF0traj(T_GT_bg,'red','')
    plotF0traj(T_EST_bg,'magenta',str_condtrial)
    l=legend(gca, 'T_GT_fg','T_EST_fg','T_GT_bg','T_EST_bg')
    set(l, 'Interpreter', 'none')
end

%% ---------- Plot segregated glimpses ----------
disp('------------------------------------------------------------------------------')
p=input('Do you also want to plot segregated glimpses?y/n','s');
if strcmp(p, 'y')
    figure;
    implot_3dscatter_noE(T_O_fg, vfc, vP, vT,  [0 0 1; 1 1 1], [str_condtrial, ''])
    implot_3dscatter_noE(T_O_bg, vfc, vP, vT,  [1 0 0; 1 1 1], [str_condtrial, ', after segregation'])
end


%% --------- Evaluating model's response ---------
if ~strcmp(condition,'V-1v')
    disp('------------------------------------------------------------------------------')
    exp_prompt=sprintf('%s\n',...
        'The final task is to evaluate if the model was able to attentively track the foreground voice.',...
        'Human listeners in this task heard a probe signal, coming from one of the voices and they',...
        'had to indicate if it was coming from the voice they attended. ',...
        'This is simulated here by computing the distance between estimated foreground trajectory ',...
        'and the trajectory of the (foreground or background) probe signal.', ...
        '',...
        'If the distance is within a defined discrimination threshold the models response is positive');
    disp(exp_prompt);
    
    
    disp('------------------------------------------------------------------------------')
    p=input('Press enter to compute models responses for different discrimination thresholds...');
    v_r=[0.5:2:100];
    for r=1:length(v_r)
        [res_fgprobe(r), res_bgprobe(r)]=trialresponse(T_GT_fg,T_GT_bg,T_EST_fg, v_r(r));
    end
    
    %% --------- Plotting model's response ---------
    disp('------------------------------------------------------------------------------')
    p=input('Do you want to plot models response to this trial?y/n','s');
    if strcmp(p, 'y')
        figure;
        plotresponses(res_fgprobe,res_bgprobe, v_r,str_condtrial)
    end
    
end

disp('------------------------------------------------------------------------------')
dprime_prompt=sprintf('%s\n',...
    'With this procedure, after a number of trial we can obtain True Positive Rate (TPR) and False Positive Rate (FPR)',...
    'as a function of discrimination threshold. TPR plotted against FPR defines an ROC curve, ',...
    'from which a d-prime value can be derived. This d-prime value can be compared with the d-prime values ',...
    'obtained by human listeners in the attentive tracking experimnet. This is how we compare our model with humans.');
disp(exp_prompt);

%% ---------- Goodbye info ------------
disp('------------------------------------------------------------------------------')
goodbye_prompt=sprintf('%s\n',...
    'Thanks for checking this demo!',...
    '',...
    'More information about our attentive tracking model can be found in the paper: ',...
    '"Making sense of periodicity glimpses in a prediction-update-loop',...
    '- a computational model of attentive voice tracking"',...
    'by Joanna Luberadzka, Hendrik Kayser, and Volker Hohmann',...
    '',...
    ' Any questions, suggestions or comments are very welcome and can be sent to:',...
    ' joanna.luberadzka@uni-oldenburg.de');

disp(goodbye_prompt)

