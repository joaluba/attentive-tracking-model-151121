function sParticles_new=pf_sysdyn_allextrapolate(sConf,sParticles_old,sParticles_oldold)
% This function defines the state transition model used to predict new particles. 
% Every new particle is drawn from a Gaussian centered at the value
% extrapolated based on two previous particle values with that index. 
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


H_old=sParticles_old.H;
H_oldold=sParticles_oldold.H;
[D_y Kk]=size(H_old);

% difference between last two particle sets
H_diff=H_old-H_oldold;

% limits of how far it can get from a previous value
m_sigma=repmat(sConf.pdf_sysdyn.sigma,1,Kk);
% if difference bigger then allowed step - set difference to zero 
idx_interptoobig=(abs(H_diff)>5*m_sigma);
H_diff(idx_interptoobig)=0;
% extrapolated value
H_tilde=H_old+H_diff;

% limits of the possible values
v_A=sConf.pdf_sysdyn.range(:,1);
m_A=repmat(v_A,1,Kk);
v_B=sConf.pdf_sysdyn.range(:,2);
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
Idx= (H_pred<m_A | H_pred>m_B | H_pred<H_tilde-5*m_sigma | H_pred>H_tilde+5*m_sigma);
% if not in the range - take new sample
H_pred(Idx)=H_tilde(Idx)+m_sigma(Idx).*randn(size(H_pred(Idx)));
end

sParticles_new.H=H_pred;
sParticles_new.W=sParticles_old.W;
