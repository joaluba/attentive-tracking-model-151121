function cellfeat= matfeat2cellfeat(matfeat,vP,vT,vfc)
for t=1:length(vT)
    
    mPG_temp=squeeze(matfeat.m3PG_Erel(:,:,t));
    [idx_chan, idx_period]=find(mPG_temp);
    
    g=zeros(5,numel(idx_chan));
    for m=1:numel(idx_chan)
        % glimpse dimension 1: side
        g(1,m)=1;
        % glimpse dimension 2: fc
        g(2,m)=idx_chan(m);
        % glimpse dimension 3: period
        g(3,m)=vP(idx_period(m));
        % glimpse dimension 4: Erel
        g(4,m)=matfeat.m3PG_Erel(idx_chan(m),idx_period(m),t);
        % glimpse dimension 5: Etot
        g(5,m)=matfeat.m3PG_Etot(idx_chan(m),idx_period(m),t);
    end
    cellfeat.o{t}=g;
end
end