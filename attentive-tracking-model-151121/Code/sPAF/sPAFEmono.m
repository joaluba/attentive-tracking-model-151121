function [feat ,vfc,vP,vT] = sPAFEmono(sig_0, params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%  sparse Periodicity Auditory Feature Extraction %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function extracts the sparse Periodicity Auditory Features
% ------------------- Input ----------------------: 
% sig_0 - single-channel waveform
% params - struct contraining feature extraction parameters (see demo file)
% ------------------- Output ----------------------: 
% feat.m3PD       - 3-dimensional matrix (channels x tested periods x time instances)
%                   containing values of the relative periodic energy for each tested 
%                   period in each frequency channel
% feat.m3PG_Etot  - 3-dimensional matrix (channels x tested periods x time instances)
%                   containing values of the total periodic energy 
%                   (total energy of 8 synchrogram windows) for those 
%                   tested periods, which fulfill the glimpse criteria, all other
%                   entries are zero
% feat.m3PG_Erel - 3-dimensional matrix (channels x tested periods x time instances)
%                   containing values of the relative periodic energy for those 
%                   tested periods, which fulfill the glimpse criteria, all other
%                   entries are zero
% feat. mE        - 2-dim matrix (channels x time instances) containing values of
%                   signal power in a given time and frequency band (estimated with a 
%                   2.5 Hz filter)
% vfc  - vector with center frequencies [Hz] of gammatone channels
% vP   - vector with tested period values [s]
% vT   - vector with time points [s] for which the analysis was done
% ------------------------------------------------------------------- 
% Authors: This script is based on scripts created during several years 
% of research about modeling auditory features, which includs the work 
% of Volker Hohmann, Matthias Dietz, Chen Zhangli, Angela Josupeit,
% Joanna Luberadzka and probably more.
% Restructured and documented by Joanna in 2020. 
% Note: This code uses the external gammatone filterbank implementation by
% T.Herzke/T.Peters
% ------------------------------------------------------------------------

%% ////////////////// 1. AUDITORY PREPROCESSING \\\\\\\\\\\\\\\\\\\\\\\\

[sigs, vfc]=auditorypreproc(sig_0, params);

%% ////////////////// 2. PERIODICITY ANALYSIS \\\\\\\\\\\\\\\\\\\\\\\\

%% ---- 2.a) periodicity path: 40Hz highpass ------
% this step is performed to remove demodulated 
% spectrum and a DC component after HWR
cutoff_periodicity=40;
[b, a] = butter(2, cutoff_periodicity/(params.fs/2),'high');
sigs_a = filter(b,a,sigs,[],2);

%% ---- 2.b) extract periodicity using synchrogram method ------

% number of time instances
N_T=round(size(sigs_a,2)/round(params.Tfo*params.fs));
% number of channels
N_C=size(sigs_a,1);
% number of tested periods
N_P= length([round(params.fs/params.fomax):round(params.fs/params.fomin)]); % m�gliche Perioden
% allocate matrix for periodicity glimpses with total periodic energy(PG)
m3PG_Etot=zeros(N_C,N_P,N_T);
% allocate matrix for periodicity glimpses with relative periodic energy(PG)
m3PG_Erel=zeros(N_C,N_P,N_T);
% allocate matrix for periodicity degree (PD)
m3PD=zeros(N_C,N_P,N_T);

% for each frequency channel...
for c=1:N_C
display(['periodicity for channel ', num2str(c)])
% pick time signal in that freq. band
sig_ch=sigs_a(c,:);
% compute normalized synchrogram in that band
[pres_ch,ptot_ch,vvp_ch,vperiods,vP,vT]  = ...
    synchrogram(sig_ch,params.fs,params.fomin,params.fomax,params.nmeanperiods,params.step_ms/1000);

%% ---------- 2.c) glimpsing --------------
% glimpsing thresholds for that channel
T1=params.T1(c,1);
T2=params.T2;
% extract glimpses
[feat.m3PG_Etot(c,:,:),feat.m3PG_Erel(c,:,:), feat.m3PD(c,:,:)]=glimpsing(pres_ch,ptot_ch,T1,T2);
end 

    
%% ////////////////// 3. SIGNAL POWER  \\\\\\\\\\\\\\\\\\\\\\\\
%% ---- power path 2.5Hz low pass ------
% this step is performed to estimate the 
% power of the signal in each band
cutoff_power=2.5;
[b, a] = butter(3, cutoff_power/(params.fs/2),'low');
sigs_b = filter(b,a,sigs,[],2);
timeinst_samples=round(vT*params.fs);
% take power corresponding to time instances 
% in which the periodicity was extracted (vT) 
feat.mE=sigs_b(:,timeinst_samples);

end

