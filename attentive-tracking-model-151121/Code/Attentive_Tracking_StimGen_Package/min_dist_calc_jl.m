function [mindist, loc, dists] = min_dist_calc_jl(A,B)
% function to compute the distance between hidden state trajectories
% Author: Kevin Woods 
% Modified by Joanna Luberadzka

  f0_dist = 12 .* log2((A(:,1)) ./ (B(:,1)));
  f1_dist  = 12 .* log2((A(:,2)) ./ (B(:,2)));
  f2_dist  = 12 .* log2((A(:,3)) ./ (B(:,3)));
    
 dists = sqrt((f0_dist.^2) + (f1_dist.^2) + (f2_dist.^2));
 mindist = min(dists);
 loc = find(dists==mindist);