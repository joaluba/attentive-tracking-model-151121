function plotparticleevol_online(ax,sConfPF_fg,sConfPF_bg,sParticles_fg,sParticles_bg,s_EST_fg,s_EST_bg,colormaps)
% Function to plot evolution of the particle filter weights 
% (called inside a particle filter loop) 
% -------------------- Input: -------------------------
% ax - cell containing figure axes (output of the function ax_prep.)
% sConfPF_fg, sConfPF_bg - config struct for fore/background
% sParticles_fg, sParticles_bg - current fore/background particles
% s_EST_fg, s_EST_bg - current fore/background state estimate
% colormaps - cell containing colormaps (output of the function ax_prep.m)
% ----------------------------------------------------
% contact: joanna.luberadzka@uni-oldenburg.de

set(gca,'FontSize',13)
hold (ax{1},'on')

% in the first iteration plot ground truth trajectories
if sConfPF_fg.n==2
    plot(ax{1},1:1:length(sConfPF_bg.T_GT),sConfPF_bg.T_GT(:,1),'-r','LineWidth',2);
    plot(ax{1},1:1:length(sConfPF_fg.T_GT),sConfPF_fg.T_GT(:,1),'-b','LineWidth',2);
    text(73,380,'Background voice','Color','red','FontSize',14)
    text(73,390,'Foreground voice','Color','blue','FontSize',14)
end

% colormaps
colormap_fg=colormaps{2}(1:2:end,:);
colormap_bg=colormaps{1}(1:2:end,:);
% find colormap indices corresponding to the weights
v_idx_colormap1=round(mynormalize(sParticles_fg.W,1,length(colormap_fg)));
v_idx_colormap2=round(mynormalize(sParticles_bg.W,1,length(colormap_bg)));
% find markersizes corresponding to the weights
v_markersize1=round(mynormalize(sParticles_fg.W,5,100));
v_markersize2=round(mynormalize(sParticles_bg.W,5,100));
% if weights are for some reason nans:
v_idx_colormap1(isnan(v_idx_colormap1))=1;
v_idx_colormap2(isnan(v_idx_colormap2))=1;
v_markersize1(isnan(v_markersize1))=15;
v_markersize2(isnan(v_markersize2))=15;

% plot:
hold (ax{1},'on')
scatter(ax{1},ones(1,sConfPF_fg.K)*(sConfPF_fg.n-1),sParticles_bg.H,v_markersize2,colormap_bg(v_idx_colormap2,:),'filled')
scatter(ax{1},ones(1,sConfPF_fg.K)*(sConfPF_fg.n-1),sParticles_fg.H,v_markersize1,colormap_fg(v_idx_colormap1,:),'filled')
ylim(ax{1},[100,400])
xlim(ax{1},[1 sConfPF_fg.N])
drawnow

ylabel('F0 [Hz]')
xlabel('time [n]')
title([{'parallel particle filtering:'}; sConfPF_fg.plotname])
end