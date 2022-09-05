function matfeat= cellfeat2matfeat(cellfeat,vP,vT,vfc)
% create matrices with nans 
matfeat.m3PG_Etot=nan(23,length(vP),length(vT));
matfeat.m3PG_Erel=nan(23,length(vP),length(vT));
matfeat.m3PD=nan(23,length(vP),length(vT));
matfeat.mE=nan(23,length(vT));

for t=1:length(vT)
    
O=cellfeat.o{t};

% fill the nan matrix with values at the indiced
% corresponding to period and channel 
    for m=1:size(O,2)
    % period - 3rd dimension of a glimpse
    [diff, P_idx]=min(abs(periodgrid-O(3,m)));
    matfeat.m3PD(C_idx,P_idx,t)=1;
    % channel - 2nd dimension of a glimpse
    C_idx=O(2,m);
    % relative energy - 4th dimension of a glimpse
    matfeat.m3PG_Erel(C_idx,P_idx,t)=O(4,m);
    % total energy - 5th dimension of a glimpse
    matfeat.m3PG_Etot(t,C_idx,P_idx,t)=O(5,m);
    % mean channel energy
    matfeat.mE(C_idx,t)=mean(O(5,:));
    end
end
