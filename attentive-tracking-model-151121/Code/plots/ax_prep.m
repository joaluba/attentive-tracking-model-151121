function [ax1,fig1,colormaps]=ax_prep(sConfPF)
% Function to prepare axes for figures plotted inside
% the particle filter loop 

% plot particle evolution 
if isequal(sConfPF.plotfun,@plotparticleevol_online)
    fig1{1}=figure(randi(500));
    fig1{1}.Position=[100 50 800 700];
    ax1{1}=axes;
    rh=0.8;rw=0.8;fl=0.1;fb=0.1;
    set(ax1{1},'Position',[fl fb rw rh]);
    load('myredmap.mat');load('mybluemap.mat');
    colormaps{1}=myredmap;colormaps{2}=mybluemap;
end


end

