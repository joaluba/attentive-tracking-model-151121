function [dists] = distf0_calc_jl(A,B)


  f0_dist = 12 .* log2((A(:,1)) ./ (B(:,1)));
%   f1_dist  = 12 .* log2((A(:,2)) ./ (B(:,2)));
%   f2_dist  = 12 .* log2((A(:,3)) ./ (B(:,3)));
%     
 dists = sqrt((f0_dist.^2));