function implot_channel(m3,ch,vT,vP)
A=squeeze(m3(ch,:,:));
A(~nonzeros(A))=nan;
imagesc(A);
xlabel('time [s]');xticks(1:10:length(vT));
xticklabels(round(vT(1:10:end)*100)/100);xtickangle(45);
ylabel('period [s]');yticks(1:20:length(vP));yticklabels(round(vP(1:20:end)*1000)/1000);
title(['freq. channel ', num2str(ch)]);
grid on
cmap = [1 1 1; parula];
colormap(cmap);
colorbar;
end