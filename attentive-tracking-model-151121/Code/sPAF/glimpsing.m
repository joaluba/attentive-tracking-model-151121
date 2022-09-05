function [mPG_Etot_ch,mPG_Erel_ch, mPD_ch]=glimpsing(pres,ptot,T1,T2)
% This function performs the glimpsing of the periodicity features - it
% gets rid of all the information that is not reliable (and possibly 
% originates from a superposition of two signals)
% ---------- Input: ------------
% pres - periodic energy computed with a synchrogam method
% ptot - total energy computed with a synchrogram method
% T1   - first glimpsing criterion
% T2   - second glimpsing criterion 
% ---------- Output: ------------
% mPG_ch - matrix with the normalized periodic energy at glimpsed periods
% mPD_ch - matrix with the normalized periodic energy at all periods
% -----------------------------------------------------------------------
% Joanna Luberadzka 2020 
mPG_Erel_ch=zeros(size(pres));
mPG_Etot_ch=zeros(size(pres));
% compute relative energy
prel = pres./ptot;
mPD_ch=prel;
for t=1:size(prel,2);
    % pick one slice of a normalized synchrogram - synchrum
    synchrum_t=prel(:,t);
    total_t=ptot(:,t);
    % find all the local maxima
    [v_max_synch, v_idx_synch] = findmaxima(synchrum_t);
    % if the global maximum exceeds the first treshold...
    if max(v_max_synch)>T1
        % ...then look for the local maxima that exceed the second
        % threshold (which is set relative to the global maximum)...
        T2frame=T2*max(v_max_synch);
        glimpse_idx=v_idx_synch(v_max_synch>T2frame);
        % normalized energy at a glimpse
        mPG_Erel_ch(glimpse_idx,t)=synchrum_t(glimpse_idx);
        % total energy at a glimpse
        mPG_Etot_ch(glimpse_idx,t)=total_t(glimpse_idx);
    end
end

end

function [maxima_vals, maxima] = findmaxima(x)
% Unwrap to vector
x = x(:);
% Identify whether signal is rising or falling
upordown = sign(diff(x));
% Find points where signal is rising before, falling after
maxflags = [upordown(1)<0; diff(upordown)<0; upordown(end)>0];
% aj [20130426]: modified, so that only peaks, no (global)
% maxima are chosen (maxima at first and last values of X)
if length(maxflags) == length(x)
    maxflags(1) = 0;
    maxflags(end) = 0;
end
maxima   = find(maxflags);
maxima_vals = x(maxima);
end