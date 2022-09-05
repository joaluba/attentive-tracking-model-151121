function [corr_probe, incorr_probe] = klatt_from_scores(scores)

sr=8000;

dur_ms = 2000;

ramp_dur_ms = 100;
ramp_samps = sr * ramp_dur_ms/1000;

cp_dur_ms = 500;
cp_samps = sr * cp_dur_ms/1000;

%% Klatt synthesis

defPars = struct('DU',dur_ms, 'SR',16000, 'UI', 2, 'TL', 0, 'SS', 2);
varPars = {'F0','AV','F1','F2'};

s1 = mlsyn(defPars, varPars, scores(:,:,1));
s1 = resample(double(s1)./(4*max(abs(double(s1)))), 8,16);

s2 = mlsyn(defPars, varPars, scores(:,:,2));
s2 = resample(double(s2)./(4*max(abs(double(s2)))), 8,16);

s2 = s2 .* rms(s1)/rms(s2);


s1(1:ramp_samps) = s1(1:ramp_samps).*(((1:ramp_samps)/ramp_samps))';
s1((((dur_ms/1000)*sr)-ramp_samps+1):((dur_ms/1000)*sr)) = s1((((dur_ms/1000)*sr)-ramp_samps+1):((dur_ms/1000)*sr)).*(((ramp_samps:-1:1)/ramp_samps))';

C1 = s1(1:cp_samps);
P1 = s1((((dur_ms/1000)*sr)-cp_samps+1):((dur_ms/1000)*sr));
C1(cp_samps-ramp_samps+1:cp_samps) = C1(cp_samps-ramp_samps+1:cp_samps).*(((ramp_samps:-1:1)/ramp_samps))';
P1(1:ramp_samps) = P1(1:ramp_samps).*(((1:ramp_samps)/ramp_samps))';
P1(cp_samps-ramp_samps+1:cp_samps) = P1(cp_samps-ramp_samps+1:cp_samps).*(((ramp_samps:-1:1)/ramp_samps))';

s2(1:400) = zeros;
s2(401:400+ramp_samps) = s2(401:400+ramp_samps).*(((1:ramp_samps)/ramp_samps))';
s2((((dur_ms/1000)*sr)-ramp_samps+1):((dur_ms/1000)*sr)) = s2((((dur_ms/1000)*sr)-ramp_samps+1):((dur_ms/1000)*sr)).*(((ramp_samps:-1:1)/ramp_samps))';

P2 = s2((((dur_ms/1000)*sr)-cp_samps+1):((dur_ms/1000)*sr));
P2(1:ramp_samps) = P2(1:ramp_samps).*(((1:ramp_samps)/ramp_samps))';
P2(cp_samps-ramp_samps+1:cp_samps) = P2(cp_samps-ramp_samps+1:cp_samps).*(((ramp_samps:-1:1)/ramp_samps))';

corr_probe = vertcat(C1,zeros(4000,1),s1+s2,zeros(4000,1),P1);
incorr_probe = vertcat(C1,zeros(4000,1),s1+s2,zeros(4000,1),P2);

corr_probe = corr_probe .* 0.05/rms(corr_probe);
incorr_probe = incorr_probe .* rms(corr_probe)/rms(incorr_probe);

