function sParticles_out=pf_init_attended(sConfPF_this,sConfPF_that)
% Function to intialize particles in the foreground particle filter.
% Foreground voice tracking is initialized using the true value for the
% foreground voice -The particles are drawn from a gaussian centered at the 
% initial ground truth F0.
% ---- Input: -----
% confPFfg,confPFbg - configuration struct for foreground and background
% ---- Output: -----
% Particles_out - inital particles 
% ---------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

a=repmat(sConfPF_this.pdf_init.range(:,1),1,10000);
b=repmat(sConfPF_this.pdf_init.range(:,2),1,10000);
sigma=sConfPF_this.pdf_init.sigma;
s_start=sConfPF_this.T_GT(1,1);
dist_interp.H = a + (b-a).*rand(sConfPF_this.D_y,10000);
dist_norm=normpdf(s_start,s_start,sigma);
dist_interp.W = dist_norm*normpdf(dist_interp.H,s_start,sigma);
dist_interp.W =dist_interp.W./sum(dist_interp.W);
sParticles_out.H= datasample(dist_interp.H,sConfPF_this.K,2,'Weights',dist_interp.W);
sParticles_out.W=1/300*ones(1,sConfPF_this.K);

end