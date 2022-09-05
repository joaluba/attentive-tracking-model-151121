function [O_fg, O_bg]=pf_FGBGseg_ver1ver2(confPF_fg,confPF_bg,O_mix,s_EST_fg,s_EST_bg)
% Function to segregate sPAF into foreground and background voice.
% For each voice, a likelihood of the observed channel set P_cn  given the 
% previous F0 value (estimated or ground truth) is computed via the likelihood function. 
% The likelihoods are compared and the set P_cn is assigned to
% the voice for which the likelihood is larger.
% ---- Input: -----
% confPF_fg, confPF_bg - config struct for foreground and background
% O_mix  - observation for the mixture (sPAF)
% s_EST_fg, s_EST_bg - previous state estimate for foreground and background 
% ---- Output: -----
% O_fg - observation (sPAF) assigned to foreground
% O_bg - observation (sPAF) assigned to background
% ---------------------------------------------
% Joanna Luberadzka 2020

O_fg=[];
O_bg=[];

if ~isempty(O_mix)
    
    % group glimpses by channels
    [O_mix_grouped, covered_chan]=pf_group_channelglimpses(O_mix);
    
    % for each channel...
    for i=1:length(covered_chan)
        % Pick glimpses from a given channel
        P_cn=O_mix_grouped{i};
        % compute likelihood of channel set P_cn given previous fg voice estimate
        delta_fg=confPF_fg.pdf_obsstat.evalfun(s_EST_fg,P_cn,covered_chan(i),confPF_fg);
        % compute likelihood of channel set P_cn given previous bg voice estimate
        delta_bg=confPF_bg.pdf_obsstat.evalfun(s_EST_bg,P_cn,covered_chan(i),confPF_bg);
        % Compare likelihoods
        W=[delta_fg delta_bg];
        deltadiff=W(1)-W(2);
        
        % concatenate segregated channel set 
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
