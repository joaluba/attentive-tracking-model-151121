function [res_posprobe, res_negprobe]=trialresponse(T_GT_fg,T_GT_bg,T_EST_fg, r)
res_posprobe=0;
res_negprobe=0;
% compare to positive probe (correct answ=yes)
DELTA_GT1=sqrt(mean((T_GT_fg(end-25:end,1) - T_EST_fg(end-25:end,1)).^2));
% compare to negative probe (correct answ=no)
DELTA_GT2=sqrt(mean((T_GT_bg(end-25:end,1) - T_EST_fg(end-25:end,1)).^2));

if DELTA_GT1<r
    % positive response to positive probe (true positive)
    res_posprobe=1;
end
if DELTA_GT2<r
    % positive response to negative probe (false positive)
    res_negprobe=1;
end
end