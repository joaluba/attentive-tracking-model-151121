function L_P_cn=pf_eval_VM_mix_normn(s,O_c,c,sConfPF)
% Function to evalate the likelihood of the observation given state:
% here it's the likelihood of the observed salient periods given a
% certain F0 value.
% ---- Input: -----
% s - hypothetical state
% O_c - observation in channel c
% c  - channel for which the likelihood is being calculated
% sConfPF - config struct for a particle filter
% ---- Output: -----
% L_P_cn - likelihood for the considered channel
% ----------------------------------------
% author: joanna.luberadzka@uni-oldenburg.de


% hypothetical F0 (1st dimension of the state)
F0=s(1);

if isempty(O_c)
    L_P_cn=nan;
else

    % Access the period value, which is the
    % third dimension of the observed sPAF
    P_cn=O_c(3,:)';
    I=length(P_cn);
    
    % We consider 11 partials contributing to the
    % overall probability. This contribution is weighted,
    % since the higher the partial the less it influences
    % the overall pitch perception. For each partial we compute
    % a weight in the following way:
    J=11;
    v_j=1:1:J;
    C_j=v_j.^(-1);
    C_j=C_j./sum(C_j);
    
    % Here the likelihood function starts
    vm_mu=0;
    vm_C= 1/(2*pi*besseli(0,sConfPF.pdf_obsstat.kappa,1));
    
    L_Rcnm=zeros(J,I);
    L_ij=zeros(J,I);
    for v_j=1:J
        % express in terms of phase angle
        R_cn=P_cn*(v_j*F0)*2*pi;
        % evaluate each observed period individually
        for i=1:I
            R_cnm=R_cn(i);
            % circular von-Mises probability distribution
            [L_Rcnm(v_j,i), ~]=circ_vmpdf(R_cnm,vm_mu,sConfPF.pdf_obsstat.kappa,vm_C);
            % weight contribution of j-th partial
            L_ij(v_j,i)= L_Rcnm(v_j,i)*C_j(v_j);       
        end
    end
    
    % likelihoods from every harmonic number j are added
    L_i=sum(L_ij,1);
    % integrate likelihood within one channel
    L_P_cn=sConfPF.pdf_obsstat.accugli(L_i);
    
end
end

