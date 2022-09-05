function [O_grouped, covered_chan]=pf_group_channelglimpses(O)
% Function to group observed sPAF to nonempty channels
% ---- Input: -----
% O - matrix containing sPAF in a given time instance
% O(1,:): side (left/right)
% O(2,:): channel number
% O(3,:): salient period
% O(4,:): relative periodic energy
% O(5,:): total energy
% ---- Output: -----
% obs_tmp_grouped - cell array with grouped sPAF
% covered_chan - corresponding channel numbers
% ------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de


if isempty(O)
    O_grouped=[];
    covered_chan=0;
else
    covered_chan=unique(O(2,:));
    for i=1:length(covered_chan)
        O_grouped{i}=O(:,O(2,:)==covered_chan(i));
    end
end
