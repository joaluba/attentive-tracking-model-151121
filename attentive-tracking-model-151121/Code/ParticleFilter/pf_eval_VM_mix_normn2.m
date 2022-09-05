function [prob,varargout]=pf_eval_VM_mix_normn(F0,obs,ch,sConf)
% A function to evalate the likelihood of the observation given state:
% here it's the likelihood of the observed salient periods given a
% certain F0 value.
% ---- Input: -----
% F0 - hypothetical fundamental frequency value [Hz]
% obs - observation
% ch  - channel for which the likelihood is being calculated
% ---- Output: -----
% prob - probability value

if isempty(obs)
    prob=nan;
else
    
    if isstruct(obs)
        G=obs.g;
    else
        G=obs;
    end
    
    % Access the period value, which is the
    % third dimension of an observed glimpse
    G_ch=G(3,:)';
    
    % We consider 11 partials contributing to the
    % overall probability. This contribution is weighted,
    % since the higher the partial the less it influences
    % the overall pitch perception. For each partial we compute
    % a weight in the following way:
    N=11;
    for n=1:N
        P0=1/(n*F0);
        m_max_k=floor(0.0125./P0);
        m_min_k=ceil(0.0014./P0);
        P_n=[m_min_k:1:m_max_k]*P0;
        nnorm(n)=1/length(P_n);
    end
    nnorm=nnorm./sum(nnorm);
    
    
    % Here the likelihood function starts
    mu=0;
    C= 1/(2*pi*besseli(0,sConf.pdf_obsstat.kappa,1));
    for n=1:N
        % relate observed period values to 
        % the period of the n-th partial
        nturns=G_ch*(n*F0);
        % express in terms of phase angle
        theta=nturns*2*pi;
        % evaluate each observed period individually
        for i=1:length(G_ch)
            % circular von-Mises probability distribution
            [p_pure(i,n), ~]=circ_vmpdf(theta(i),mu,sConf.pdf_obsstat.kappa,C);
            % weight contribution of n-th partial
            p(i,n)= p_pure(i,n)*nnorm(n);
            
        end
    end
    
    % likelihood of a glimpse set is a product of 
    % likelihood of glimpses within this set
    
    P.val=sConf.pdf_obsstat.accugli(sum(p,2));
    prob=P.val;
    varargout{1}=sum(p,2);
    
end
end

