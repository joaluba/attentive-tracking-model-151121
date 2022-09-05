function sigbin= traj2sig(T,sConfSG)
% Function to turn the hidden state trajectory into a signal.
% ---- Input: -----
% T - parameter trajectory
% sConfSG - config struct for signal generation
% ---- Output: -----
% sigbin - two-channel acoustic signal 
% ---------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de


[~, sigbin] = auralise_hidden_states(T,sConfSG.fs_pf,sConfSG.fs,sConfSG.r,sConfSG.render);

end

