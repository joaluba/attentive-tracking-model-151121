function implot_3dscatter(inputfeat,vfc,vP,vT)

if iscell(inputfeat)
    n=1;
    for t=1:length(inputfeat)
        for m=1:size(inputfeat{t},2)
            [diff, P_idx]= min(abs(vP-inputfeat{t}(3,m)));
            P(n)=vP(P_idx);
            C(n)= inputfeat{t}(2,m);
            T(n)=t;
            E(n)=20*log10(inputfeat{t}(5,m));
            n=n+1;
        end
    end
else 
    E=[];P=[];T=[];C=[];
    for t=1:size(inputfeat,3)
        mPG_temp=squeeze(inputfeat(:,:,t));
        [idx_chan, idx_period,val]=find(mPG_temp);
        P=[P vP(idx_period)];
        C=[C idx_chan'];
        T=[T t*ones(1,numel(idx_chan))];
        E=[E 20*log10(val)'];
    end
end

Ergb=double2rgb(E,autumn);
sizee=50*ones(length(C),1);
scatter3(P,T,C,sizee,Ergb,'s','filled','MarkerEdgeColor',[0.2 0.2 0.2],'MarkerFaceAlpha',1)
% colormap(colormapname)
view([180 180 180])
xlabel('Period [s]','Rotation',20);
ylim([0 numel(vT)]);ylabel('time [t]','Rotation',-20);
zlabel('Channel center freq [Hz]');
zticks(1:1:23);zticklabels(vfc);
hold on;

end

function col=double2rgb(x,colormapname)
mini=min(x);
maxi=max(x);
vals=linspace(mini,maxi,length(colormapname));
% y=floor(((x-mini)/ran))+1; 
col=zeros(length(x),3);
p=colormap(colormapname);
for i=1:length(x)
    [v idx]=min(abs(vals-x(i)));
    col(i,:)=p(idx,:);
end
end