/*
  ================================================================================================
    D E F P A R S . H
  ------------------------------------------------------------------------------------------------
    default KLSYN parameters
  ================================================================================================
*/


static int PARAMS[] = {
		
/* speaker definitions (spkrdef[]) */
	500,	/* DU: Duration of the utterance, in msec */
	5,		/* UI: Update interval for parameter reset, in msec */
	10000,	/* SR: Output sampling rate, in samples/sec */
	5,		/* NF: Number of formants in cascade branch */
	2,		/* SS: Source switch (1=impulse, 2=natural, 3=LF model) */
	8,		/* RS: Random seed (initial value of random # generator) */
	1,		/* SB: Same noise burst, reset RS if AF=AH=0, 0=no,1=yes */
	0,		/* CP: 0=Cascade, 1=Parallel tract excitation by AV */
	0,		/* OS: Output selector (0=normal,1=voicing source,...) */
	60,		/* GV: Overall gain scale factor for AV, in dB */
	60,		/* GH: Overall gain scale factor for AH, in dB */
	60,		/* GF: Overall gain scale factor for AF, in dB */
	60,		/* GI: Overall gain scale factor for AI, in dB  */
 
/* synthesis parameters (pars[]) */
	1200,	/* F0: Fundamental frequency, in tenths of a Hz */
	60,		/* AV: Amplitude of voicing, in dB */
	50,		/* OQ: Open quotient (voicing open-time/period), in % */
	200,	/* SQ: Speed quotient (rise/fall time, LF model), in % */
	0,		/* TL: Extra tilt of voicing spectrum, dB down @ 3 kHz */
	0,		/* FL: Flutter (random fluct in f0), in % of maximum */
	0,		/* DI: Diplophonia (alt periods closer), in % of max */
	0,		/* AH: Amplitude of aspiration, in dB */
	0,		/* AF: Amplitude of frication, in dB */
	400,	/* F1: Frequency of 1st formant, in Hz */
	60,		/* B1: Bandwidth of 1st formant, in Hz */
	0,		/* DF1: Change in F1 during open portion of period, in Hz */
	0,		/* DB1: Change in B1 during open portion of period, in Hz */
	1500,	/* F2: Frequency of 2nd formant, in Hz */
	90,		/* B2: Bandwidth of 2nd formant, in Hz */
	2500,	/* F3: Frequency of 3rd formant, in Hz */
	150,	/* B3: Bandwidth of 3rd formant, in Hz */
	3250,	/* F4: Frequency of 4th formant, in Hz */
	200,	/* B4: Bandwidth of 4th formant, in Hz */
	3700,	/* F5: Frequency of 5th formant, in Hz */
	200,	/* B5: Bandwidth of 5th formant, in Hz */
	4990,	/* F6: Frequency of 6th formant, in Hz (applies if NF=6) */
	500,	/* B6: Bandwidth of 6th formant, in Hz (applies if NF=6) */
	280,	/* FNP: Frequency of nasal pole, in Hz */
	90,		/* BNP: Bandwidth of nasal pole, in Hz */
	280,	/* FNZ: Frequency of nasal zero, in Hz */
	90,		/* BNZ: Bandwidth of nasal zero, in Hz */
	2150,	/* FTP: Frequency of tracheal pole, in Hz */
	180,	/* BTP: Bandwidth of tracheal pole, in Hz */
	2150,	/* FTZ: Frequency of tracheal zero, in Hz */
	180,	/* BTZ: Bandwidth of tracheal zero, in Hz */
	0,		/* A2F: Amp of fric-excited parallel 2nd formant, in dB */
	0,		/* A3F: Amp of fric-excited parallel 3rd formant, in dB */
	0,		/* A4F: Amp of fric-excited parallel 4th formant, in dB */
	0,		/* A5F: Amp of fric-excited parallel 5th formant, in dB */
	0,		/* A6F: Amp of fric-excited parallel 6th formant, in dB */
	0,		/* AB: Amp of fric-excited parallel bypass path, in dB */
	250,	/* B2F: Bw of fric-excited parallel 2nd formant, in Hz */
	300,	/* B3F: Bw of fric-excited parallel 3rd formant, in Hz */
	320,	/* B4F: Bw of fric-excited parallel 4th formant, in Hz */
	360,	/* B5F: Bw of fric-excited parallel 5th formant, in Hz */
	1500,	/* B6F: Bw of fric-excited parallel 6th formant, in Hz */
	0,		/* ANV: Amp of voice-excited parallel nasal form., in dB */
	60,		/* A1V: Amp of voice-excited parallel 1st formant, in dB */
	60,		/* A2V: Amp of voice-excited parallel 2nd formant, in dB */
	60,		/* A3V: Amp of voice-excited parallel 3rd formant, in dB */
	60,		/* A4V: Amp of voice-excited parallel 4th formant, in dB */
	0,		/* ATV: Amp of voice-excited par tracheal formant, in dB */
	0,		/* AI: Amp of impulse, in dB  */
	0,		/* FSF: Formant Spacing Filter (1=on, 0=off)  */
	0		/* F0next (not a parameter, but a placeholder for F0 interp) */
};
