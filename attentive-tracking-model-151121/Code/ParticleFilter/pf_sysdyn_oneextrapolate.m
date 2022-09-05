function sParticles_new=pf_sysdyn_oneextrapolate(sConfPF,sParticles_old,sParticles_oldold)
% This function defines the state transition model used to predict new particles. 
% Every new particle is drawn from a Gaussian centered at the value
% extrapolated based on two previous estimated values. 
% There are additional limitations to make sure that the particle does not 
% jump too far from the previous value and that it stays within a possible
% value range.
% --------------------- Input: ---------------------------
% sConfPF - config struct of a particle filter 
% sParticles_old - particles in the previous iteration
% sParticles_oldold - particles in 2 iterations ago
% --------------------- Output: ---------------------------
% sParticles_new - predicted particles
% --------------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de


% check if sParticles is a struct or just one state value
if isstruct(sParticles_old)
H_old=sParticles_old.H;
H_oldold=sParticles_oldold.H;
[D_y Kk]=size(H_old);
else
H_old=sParticles_old;
H_oldold=sParticles_oldold;
[D_y Kk]=size(H_old);
end

% compute estimates, since they are not passed as arguments here
if strcmp(sConfPF.est,'expval')
    s_ESTold=sParticles_old.H*sParticles_old.W';
    s_ESToldold=sParticles_oldold.H*sParticles_oldold.W';
elseif strcmp(sConfPF.est,'MAP')
    s_ESTold=MAPestimate(sParticles_old);
    s_ESToldold=MAPestimate(sParticles_oldold);
end


% limits of how far it can get from a previous value
m_sigma=repmat(sConfPF.pdf_sysdyn.sigma,1,Kk);
% compute difference between estimates
s_diff=s_ESTold-s_ESToldold;

if sConfPF.n<4
s_diff=0;
end

% always make the difference a bit smaller and check if
% it's still outside the allowed limit
while abs(s_diff)>10*m_sigma(1,1);
    s_diff=0.8*s_diff;
end

% difference between last two particle sets
H_diff=H_old-H_oldold;
H_diff(:,:)=s_diff;
% extrapolated value
H_tilde=H_old+H_diff;

% limits of the possible values
v_A=sConfPF.pdf_sysdyn.range(:,1);
m_A=repmat(v_A,1,Kk);
v_B=sConfPF.pdf_sysdyn.range(:,2);
m_B=repmat(v_B,1,Kk);
% if not in possible range - set to previous
idx_overalltoobig= (H_tilde<m_A | H_tilde>m_B);
% if extrapolated outside limits - take previous particle
H_tilde(idx_overalltoobig)=H_old(idx_overalltoobig);

% add system noise (here Gaussian)
H_pred=H_tilde+m_sigma.*randn(D_y,Kk);

% check if the sampled value is in the range
Idx=true(D_y,Kk);
Z=false(D_y,Kk);
bla=0;
while any(any(Idx~=Z,1)) && bla<1000
Idx= (H_pred<m_A | H_pred>m_B | H_pred<H_tilde-20*m_sigma | H_pred>H_tilde+20*m_sigma);
% if not in the range - take new sample
H_pred(Idx)=H_tilde(Idx)+m_sigma(Idx).*randn(size(H_pred(Idx)));
bla=bla+1;% not to sample forever
end
Idx=(H_pred<m_A | H_pred>m_B | H_pred<H_tilde-20*m_sigma | H_pred>H_tilde+20*m_sigma);
H_pred(Idx)=H_tilde(Idx);    

sParticles_new.H=H_pred;
sParticles_new.W=sParticles_old.W;
end
