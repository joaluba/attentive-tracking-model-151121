README
_____________________________

Attentive Tracking Stimulus Generation 
(Woods & McDermott 2015, Current Biology)
______________________________

Run on 32-bit MATLAB (due to Klatt implementation)
_______________________________


To get started, simply run ‘att_tracking_genstim.m’ on 32-bit MATLAB.

Generated stimuli are saved in a 2-column cell array, where column 1 has stimuli with correct probes (probe is from the cued voice), while column 2 has stimuli with incorrect probes (probe is from the uncued voice).

_________________________________

Files included in this package:

att_tracking_genstim.m - This script generates sets of attentive tracking stimuli. Trajectory pairs are constrained to cross at least once in each feature dimension, and to maintain some minimum distance in feature space. Constraints are enforced by rejection sampling.

f0f1f2.m - This function generates three trajectories (one for each feature dimension) from low-passed Gaussian noise. Produces input to the Klatt synthesizer. 

gnoise.m - This function generates samples of Gaussian noise.

mlsyn.m - This function interfaces with the mex files that implement Klatt synthesis. The synthesizer itself is in C (thus very fast).

mlsyn_defaults.m - Lists parameters of the Klatt synthesizer. Only a few of these are used in Woods & McDermott 2015.

Att_tracking_make_fig_from_trajs.m - This script produces 3d visualization of a trajectory pair.

_________________________________



Contact kwoods@mit.edu