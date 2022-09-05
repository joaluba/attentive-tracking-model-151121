function implot_3dscatter_noE(inputfeat,vfc,vP,vT,colormap,titlestr)
% Function to plot period glimpses in 3D
% ----------- Input: -------------
% inputfeat - sPAF features
% vfc - vector with channel center frequencies
% vP - vector with all tested periods
% vT - vector with time stamps
% colormap - colormap (name or rgb matrix)
% titlestr - string to put in the title
% ----------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

    if iscell(inputfeat)
        E=nan(1,1);P=nan(1,1);C=nan(1,1);T=nan(1,1);
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
    
    E=ones(size(E)) ;% if no energy in the plot
    Ergb=double2rgb(E,colormap);
    sizee=50*ones(length(C),1);
    scatter3(P,T,C,sizee,Ergb,'s','filled','MarkerEdgeColor',[0.2 0.2 0.2],'MarkerFaceAlpha',1)
    view([180 180 180])
    xlabel('Period [s]','Rotation',20);
    ylim([0 numel(vT)]);ylabel('time [t]','Rotation',-20);
    zlabel('Channel center freq [Hz]');
    zticks(1:1:23);zticklabels(vfc);
    hold on;
    title({'sPAF across time, period and frequency' ;titlestr})
    
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
