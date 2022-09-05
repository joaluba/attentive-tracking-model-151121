function sParticles_out=pf_obsstat_F0model(sConfPF,sParticles_in,O_seg)
% Function to execute the update step of the particle filter
% Weight for each particle is computed using F0 likelihood function
% ----------- Input: ------------
% sConfPF - config struct of a particle filter
% sParticles_in - current particles
% O_seg - current segregated sPAF features
% ----------- Output: ------------
% sParticles_out - particles with updated weights
% --------------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

if ~isnan(O_seg)
    
    H=sParticles_in.H;
    [D_y K]=size(H);    
    
    % group glimpses according to channels
    % (glimpses from one channel go toghether)
    [O_seg_grouped, covered_chan]=pf_group_channelglimpses(O_seg);
    
    % allocate weight matrix 
    W_tmp=zeros(K,length(covered_chan));
    % loop across all particle hypotheses
    for k=1:K
        % currently tested hypothesis
        s_tmp=H(k);
        % loop across channels of the sPAF observation
        for cc=1:length(covered_chan)
            % compute weights in each channel
            W_tmp(k,cc)=sConfPF.pdf_obsstat.evalfun(s_tmp,O_seg_grouped{cc},covered_chan(cc),sConfPF);
        end
    end
    
    % compute support for ech particle (accum. across channels)
    W=sConfPF.pdf_obsstat.accuchan(W_tmp);
    
    % weight update rule
    Wout=sConfPF.weightup.fun(W,sParticles_in.W);
    
else
    Wout=sParticles_in.W;
end

sParticles_out.W=Wout;
% normalize weights so that they sum to 1
sParticles_out.W=(sParticles_out.W/sum(sParticles_out.W));
sParticles_out.H=sParticles_in.H;
end
