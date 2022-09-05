function implot_timeinst(m3,t,vfc,vP)
if iscell(m3)
    A=nan(23,length(vP));
    for m=1:size(m3{t},2)
        [diff, P_idx]=min(abs(vP-m3{t}(3,m)));
        C_idx=m3{t}(2,m);
        P_val=20*log10(m3{t}(5,m));
        A(C_idx,P_idx)=P_val;
    end
    A=A';
else
    
    A=squeeze(m3(:,:,t))';
    A(~nonzeros(A))=nan;
    
end
    imagesc(A);
    xlabel('center frequency [Hz]');xticks(1:23);xticklabels(vfc);xtickangle(45);
    ylabel('period [s]');yticks(1:20:length(vP));yticklabels(round(vP(1:20:end)*1000)/1000);
    title(['time instance ', num2str(t)]);
    colorbar;
    grid on
    cmap = [1 1 1; cool];
    colormap(cmap);
    colorbar;
end