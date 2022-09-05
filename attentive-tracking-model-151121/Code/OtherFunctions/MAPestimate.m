function s_EST=MAPestimate(sParticles)
maxval=max(sParticles.W);
indx=find(sParticles.W==maxval);
randidx=indx(randi(length(indx)));
s_EST=sParticles.H(:,randidx);
end