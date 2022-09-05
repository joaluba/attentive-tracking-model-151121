function [sigs, vfc]=auditorypreproc(sig_0, params)

%% ---- 1.a) middle ear band pass filtering ------
middle_ear_thr = [500 2000]; % Bandpass freqencies for middle ear transfer
middle_ear_order = 2;        % Only even numbers possible
alpha = 0;                   % Internal noise strength
[b,a] = butter(middle_ear_order,middle_ear_thr(2)/(params.fs/2),'low');
sig_1 = filter(b,a,sig_0);
[b,a] = butter(middle_ear_order,middle_ear_thr(1)/(params.fs/2),'high');
sig_2 = filter(b,a,sig_1);

%% ---- 1.b) gammatone filtering ------
% Define GFB variables
lower_centre_frequency_hz = 200;
upper_centre_frequency_hz = 5000;
resample_factor = 1 %floor(params.fs/(2*upper_centre_frequency_hz));
sig_3 = resample(sig_2,1,resample_factor); % downsample signal
params.fs = params.fs / resample_factor; % Accordingly downsample sampling frequency
t = (1:length(sig_3))/params.fs; % time vector
base_frequency_hz = 1000;
filters_per_ERB = 1.0;
% Initialize analyzer
analyzer = Gfb_Analyzer_new(params.fs, lower_centre_frequency_hz ...
    , base_frequency_hz, upper_centre_frequency_hz, filters_per_ERB);
vfc = round(analyzer.center_frequencies_hz);
% Analyze (with filterbank implementation of Tobias Herzke)
[sigs_0, ~] = Gfb_Analyzer_process(analyzer, sig_3.');

% Only the real part of the complex signal is analyzed
sigs_0=real(sigs_0);


%% ---- 1.c) cochlear compression ------
compression_power=0.4;
sigs_1 = sign(sigs_0).*abs(sigs_0).^compression_power;

%% ---- 1.d) Half-wave rectification ------
sigs_2 = max( sigs_1, 0 );

%% ---- 1.e) 770 Hz low pass ------
filter_order=5;
cutofffreq=2000;
% due to the successive application of the filter, the given 2000 Hz
% correspond to a cut off-frequency of 770 Hz after the five iterations
[b, a] = butter(1, cutofffreq*2/params.fs);
sigs=sigs_2;
for ii=1:filter_order
    sigs = filter(b,a, sigs,[],2);
end

end
