%MLSYN_DEFAULTS  - default parameters for Klatt synthesizer
%
%	DEFAULT CONFIGURATION
%
%   SYM V/C  MIN   VAL   MAX  DESCRIPTION
% ----------------------------------------------
%   DU   C   30   500  5000  Duration of the utterance, in msec
%   UI   C    1     5    20  Update interval for parameter reset, in msec
%   SR   C 5000 10000 20000  Output sampling rate, in samples/sec
%   NF   C    1     5     6  Number of formants in cascade branch
%   SS   C    1     2     3  Source switch (1=impulse, 2=natural, 3=LF model)
%   RS   C    1     8  8191  Random seed (initial value of random # generator)
%   SB   C    0     1     1  Same noise burst, reset RS if AF=AH=0, 0=no,1=yes
%   CP   C    0     0     1  0=Cascade, 1=Parallel tract excitation by AV
%   OS   C    0     0    20  Output selector (0=normal,1=voicing source,...)
%   GV   C    0    60    80  Overall gain scale factor for AV, in dB
%   GH   C    0    60    80  Overall gain scale factor for AH, in dB
%   GF   C    0    60    80  Overall gain scale factor for AF, in dB
%   GI   C    0    60    80  Overall gain scale factor for AI, in dB 
%   F0   v    0  1200  5000  Fundamental frequency, in tenths of a Hz
%   AV   v    0    60    80  Amplitude of voicing, in dB
%   OQ   v   10    50    99  Open quotient (voicing open-time/period), in %
%   SQ   v  100   200   500  Speed quotient (rise/fall time, LF model), in %
%   TL   v    0     0    41  Extra tilt of voicing spectrum, dB down @ 3 kHz
%   FL   v    0     0   100  Flutter (random fluct in f0), in % of maximum
%   DI   v    0     0   100  Diplophonia (alt periods closer), in % of max
%   AH   v    0     0    80  Amplitude of aspiration, in dB
%   AF   v    0     0    80  Amplitude of frication, in dB
%   F1   v  180   400  1300  Frequency of 1st formant, in Hz
%   B1   v   30    60  1000  Bandwidth of 1st formant, in Hz
%   DF1  v    0     0   100  Change in F1 during open portion of period, in Hz
%   DB1  v    0     0   400  Change in B1 during open portion of period, in Hz
%   F2   v  550  1500  3000  Frequency of 2nd formant, in Hz
%   B2   v   40    90  1000  Bandwidth of 2nd formant, in Hz
%   F3   v 1200  2500  4800  Frequency of 3rd formant, in Hz
%   B3   v   60   150  1000  Bandwidth of 3rd formant, in Hz
%   F4   v 2400  3250  4990  Frequency of 4th formant, in Hz
%   B4   v  100   200  1000  Bandwidth of 4th formant, in Hz
%   F5   v 3000  3700  4990  Frequency of 5th formant, in Hz
%   B5   v  100   200  1500  Bandwidth of 5th formant, in Hz
%   F6   v 3000  4990  4990  Frequency of 6th formant, in Hz (applies if NF=6)
%   B6   v  100   500  4000  Bandwidth of 6th formant, in Hz (applies if NF=6)
%   FNP  v  180   280   500  Frequency of nasal pole, in Hz
%   BNP  v   40    90  1000  Bandwidth of nasal pole, in Hz
%   FNZ  v  180   280   800  Frequency of nasal zero, in Hz
%   BNZ  v   40    90  1000  Bandwidth of nasal zero, in Hz
%   FTP  v  300  2150  3000  Frequency of tracheal pole, in Hz
%   BTP  v   40   180  1000  Bandwidth of tracheal pole, in Hz
%   FTZ  v  300  2150  3000  Frequency of tracheal zero, in Hz
%   BTZ  v   40   180  2000  Bandwidth of tracheal zero, in Hz
%   A2F  v    0     0    80  Amp of fric-excited parallel 2nd formant, in dB
%   A3F  v    0     0    80  Amp of fric-excited parallel 3rd formant, in dB
%   A4F  v    0     0    80  Amp of fric-excited parallel 4th formant, in dB
%   A5F  v    0     0    80  Amp of fric-excited parallel 5th formant, in dB
%   A6F  v    0     0    80  Amp of fric-excited parallel 6th formant, in dB
%   AB   v    0     0    80  Amp of fric-excited parallel bypass path, in dB
%   B2F  v   40   250  1000  Bw of fric-excited parallel 2nd formant, in Hz
%   B3F  v   60   300  1000  Bw of fric-excited parallel 3rd formant, in Hz
%   B4F  v  100   320  1000  Bw of fric-excited parallel 4th formant, in Hz
%   B5F  v  100   360  1500  Bw of fric-excited parallel 5th formant, in Hz
%   B6F  v  100  1500  4000  Bw of fric-excited parallel 6th formant, in Hz
%   ANV  v    0     0    80  Amp of voice-excited parallel nasal form., in dB
%   A1V  v    0    60    80  Amp of voice-excited parallel 1st formant, in dB
%   A2V  v    0    60    80  Amp of voice-excited parallel 2nd formant, in dB
%   A3V  v    0    60    80  Amp of voice-excited parallel 3rd formant, in dB
%   A4V  v    0    60    80  Amp of voice-excited parallel 4th formant, in dB
%   ATV  v    0     0    80  Amp of voice-excited par tracheal formant, in dB
%   AI   v    0     0    80  Amp of impulse, in dB 
%   FSF  v    0     0     1  Formant Spacing Filter (1=on, 0=off) 
