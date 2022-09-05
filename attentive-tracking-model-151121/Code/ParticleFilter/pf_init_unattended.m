function sParticles_out=pf_init_unattended(sConfPF_this, sConfPF_that)
% Function to intialize particles in the background particle filter.
% Background  voice tracking is initialized using the true value for the
% foreground voice - the particles are distributed everywhere else but 
% not where the foreground voice starts ('negative' gaussian). 
% ---- Input: -----
% sConfPF_this,sConfPF_that - configuration struct for the considered and concurrent stream 
% ---- Output: -----
% Particles_out - inital particles 
% ---------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

a=repmat(sConfPF_this.pdf_init.range(:,1),1,10000);
b=repmat(sConfPF_this.pdf_init.range(:,2),1,10000);
sigma=sConfPF_this.pdf_init.sigma;
s_start=sConfPF_that.T_GT(1,1);
dist_interp.H = a + (b-a).*rand(sConfPF_this.D_y,10000);
dist_norm=normpdf(s_start,s_start,sigma);
dist_interp.W = 1-((1/dist_norm)*normpdf(dist_interp.H,s_start,sigma));
dist_interp.W =dist_interp.W./sum(dist_interp.W);
sParticles_out.H= datasample(dist_interp.H,sConfPF_this.K,2,'Weights',dist_interp.W);
sParticles_out.W=1/sConfPF_this.K*ones(1,sConfPF_this.K);

end