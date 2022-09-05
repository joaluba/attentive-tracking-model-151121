function [pres,ptot,vvp,vP_samples,vP_ms,vT_ms]  = synchrogram(y,fs,fomin,fomax,nmeanperiods,Tfo)
% Calculates synchrogram (normalized periodosynchronous intensity)
% using buffer-wise means
%
% y: signal
% fs: signal sampling frequency
% fomin: minimum fundamental frequency to be searched
% fomax: maximum fundamental frequency to be searched
% nmeanperiods: number of periods of the respective
%               fundamental frequency to be averaged
% Tfo: desired sampling period of periodosynchronous intensity
%
% pres: periodogram (periodosynchronous intensity as a function of period and time)
% ptot: total intensity as a function of period and time
% vvp: array of base functions for all periods as a function of time
% vP_samples: searched periods in samples@fs
% vP_ms: searched periods as fundamental frequency in Hz
% vT_ms: time at which the features were extracted
%
% Copyright V. Hohmann, Universit�t Oldenburg, 01/04
% Modified by Angela Josupeit (aj) 2012
% And by Joanna Luberadzka 2020

% derived parameters
vP_samples = [round(fs/fomax):round(fs/fomin)]; % m�gliche Perioden
vfo = fs./vP_samples; % und zugeh�rige Grundfrequenzen
pfo = round(Tfo*fs); % Periode in samples f�r die Beobachtung
ffo = round(fs/pfo);
nperiods = length(vP_samples);
ylen = length(y);
nbuffers = round(ylen/pfo);%floor(ylen/pfo);
maxperiod = vP_samples(end);

% loop over all buffers
vp=zeros(maxperiod,nperiods);
pres=zeros(nperiods,nbuffers);
ptot=zeros(nperiods,nbuffers);
vvp = zeros(maxperiod,nperiods,nbuffers); % modified by aj
%vvp=0; % modified by aj
offset=zeros(nbuffers,1);
for j = 1:nbuffers
    offset(j) = (j-1)*pfo + 1;
    for i=1:nperiods
        wlen = nmeanperiods * vP_samples(i);
        wlenp = floor(wlen/2);
        wlenm = wlen - wlenp; 
        yw = y(max(offset(j)-wlenm,1):min(offset(j)+wlenp-1,ylen));
        vp(1:vP_samples(i),i) = mean(buffer(yw,vP_samples(i)),2);
        pres(i,j) = sum(vp(:,i).^2)/vP_samples(i);
        ptot(i,j) = mean(yw.^2);
    end
    vvp(:,:,j) = vp; % modified by aj
end
vT_ms=offset./fs;
vP_ms=1./vfo;