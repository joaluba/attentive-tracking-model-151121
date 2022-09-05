function imagefeat=feat2image(O)
% Function to transform sPAF features 
% to a matrix
% ---- Input: -----
% O - matrix containing sPAF in a given time instance
% O(1,:): side (left/right)
% O(2,:): channel number
% O(3,:): salient period
% O(4,:): relative periodic energy
% O(5,:): total energy
% ---- Output: -----
% imagefeat: matrix channel x period with nonempty
% values at places where period glimpse occur
% ------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

% vector of tested periods
periodgrid=0.0014:0.0001:0.0125;

% create a matrix with nans 
imagefeat=nan(23,length(periodgrid));

% fill the nan matrix with values at the indiced
% corresponding to period and channel
    for m=1:size(O,2)
    % period - 3rd dimension of a glimpse
    [diff, P_idx]=min(abs(periodgrid-O(3,m)));
    % channel - 2nd dimension of a glimpse
    C_idx=O(2,m);
    imagefeat(C_idx,P_idx)=1;
    end
end
