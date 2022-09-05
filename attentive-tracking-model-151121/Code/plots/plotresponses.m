function plotresponses(res_fgprobe,res_bgprobe,v_r,titlestr)
% Function to plot models responses to a probe
% ------------------- Input: -------------------------------
% res_fgprobe, res_bgprobe- vector with models responses to 
% a fore/background probe for different discrimination thresholds: 
% * if 1 - yes, the probe came from the attended voice
% * if 0 - no, the probe did not come from the attended voice
% v_r- vector with discrim. threshold values
% titlestr - string to put in the title
% --------------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

subplot(2,1,1)
plot(res_fgprobe,'xb','LineWidth',3,'MarkerSize',10)
title('model response when foreground voice is in the probe:')
xticks(1:5:length(v_r));xticklabels(v_r(1:5:end))
yticks([0 1]);yticklabels({'false negative','true positive'});
xlabel('discrimination threshold [Hz]')

subplot(2,1,2)
plot(res_bgprobe,'xr','LineWidth',3,'MarkerSize',10)
title('model response if background voice is in the probe:')
yticks([0 1]);yticklabels({'true negative','false positive'})
xticks(1:5:length(v_r));xticklabels(v_r(1:5:end))
xlabel('discrimination threshold [Hz]')

sgtitle({'Model''s response given different discrimination thresholds';titlestr})
end