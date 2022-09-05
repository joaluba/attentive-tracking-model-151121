function sParticles_out=pf_init_all_uniform(sConfPF_this,sConfPF_that)
% Function to initialize particles 
% ---- Input: -----
% sConfPF_this,sConfPF_that - configuration struct for the considered and concurrent stream 
% ---- Output: -----
% Particles_out - inital particles 
% ---------------------------------------
% Range is the parameter specific for uniform distribution - here the
% possible range values are defined for each state element. 

% random value in interval [a, b]
a=repmat(sConfPF_this.pdf_init.range(:,1),1,sConfPF_this.K);
b=repmat(sConfPF_this.pdf_init.range(:,2),1,sConfPF_this.K);
sParticles_out.H = round(a + (b-a).*rand(sConfPF_this.D_y,sConfPF_this.K));
sParticles_out.W=1/300*ones(1,sConfPF_this.K);
end