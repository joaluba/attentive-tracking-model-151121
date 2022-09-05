function [mindist, loc, dists] = min_dist_calc(A,B)


  f0_dist = 12 .* log2((A(:,2)./10) ./ (B(:,2)./10));
  f1_dist  = 12 .* log2((A(:,4)) ./ (B(:,4)));
  f2_dist  = 12 .* log2((A(:,5)) ./ (B(:,5)));
    
 dists = sqrt((f0_dist.^2) + (f1_dist.^2) + (f2_dist.^2));
 mindist = min(dists);
 loc = find(dists==mindist);