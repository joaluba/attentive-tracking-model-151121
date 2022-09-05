function [signal_mono, signal_bin] = auralise_hidden_states(T,fs_pf,fs_sig,r,render)
% Function to auralise (synthesize) the voice based on parameter trajectory. 
% ---- Input: -----
% T - 4 dimensional state trajectory (sequence) 
% fs_pf - sampling of the particle filter
% fs_sig - sampling frequency of the signal we want to produce
% r- distance to the receiver 
% render - type of rendering in tascar 
% ---- Input: -----
% signal_mono - 1-channel signal
% signal_bin - 2-channel signal
% -------------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

% change nans to zeros (synthesiser does not take nans)
T(isnan(T))=0;

step=1/fs_pf*1000;%ms
dur=(length(T))*step;%ms
% ------------------------------------------------------------------------
changespk=1;%change to 1.5 to get female voice
% Constant Parameters
defPars = struct('DU',dur, 'SR',16000, 'UI', 2, 'TL', 0, 'SS', 2);
defPars.F3=2500*changespk;
defPars.F4=3250*changespk;
defPars.F5=3700*changespk;
defPars.AV=50;
% Varying Parameters
varPars = {'F0','F1','F2'};
% time vector for parameter update
time= step:step:dur;
% create matrix score(used in Klatt) 
score=[time' T];
% F0 in Klatt  has to be in tens of Hz
score(:,2)=score(:,2)*10;
% Klatt synthesis

N_buff=ceil(size(score,1)/2000);
signal=[];
for n=1:N_buff
defPars.DU= min(2000,size(score,1))*step;
time_chunk= step:step:defPars.DU;
sigchunk= mlsyn(defPars, varPars, [time_chunk' score((n-1)*2000+1:min(n*2000,size(score,1)),2:4)]);
signal=[signal;sigchunk];
end
% int16 --> double
signal = double(signal);
%signal=signal./(4*max(abs(signal)));%???
% resample
[P,Q] = rat(fs_sig/16000);
signal=resample(signal,P,Q);
% 0 dB
signal_mono=mynormalize(signal,-1,1);
% stereo signal - just a dichotic signal: 
signal_bin=[signal_mono signal_mono];
% ------------------------------------------------
% Extension for the future model version: moving voices
% Use synthesised signals and alpha (deg)  trajectory 
% to generate binaural files using TASCAR 
% save mono file:
% monofilename=[datestr(now,'HHMMSS'),'-tmp_mono.wav'];
% binfilename='tmp_bin.wav';
% signal_bin=tsc_createbinfile(monofilename,binfilename,deg2rad(score(:,5)),score(:,1),fs_sig,r,render);
end