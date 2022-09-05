function [O_fg, O_bg]=pf_FGBGseg_ver3(sConfPF_fg,sConfPF_bg,O_mix,s_EST_fg,s_EST_bg)
% Function to segregate sPAF into foreground and background stream.
% For each voice, a channel-dependent weight is computed. This reflects the energy
% distribution over frequency channels for a given combination of
% previous estimated F0 and ground truth F1 & F2. The channel set P_cn is
% assigned to the voice for which the energy is larger.
% ---- Input: -----
% confPF_fg, confPF_bg - config struct for foreground and background
% O_mix  - observation for the mixture (sPAF)
% s_EST_fg, s_EST_bg - previous state estimate for foreground and background
% ---- Output: -----
% O_fg - observation (sPAF) assigned to foreground
% O_bg - observation (sPAF) assigned to background
% ---------------------------------------------
% author: joanna.luberadzka@uni-oldenburg.de


O_fg=[];
O_bg=[];

if ~isempty(O_mix)
    
    [O_mix_grouped, covered_chan]=pf_group_channelglimpses(O_mix);
    
    % ground-truth states from the previous time instance
    s_GT_fg=sConfPF_fg.T_GT(sConfPF_fg.n-1,:);
    s_GT_bg=sConfPF_bg.T_GT(sConfPF_bg.n-1,:);
    % compute spectral power of foreground
    E_fg=spectralpower(s_EST_fg,s_GT_fg(2),s_GT_fg(3));
    % compute spectral power of background
    E_bg=spectralpower(s_EST_bg,s_GT_bg(2),s_GT_bg(3));
    % normalize so that sum in each channel is equal to 1
    E_fg=E_fg./sum(E_fg);
    E_bg=E_bg./sum(E_bg);
    
    for i=1:length(covered_chan)
        P_cn=O_mix_grouped{i};
        % compare weight for fg and bg voice
        delta1=E_fg(i);
        delta2=E_bg(i);
        W=[delta1 delta2];
        deltadiff=W(1)-W(2);
        % the voice with the higher weight gets glimpses
        if deltadiff>0
            O_fg=[O_fg P_cn];
        elseif deltadiff<0
            O_bg=[O_bg P_cn];
        else
            O_fg=[O_fg P_cn];
            O_bg=[O_bg P_cn];
        end
    end
    
end
end


