function Particles_out=sortparticles(Particles_in)
% Function to sort particles
[Particles_out.H, v_ind]=sort(Particles_in.H );
Particles_out.W=Particles_in.W(v_ind);
end