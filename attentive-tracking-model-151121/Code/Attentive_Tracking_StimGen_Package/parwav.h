/*
  ================================================================================================
    P A R W A V . H
  ------------------------------------------------------------------------------------------------
    synthesis parameters
  ================================================================================================
*/


#define N_SPDEF_PARS	13		/* Used only for debug printout */
#define N_VARIABLE_PARS	47

#define IMPULSIVE	1
#define NATURAL		2
#define CASCADE		0
#define PARALLEL	1

static int initsw;		/* Used to set speaker def on first call	*/

/* VARIABLES TO HOLD 11 SPEAKER DEFINITION FROM HOST:                   */

static int nspfr;		/* Number of samples in a parameter frame	*/
static int samrate;		/* Number of output samples per second		*/
static int nfcascade;	/* Number of formants in cascade vocal tract	*/
static int glsource;	/* 1->impulsive, 2->natural voicing source	*/
static int ranseed;		/* Seed specifying initial number for ran # gener */
static int sameburst;	/* Use same burst noise sequence if =1, rand if =0*/
static int cascparsw;	/* Cascade/parallel switch, 0=cascade, 1=parallel */
static int outsl;		/* Output waveform selector		  	*/
static int GainAV;		/* Overall gain, 60 dB is unity  0 to   80	*/
static int GainAH;		/* Overall gain, 60 dB is unity  0 to   80	*/
static int GainAF;		/* Overall gain, 60 dB is unity  0 to   80	*/
static int GainAI;      /* 93 Overall gain ?????? */

/* VARIABLES TO HOLD 45 TIME-VARYING INPUT PARAMETERS FROM HOST:	*/

static int F0hz10;  /*   Voicing fund freq in Hz,    0 to 5000	*/
static int AVdb  ;  /*      Amp of voicing in dB,    0 to   70  */
static int OQ    ;  /* Open quotient, in percent,    1 to   99  */
static int SQ    ;  /* Speed quotient, in percent, 100 to  500  */
static int TL    ;  /* Voicing spectral tilt in dB,  0 to   41  */
static int DP    ;  /* Double-pulsing, %  	         0 to  100  */
static int FL    ;  /* Flutter, or slow variation F0,0 to   20  */
static int AH    ;  /*   Amp of aspiration in dB,    0 to   70  */
static int AF    ;  /*    Amp of frication in dB,    0 to   80  */
static int AI    ;  /* 93 Amp of impulse, in dB       0 to   80 */
static int FSF   ;  /* 93Formant spacing filter (0=off 1=on)    */


static int F1hz  ;  /*  First formant freq in Hz,  200 to 1300  */
static int B1hz  ;  /*    First formant bw in Hz,   40 to 1000  */
static int F2hz  ;  /* Second formant freq in Hz,  550 to 3000  */
static int B2hz  ;  /*   Second formant bw in Hz,   40 to 1000  */
static int F3hz  ;  /*  Third formant freq in Hz, 1200 to 4999  */
static int B3hz  ;  /*    Third formant bw in Hz,   40 to 1000  */
static int F4hz  ;  /* Fourth formant freq in Hz, 1200 to 4999  */
static int B4hz  ;  /*    Fourth formant bw in Hz,  40 to 1000  */
static int F5hz  ;  /*  Fifth formant freq in Hz, 1200 to 4999  */
static int B5hz  ;  /*    Fifth formant bw in Hz,   40 to 1000  */
static int F6hz  ;  /*  Sixth formant freq in Hz, 1200 to 4999  */
static int B6hz  ;  /*    Sixth formant bw in Hz,   40 to 2000  */
static int FNZhz ;  /*     Nasal zero freq in Hz,  248 to  528  */
static int BNZhz ;  /*       Nasal zero bw in Hz,   40 to 1000  */
static int FNPhz ;  /*     Nasal pole freq in Hz,  248 to  528  */
static int BNPhz ;  /*       Nasal pole bw in Hz,   40 to 1000  */
static int FTPhz ;  /*  Tracheal pole freq in Hz,  300 to 3000  */
static int BTPhz ;  /*    Tracheal pole bw in Hz,   40 to 1000  */
static int FTZhz ;  /*  Tracheal zero freq in Hz,  300 to 3000  */
static int BTZhz ;  /*    Tracheal zero bw in Hz,   40 to 1000  */

static int A1V   ;  /* Amp of par 1st formant in dB, 0 to   80  */
static int A2V   ;  /* Amp of par 2nd formant in dB, 0 to   80  */
static int A3V   ;  /* Amp of par 3rd formant in dB, 0 to   80  */
static int A4V   ;  /* Amp of par 4th formant in dB, 0 to   80  */
static int A2    ;  /* Amp of F2 frication in dB,    0 to   80  */
static int A3    ;  /* Amp of F3 frication in dB,    0 to   80  */
static int A4    ;  /* Amp of F4 frication in dB,    0 to   80  */
static int A5    ;  /* Amp of F5 frication in dB,    0 to   80  */
static int A6    ;  /* Amp of F6 (same as r6pa),     0 to   80  */
static int AB    ;  /* Amp of bypass fric. in dB,    0 to   80  */
static int AN    ;  /* Amp of par nasal pole in dB,  0 to   80  */
static int AT    ;  /* Amp of par tracheal pole in dB0 to   80  */
static int B1phz ;  /* Par. 1st formant bw in Hz,   40 to 1000  */
static int B2phz ;  /* Par. 2nd formant bw in Hz,   40 to 1000  */
static int B3phz ;  /* Par. 3rd formant bw in Hz,   40 to 1000  */
static int B4phz ;  /*  Par. 4th formant bw in Hz,  40 to 1000  */
static int B5phz ;  /* Par. 5th formant bw in Hz,   40 to 1000  */
static int B6phz ;  /* Par. 6th formant bw in Hz,   40 to 2000  */
static int dB1hz ;  /* Increment to B1hz during open phase of cycle */
static int dF1hz ;  /* Increment to F1hz during open phase of cycle */
static int F0next;  /* Value of f0 in next frame, used to interpolate f0 */

/* SAME VARIABLES CONVERTED TO LINEAR FLOATING POINT */
static float amp_parvF1;/* A1V converted to linear gain		    */
static float amp_parvF2;/* A2V converted to linear gain		    */
static float amp_parvF3;/* A3V converted to linear gain		    */
static float amp_parvF4;/* A4V converted to linear gain		    */
static float amp_parF2;	/* A2 converted to linear gain		    */
static float amp_parF3;	/* A3 converted to linear gain		    */
static float amp_parF4;	/* A4 converted to linear gain		    */
static float amp_parF5;	/* A5 converted to linear gain		    */
static float amp_parF6;	/* A6 converted to linear gain		    */
static float amp_bypas;	/* AB converted to linear gain		    */
static float amp_parNP; /* AN converted to linear gain		    */
static float amp_parTP;	/* AT converted to linear gain	    	*/
static float amp_voice;	/* AVdb converted to linear gain	    */
static float amp_aspir;	/* AH converted to linear gain          */
static float amp_imp  ; /* AI converted to linear gain   93     */
static float amp_frica;	/* AF converted to linear gain		    */
static float amp_gainAV;/* GV converted to linear gain		    */
static float amp_gainAH;/* GH converted to linear gain		    */
static float amp_gainAF;/* GF converted to linear gain		    */
static float amp_gainAI;/* GI converted to linear gain   93     */
static float flutter;

/* COUNTERS */

static int ns    ;  /* Number of samples into current frame         */
static int nper  ;  /* current loc in voicing period   40000 samp/s */
static int n4    ;  /* Counter of 4 samples in glottal source loop  */

/* COUNTER LIMITS */

static int T0    ;  /* Fundamental period in output samples times 4 */
static int nopen ;  /* Number of samples in open phase of period    */
static int nmod  ;  /* Position in period to begin noise amp. modul */

/* ALL-PURPOSE TEMPORARY VARIABLES */

static int temp    ;
static float temp1 ;

static float minus_pi_t;
static float two_pi_t;

static int F1last;
static int F2last;
static int F3last;

static int FLPhz ;	/* Frequeny of glottal downsample low-pass filter */
static int BLPhz ;	/* Bandwidt of glottal downsample low-pass filter */

static int Ffant ;	/* Frequeny of LF glottal resonator */
static int BWfant ;	/* Bandwidth of LF glottal resonator */
static float Afant;	/* Amplitude of impulse exciting LF glottal resonator */

static int F1hzmod;	/* Increase in F1 during open phase of glottal cycle */
static int B1hzmod;	/* Increase in B1 during open phase of glottal cycle */

static int F0interp;	   /* Interpolated value of f0 from current & next frame */
static float glottalnoise; /* First diff. of frication noise, used for aspir     */
static float trachout;

static float anorm1;  /* Normalizing scale factor for F1 sudden change */
static float anorm2;  /* Normalizing scale factor for F2 sudden change */
static float anorm3;  /* Normalizing scale factor for F3 sudden change */
static float r;

static double arg7Hz;	/* Arguments for flutter (sum of sinusoids) of f0 */
static double arg5Hz;
static double arg3Hz;
static double darg7Hz;
static double darg5Hz;
static double darg3Hz;
static double radiansperframe;
static double arg;

/* VARIABLES THAT HAVE TO STICK AROUND FOR AWHILE, AND THUS "temp" IS NOT APPROPRIATE */

static short nrand ;  /* Varible used by random number generator      */
static int dpulse  ;  /* Double-pulsing, in quarter-sample units      */
			/* Can be same as temp1 */

static float a     ;  /* Makes waveshape of glottal pulse when open   */
static float b     ;  /* Makes waveshape of glottal pulse when open   */
static float voice ;  /* Current sample of voicing waveform           */
static float vwave ;  /* Ditto, but before multiplication by AVdb     */
static float noise ;  /* Output of random number generator            */
static float frics ;  /* Frication sound source                       */
static float aspiration; /* Aspiration sound source                   */
static float sourc ;  /* Sound source if all-parallel config used     */
static float casc_next_in;  /* Input to next used resonator of casc   */
static float out   ;  /* Output of cascade branch, also final output  */
/* 93 */
static float lastout;   /* save previous out for filter   */
static float lstinput;  /* save last input to filter x[n]  */
static float previnput; /* save previous input to filter x[n-2] */
static float spacefix;  /* pole or zero  used in spacefilt filter */

static float rnzout;      /* Output of cascade nazal zero resonator	       */
static float glotout;     /* Output of glottal sound source before AV&tilt */
static float tiltout;     /* Output of glottal sound source after AV&tilt  */
static float par_glotout; /* Output of parallelglottal sound sourc         */
static float outbypas;    /* Output signal from bypass path	               */

/* INTERNAL MEMORY FOR DIGITAL RESONATORS AND ANTIRESONATOR           */

static float r2p_1 ;  /* Last output sample from parallel 2nd formant */
static float r2p_2 ;  /* Second-previous output sample                */

static float r3p_1 ;  /* Last output sample from parallel 3rd formant */
static float r3p_2 ;  /* Second-previous output sample                */

static float r4p_1 ;  /* Last output sample from parallel 4th formant */
static float r4p_2 ;  /* Second-previous output sample                */

static float r5p_1 ;  /* Last output sample from parallel 5th formant */
static float r5p_2 ;  /* Second-previous output sample                */

static float r6p_1 ;  /* Last output sample from parallel 6th formant */
static float r6p_2 ;  /* Second-previous output sample                */


static float r1c_1 ;  /* Last output sample from cascade 1st formant  */
static float r1c_2 ;  /* Second-previous output sample                */

static float r2c_1 ;  /* Last output sample from cascade 2nd formant  */
static float r2c_2 ;  /* Second-previous output sample                */

static float r3c_1 ;  /* Last output sample from cascade 3rd formant  */
static float r3c_2 ;  /* Second-previous output sample                */

static float r4c_1 ;  /* Last output sample from cascade 4th formant  */
static float r4c_2 ;  /* Second-previous output sample                */

static float r5c_1 ;  /* Last output sample from cascade 5th formant  */
static float r5c_2 ;  /* Second-previous output sample                */

static float r6c_1 ;  /* Last output sample from cascade 6th formant  */
static float r6c_2 ;  /* Second-previous output sample                */

static float r7c_1 ;  /* Last output sample from cascade 7th formant  */
static float r7c_2 ;  /* Second-previous output sample                */

static float r8c_1;  /* Last output sample from cascade 8th formant  */
static float r8c_2;  /* Second-previous output sample                */

static float rnpc_1;  /* Last output sample from cascade nasal pole   */
static float rnpc_2;  /* Second-previous output sample                */

static float rnz_1 ;  /* Last output sample from cascade nasal zero   */
static float rnz_2 ;  /* Second-previous output sample                */

static float rztr1_1;  /* Last output sample from cascade tracheal pole */
static float rztr1_2;  /* Second-previous output sample                */

static float rptr1_1;  /* Last output sample from cascade tracheal zero */
static float rptr1_2;  /* Second-previous output sample                */

static float rgl_1 ;  /* Last output crit-damped glot low-pass filter */
static float rgl_2 ;  /* Second-previous output sample                */

static float rtlt_1;  /* Last output from TILT low-pass filter    */
static float rtlt_2;  /* Second-previous output sample                */

static float rlp_1 ;    /* Last output from downsamp low-pass filter */
static float rlp_2 ;    /* Second-previous output sample */


/* COEFFICIENTS FOR DIGITAL RESONATORS AND ANTIRESONATOR */

static float r2pa  ;  /* Could be same as A2 if all integer impl.     */
static float r2pb  ;  /* "b" coefficient                              */
static float r2pc  ;  /* "c" coefficient                              */

static float r3pa  ;  /* Could be same as A3 if all integer impl.     */
static float r3pb  ;  /* "b" coefficient                              */
static float r3pc  ;  /* "c" coefficient                              */

static float r4pa  ;  /* Could be same as A4 if all integer impl.     */
static float r4pb  ;  /* "b" coefficient                              */
static float r4pc  ;  /* "c" coefficient                              */

static float r5pa  ;  /* Could be same as A5 if all integer impl.     */
static float r5pb  ;  /* "b" coefficient                              */
static float r5pc  ;  /* "c" coefficient                              */

static float r6pa  ;  /* Could be same as A6 if all integer impl.     */
static float r6pb  ;  /* "b" coefficient                              */
static float r6pc  ;  /* "c" coefficient                              */

static float r1ca  ;  /* Could be same as r1pa if all integer impl.   */
static float r1cb  ;  /* Could be same as r1pb if all integer impl.   */
static float r1cc  ;  /* Could be same as r1pc if all integer impl.   */

static float r2ca  ;   /* "a" coefficient for cascade 2nd formant     */
static float r2cb  ;   /* "b" coefficient                             */
static float r2cc  ;   /* "c" coefficient                             */

static float r3ca  ;   /* "a" coefficient for cascade 3rd formant     */
static float r3cb  ;   /* "b" coefficient                             */
static float r3cc  ;   /* "c" coefficient                             */

static float r4ca  ;   /* "a" coefficient for cascade 4th formant     */
static float r4cb  ;   /* "b" coefficient                             */
static float r4cc  ;   /* "c" coefficient (same as R4Cccoef)          */

static float r5ca  ;   /* "a" coefficient for cascade 5th formant     */
static float r5cb  ;   /* "b" coefficient                             */
static float r5cc  ;   /* "c" coefficient (same as R5Cccoef)          */

static float r6ca  ;   /* "a" coefficient for cascade 6th formant     */
static float r6cb  ;   /* "b" coefficient                             */
static float r6cc  ;   /* "c" coefficient			      */

static float r7ca  ;   /* "a" coefficient for cascade 7th formant     */
static float r7cb  ;   /* "b" coefficient                             */
static float r7cc  ;   /* "c" coefficient                             */

static float r8ca  ;   /* "a" coefficient for cascade 8th formant     */
static float r8cb  ;   /* "b" coefficient                             */
static float r8cc  ;   /* "c" coefficient                             */

static float rnpca ;   /* "a" coefficient for cascade nasal pole      */
static float rnpcb ;   /* "b" coefficient                             */
static float rnpcc ;   /* "c" coefficient                             */

static float rnza  ;   /* "a" coefficient for cascade nasal zero      */
static float rnzb  ;   /* "b" coefficient                             */
static float rnzc  ;   /* "c" coefficient                             */

static float rptr1a;   /* "a" coefficient for cascade tracheal pole   */
static float rptr1b;   /* "b" coefficient                             */
static float rptr1c;   /* "c" coefficient                             */

static float rztr1a;   /* "a" coefficient for cascade tracheal zero   */
static float rztr1b;   /* "b" coefficient                             */
static float rztr1c;   /* "c" coefficient                             */

static float rgla  ;   /* "a" coefficient for crit-damp glot filter   */
static float rglb  ;   /* "b" coefficient                             */
static float rglc  ;   /* "c" coefficient                             */

static float rtlta ;   /* "a" coefficient for TILT low-pass filter    */
static float rtltb ;   /* "b" coefficient                             */
static float rtltc ;   /* "c" coefficient                             */

static float rlpa  ;   /* "a" coefficient for downsam low-pass filter */
static float rlpb  ;   /* "b" coefficient                             */
static float rlpc  ;   /* "c" coefficient                             */

/* OUT static float decay ;  TLTdb converted to exponential time const   */
/* OUT static float onemd ;  in voicing one-pole low-pass filter         */
static int Ftilt,BWtilt;


/* CONSTANTS AND TABLES TO BE PUT IN ROM                              */

#define CASCADE_PARALLEL      1 /* Normal synthesizer config          */
#define ALL_PARALLEL          2 /* Only use parallel branch           */


/*
 * Constant B0 controls shape of glottal pulse as a function
 * of desired duration of open phase N0
 * (Note that N0 is specified in terms of 40,000 samples/sec of speech)
 *
 *    Assume voicing waveform V(t) has form: k1 t**2 - k2 t**3
 *
 *    If the radiation characterivative, a temporal derivative
 *      is folded in, and we go from continuous time to discrete
 *      integers n:  dV/dt = vwave[n]
 *                         = sum over i=1,2,...,n of { a - (i * b) }
 *                         = a n  -  b/2 n**2
 *
 *      where the  constants a and b control the detailed shape
 *      and amplitude of the voicing waveform over the open
 *      potion of the voicing cycle "nopen".
 *
 *    Let integral of dV/dt have no net dc flow --> a = (b * nopen) / 3
 *
 *    Let maximum of dUg(n)/dn be constant --> b = gain / (nopen * nopen)
 *      meaning as nopen gets bigger, V has bigger peak proportional to n
 *
 *    Thus, to generate the table below for 40 <= nopen < 800:
 *
 *	FILE *fopen(), *odev;
 *	int n;
 *		    odev = fopen("temp.c", "w");
 *		    fprintf(odev, "    float B0[760] = {\n\t");
 *		    for (n=40; n<nopenmax; n++) {
 *			b = 1920000. / (n * n);
 *			fprintf(odev, "%6.2f, ", b);
 *			if ((n-9) == ((n/10)*10))    fprintf(odev, "\n\t");
 *		    }
 *		    fprintf(odev, "    };\n\n");
 */
static float B0[760] = {
1200.00,1142.18,1088.44,1038.40, 991.74, 948.15, 907.37, 869.17, 833.33, 799.67,
 768.00, 738.18, 710.06, 683.52, 658.44, 634.71, 612.24, 590.95, 570.75, 551.57,
 533.33, 515.99, 499.48, 483.75, 468.75, 454.44, 440.77, 427.71, 415.22, 403.28,
 391.84, 380.88, 370.37, 360.29, 350.62, 341.33, 332.41, 323.83, 315.58, 307.64,
 300.00, 292.64, 285.54, 278.71, 272.11, 265.74, 259.60, 253.67, 247.93, 242.39,
 237.04, 231.86, 226.84, 221.99, 217.29, 212.74, 208.33, 204.06, 199.92, 195.90,

 192.00, 188.22, 184.54, 180.98, 177.51, 174.15, 170.88, 167.70, 164.61, 161.60,
 158.68, 155.83, 153.06, 150.36, 147.74, 145.18, 142.69, 140.26, 137.89, 135.58,
 133.33, 131.14, 129.00, 126.91, 124.87, 122.88, 120.94, 119.04, 117.19, 115.38,
 113.61, 111.88, 110.19, 108.54, 106.93, 105.35, 103.81, 102.30, 100.82,  99.37,
  97.96,  96.57,  95.22,  93.89,  92.59,  91.32,  90.07,  88.85,  87.66,  86.48,
  85.33,  84.21,  83.10,  82.02,  80.96,  79.92,  78.90,  77.89,  76.91,  75.95,
  75.00,  74.07,  73.16,  72.26,  71.39,  70.52,  69.68,  68.84,  68.03,  67.22,
  66.44,  65.66,  64.90,  64.15,  63.42,  62.69,  61.98,  61.29,  60.60,  59.92,
  59.26,  58.61,  57.96,  57.33,  56.71,  56.10,  55.50,  54.91,  54.32,  53.75,
  53.19,  52.63,  52.08,  51.55,  51.01,  50.49,  49.98,  49.47,  48.97,  48.48,

  48.00,  47.52,  47.05,  46.59,  46.14,  45.69,  45.24,  44.81,  44.38,  43.96,
  43.54,  43.13,  42.72,  42.32,  41.93,  41.54,  41.15,  40.77,  40.40,  40.03,
  39.67,  39.31,  38.96,  38.61,  38.27,  37.93,  37.59,  37.26,  36.93,  36.61,
  36.29,  35.98,  35.67,  35.37,  35.06,  34.77,  34.47,  34.18,  33.90,  33.61,
  33.33,  33.06,  32.78,  32.52,  32.25,  31.99,  31.73,  31.47,  31.22,  30.97,
  30.72,  30.48,  30.23,  30.00,  29.76,  29.53,  29.30,  29.07,  28.84,  28.62,
  28.40,  28.19,  27.97,  27.76,  27.55,  27.34,  27.14,  26.93,  26.73,  26.53,
  26.34,  26.14,  25.95,  25.76,  25.57,  25.39,  25.20,  25.02,  24.84,  24.67,
  24.49,  24.32,  24.14,  23.97,  23.80,  23.64,  23.47,  23.31,  23.15,  22.99,
  22.83,  22.67,  22.52,  22.36,  22.21,  22.06,  21.91,  21.77,  21.62,  21.48,

  21.33,  21.19,  21.05,  20.91,  20.78,  20.64,  20.50,  20.37,  20.24,  20.11,
  19.98,  19.85,  19.72,  19.60,  19.47,  19.35,  19.23,  19.11,  18.99,  18.87,
  18.75,  18.63,  18.52,  18.40,  18.29,  18.18,  18.07,  17.96,  17.85,  17.74,
  17.63,  17.52,  17.42,  17.31,  17.21,  17.11,  17.01,  16.91,  16.81,  16.71,
  16.61,  16.51,  16.42,  16.32,  16.22,  16.13,  16.04,  15.95,  15.85,  15.76,
  15.67,  15.58,  15.50,  15.41,  15.32,  15.24,  15.15,  15.06,  14.98,  14.90,
  14.81,  14.73,  14.65,  14.57,  14.49,  14.41,  14.33,  14.26,  14.18,  14.10,
  14.02,  13.95,  13.87,  13.80,  13.73,  13.65,  13.58,  13.51,  13.44,  13.37,
  13.30,  13.23,  13.16,  13.09,  13.02,  12.95,  12.89,  12.82,  12.75,  12.69,
  12.62,  12.56,  12.49,  12.43,  12.37,  12.31,  12.24,  12.18,  12.12,  12.06,

  12.00,  11.94,  11.88,  11.82,  11.76,  11.71,  11.65,  11.59,  11.53,  11.48,
  11.42,  11.37,  11.31,  11.26,  11.20,  11.15,  11.09,  11.04,  10.99,  10.94,
  10.88,  10.83,  10.78,  10.73,  10.68,  10.63,  10.58,  10.53,  10.48,  10.43,
  10.38,  10.34,  10.29,  10.24,  10.19,  10.15,  10.10,  10.05,  10.01,   9.96,
   9.92,   9.87,   9.83,   9.78,   9.74,   9.70,   9.65,   9.61,   9.57,   9.52,
   9.48,   9.44,   9.40,   9.36,   9.32,   9.27,   9.23,   9.19,   9.15,   9.11,
   9.07,   9.03,   9.00,   8.96,   8.92,   8.88,   8.84,   8.80,   8.77,   8.73,
   8.69,   8.65,   8.62,   8.58,   8.55,   8.51,   8.47,   8.44,   8.40,   8.37,
   8.33,   8.30,   8.26,   8.23,   8.20,   8.16,   8.13,   8.10,   8.06,   8.03,
   8.00,   7.96,   7.93,   7.90,   7.87,   7.84,   7.80,   7.77,   7.74,   7.71,

   7.68,   7.65,   7.62,   7.59,   7.56,   7.53,   7.50,   7.47,   7.44,   7.41,
   7.38,   7.35,   7.32,   7.30,   7.27,   7.24,   7.21,   7.18,   7.16,   7.13,
   7.10,   7.07,   7.05,   7.02,   6.99,   6.97,   6.94,   6.91,   6.89,   6.86,
   6.84,   6.81,   6.78,   6.76,   6.73,   6.71,   6.68,   6.66,   6.63,   6.61,
   6.58,   6.56,   6.54,   6.51,   6.49,   6.46,   6.44,   6.42,   6.39,   6.37,
   6.35,   6.32,   6.30,   6.28,   6.26,   6.23,   6.21,   6.19,   6.17,   6.14,
   6.12,   6.10,   6.08,   6.06,   6.04,   6.01,   5.99,   5.97,   5.95,   5.93,
   5.91,   5.89,   5.87,   5.85,   5.83,   5.81,   5.79,   5.77,   5.75,   5.73,
   5.71,   5.69,   5.67,   5.65,   5.63,   5.61,   5.59,   5.57,   5.55,   5.53,
   5.52,   5.50,   5.48,   5.46,   5.44,   5.42,   5.41,   5.39,   5.37,   5.35,

   5.33,   5.32,   5.30,   5.28,   5.26,   5.25,   5.23,   5.21,   5.19,   5.18,
   5.16,   5.14,   5.13,   5.11,   5.09,   5.08,   5.06,   5.04,   5.03,   5.01,
   4.99,   4.98,   4.96,   4.95,   4.93,   4.92,   4.90,   4.88,   4.87,   4.85,
   4.84,   4.82,   4.81,   4.79,   4.78,   4.76,   4.75,   4.73,   4.72,   4.70,
   4.69,   4.67,   4.66,   4.64,   4.63,   4.62,   4.60,   4.59,   4.57,   4.56,
   4.54,   4.53,   4.52,   4.50,   4.49,   4.48,   4.46,   4.45,   4.43,   4.42,
   4.41,   4.39,   4.38,   4.37,   4.35,   4.34,   4.33,   4.32,   4.30,   4.29,
   4.28,   4.26,   4.25,   4.24,   4.23,   4.21,   4.20,   4.19,   4.18,   4.16,
   4.15,   4.14,   4.13,   4.12,   4.10,   4.09,   4.08,   4.07,   4.06,   4.04,
   4.03,   4.02,   4.01,   4.00,   3.99,   3.97,   3.96,   3.95,   3.94,   3.93,

   3.92,   3.91,   3.90,   3.88,   3.87,   3.86,   3.85,   3.84,   3.83,   3.82,
   3.81,   3.80,   3.79,   3.78,   3.77,   3.76,   3.75,   3.73,   3.72,   3.71,
   3.70,   3.69,   3.68,   3.67,   3.66,   3.65,   3.64,   3.63,   3.62,   3.61,
   3.60,   3.59,   3.58,   3.57,   3.56,   3.55,   3.54,   3.53,   3.53,   3.52,
   3.51,   3.50,   3.49,   3.48,   3.47,   3.46,   3.45,   3.44,   3.43,   3.42,
   3.41,   3.40,   3.40,   3.39,   3.38,   3.37,   3.36,   3.35,   3.34,   3.33,
   3.32,   3.32,   3.31,   3.30,   3.29,   3.28,   3.27,   3.26,   3.26,   3.25,
   3.24,   3.23,   3.22,   3.21,   3.20,   3.20,   3.19,   3.18,   3.17,   3.16,
   3.16,   3.15,   3.14,   3.13,   3.12,   3.12,   3.11,   3.10,   3.09,   3.08,
   3.08,   3.07,   3.06,   3.05,   3.05,   3.04,   3.03,   3.02,   3.02,   3.01,
};


/*
 * Convertion table, db to linear, 87 dB --> 32767
 *                                 86 dB --> 29491 (1 dB down = 0.5**1/6)
 *                                 ...
 *                                 81 dB --> 16384 (6 dB down = 0.5)
 *                                 ...
 *                                  0 dB -->     0
 *
 * The just noticeable difference for a change in intensity of a vowel
 *   is approximately 1 dB.  Thus all amplitudes are quantized to 1 dB
 *   steps.
 */

static float amptable[88] = {
       0.0,    0.0,    0.0,    0.0,    0.0,
	   0.0,    0.0,    0.0,    0.0,    0.0,
	   0.0,    0.0,    0.0,  0.006,  0.007,
 	 0.008,  0.009,  0.010,  0.011,  0.013,
	 0.014,  0.016,  0.018,  0.020,  0.022,
	 0.025,  0.028,  0.032,  0.035,  0.040,
	 0.045,  0.051,  0.057,  0.064,  0.071,
	 0.080,  0.090,  0.101,  0.114,  0.128,
     0.142,  0.159,  0.179,  0.202,  0.227,
	 0.256,  0.284,  0.318,  0.359,  0.405,
	 0.455,  0.512,  0.568,  0.638,  0.719,
	 0.811,  0.911,  1.024,  1.137,  1.276,
	 1.438,  1.622,  1.823,  2.048,  2.273,
	 2.552,  2.875,  3.244,  3.645,  4.096,
	 4.547,  5.104,  5.751,  6.488,  7.291,
	 8.192,  9.093, 10.207, 11.502, 12.976,
	14.582, 16.384, 18.350, 20.644, 23.429,
	26.214, 29.491, 32.767
};


/* The following array converts tilt in dB at 3 kHz to BW of a resonator
   used to tilt down glottal spectrum, set F of resonator to .6 BW */

/* It is probably a good idea, at least for female voices, to set AH
   equal to TILT+36, truncating to a maximum of 56 */

/* Where the 36 is a speaker defining constant */
/* And maybe the 56 is too */

/* And maybe there should be constraints on legal combinations of values
   for OQ and TILT such that small OQ not compatable with large TILT */
/* Or OQ = f(TILT) */

static int lineartilt[42] = {
	5000,	4350,	3790,	3330,	2930,
	2700,	2580,	2468,	2364,	2260,
	2157,	2045,	1925,	1806,	1687,
	1568,	1449,	1350,	1272,	1199,
	1133,	1071,	 1009,	 947,	 885,
	 833,	 781,	 729,	 677,	 625,
	 599,	 573,	 547,	 521,	 495,
	 469,	 442,	 416,	 390,	 364,
	 338,	 312
};

/* Measured response of the 2-pole tilt resonator: 

	F	BW	A@250Hz	A@1kHz	A@2kHz	A@3kHz	A@4kHz
	3000	5000	42	42	43	44	44
	2250	3750	42	42	42	42	41
	1500	2500	42	42	41	39	36
	1125	1875	42	42	39	33	30
	 750	1250	42	41	32	27	23
	 567	 937	42	37	27	21	17
	 375	 625	42	32	21	15	11
	 283	 469	42	27	16	 9	 5
	 187	 312	40	22	10	 3	 0
*/

/* Convert SQ (speed quotient) into a negative bandwidth for Fant model */
/* of the glottal waveform (SS=3), these are bandwidths times 10 */

static int bwfanttab[42] = {
	  -0,  -6, -20, -40, -60,  -80,-104,-127,-153,-178,
	-201,-224,-247,-270,-292, -314,-336,-358,-379,-400,
	-421,-441,-462,-483,-504, -524,-545,-566,-587,-608,
	-627,-645,-663,-681,-699, -716,-733,-750,-766,-782,
	-796,-810
};

/* Convert SQ (speed quotient) into gain factor to make Ug(t) peak */
/* constant in Fant model (ss=3), fantgain[(SQ/10 - 10] */

static float fantgain[42] = {
	27.4, 26.3, 25.3, 24.3, 23.2,  22.1, 21.0, 20.0, 18.8, 17.6,
	16.1, 14.9, 13.8, 12.8, 11.7,  10.6, 9.81, 9.00, 8.12, 7.36,
	6.60, 6.05, 5.46, 4.92, 4.41,  3.94, 3.58, 3.14, 2.83, 2.49,
	2.24, 2.03, 1.83, 1.63, 1.48,  1.32, 1.19, 1.08, .982, .902,
	.832, .770
};


/* need to look at these more carefully */
static float noiseinlast, lastin;	/* debug see gen_noise */
static float glotlast;				/* Previous value of glotout */
static float noiselast;				/* Used to first-difference random number for aspir */
static int sigmx;                
static int disptcum;				/* Cum # samples, used for debugging */
