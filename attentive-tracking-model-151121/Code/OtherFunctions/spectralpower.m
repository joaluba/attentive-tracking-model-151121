function E= spectralpower(F0,F1,F2)
    % Function to compute spectral energy per channel for
    % a hypothetical F0, F1, and F2 values. 
    % -------------------------------------
    % contact: joanna.luberadzka@uni-oldenburg.de
    
    % generate a state trajectory 
    sConfTG=config_TG_default;
    T=gen_traj({num2str(F0),num2str(F1),num2str(F2)},0.5,sConfTG);
    % generate signal based on that trajectory
    sConfSG=config_SG_default;
    sig=traj2sig(T, sConfSG);
    % pass through auditory preproc.
    sConfFE=config_FE_default;
    [audit_sigs, ~]=auditorypreproc(sig(:,1),sConfFE);
    % compute signal power
    cutoff_power=2.5;
    [b, a] = butter(3, cutoff_power/(sConfFE.fs/2),'low');
    sigs_pow= filter(b,a,audit_sigs,[],2);
    % compute the power-weight for each frequency band
    E=sum(sigs_pow(:,4000:end),2);
    
end
