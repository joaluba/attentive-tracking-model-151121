
clear all; clc

% MANUALLY LOAD 'scores' (should be n x 5 x 2) FOR THE TRAJ PAIR YOU WANT TO VISUALIZE!

fs = 16000;


for targdist = 1:2  
    
    clearvars -except targdist all_data all_data_nozeros ...
        fs all_data_ST all_data_nozeros_ST stim sett TRANSP_TRAJ_PAIRS
    close all
    
    score = scores(:,:,targdist);
     
    F0 = resample(score(:,2)./10,4,10);
    F1 = resample(score(:,4),4,10);
    F2 = resample(score(:,5),4,10);
    
    f0f1f2tracks(:,1:3) = [F0 F1 F2];
    
    F0ST = 12.*log2(F0./160);
    F1ST = 12.*log2(F1./500);
    F2ST = 12.*log2(F2./1500);
    
    f0f1f2tracks_ST(:,1:3) = [F0ST F1ST F2ST];
    
    all_data{targdist} =  f0f1f2tracks;
    all_data_ST{targdist} =  f0f1f2tracks_ST;
    all_data_nozeros{targdist} = f0f1f2tracks(find(F0>60),1:3);
    all_data_nozeros_ST{targdist} = f0f1f2tracks_ST(find(F0>60),1:3);
    

    
end


% 3d plot
close all
plotnum = 1;
figure(plotnum);
set(gcf,'Position',[50 100 800 1400]); 
for targdist = 1:2
    colorind = 1;
    
    ind=2;
    on=1;
    while on==1
        clearvars ex wai zee XYZ x y z xx yy zz px py pz Px Py Pz width colorv colorvs cdat q w
        on2=1;
        j = 1;
        while on2==1
            
                zee(j) = all_data_ST{1,targdist}(ind,1);
                wai(j) = all_data_ST{1,targdist}(ind,3);
                ex(j) = all_data_ST{1,targdist}(ind,2);
                ind=ind+1;
                j=j+1;
                if ind>size(all_data_ST{1,targdist}(:,1),1)
                    on2=0;
                end
        end
                if exist('zee')
                    if length(zee)>1
                        x = [];
                        y = [];
                        z = [];
                        Px = [];
                        Py = [];
                        Pz = [];
                        
                        zee = interp1([1:length(zee)],zee,[1:0.1:length(zee)]);
                        wai = interp1([1:length(wai)],wai,[1:0.1:length(wai)]);
                        ex = interp1([1:length(ex)],ex,[1:0.1:length(ex)]);
                        zee = smooth(zee,20);
                        wai = smooth(wai,20);
                        ex = smooth(ex,20);
                        
                        
                        for i=1:10
                            a = (rand*0.001)+1;
                            b = (rand*0.001)+1;
                            c = (rand*0.001)+1;
                            zz{i} = real(c.*zee');
                            yy{i} = real(a.*wai');
                            xx{i} = real(b.*ex');
                            px{i}=[0,diff(xx{i})];
                            py{i}=[0,diff(yy{i})];
                            pz{i}=[0,diff(zz{i})];
                            
                            XYZ{i} = [xx{i}',yy{i}',zz{i}'];
                            
                            x = [x, xx{i}];
                            y = [y, yy{i}];
                            z = [z, zz{i}];
                            Px = [Px, px{i}];
                            Py = [Py, py{i}];
                            Pz = [Pz, pz{i}];
                        end
                        
                        width = 0.5.*ones(length(zee),1)';
                        width(1:2) = width(1:2).*([0.1 0.9]);
                        width(length(width)-1:length(width)) = width(length(width)-1:length(width)).*([0.9 0.1]);
                        width = repmat({width'},1,10);
                        daspect([1,1,1]) 
                        
                       % make color vectors to represent time
                        colorv = 0.2*(((10*ind)-length(zee)-1):(10*ind))';
                        colorv = colorv./(10*(length(all_data_ST{1,targdist}(:,1))));
                        q = size(XYZ{:,1},1);
                        w = size(XYZ,2);
                        cdat(:,1:10,1) = repmat(colorv,1,10);
                        if targdist ~=plotnum
                           cdat(:,1:10,2) = 0.3;
                        else
                            cdat(:,1:10,2) = 0.4;
                        end
                        cdat(:,1:10,3) = repmat((1-colorv),1,10);
                      
                       ht=streamtube(XYZ,width); 
                        
                       if targdist ~=plotnum
                         set(ht,'EdgeColor','k','LineWidth',0.2,'EdgeAlpha',0.05,'EdgeLighting','gouraud','meshstyle','row', ...
                              'FaceColor','texturemap','FaceAlpha',1,'FaceLighting','gouraud', ...
                              'AlignVertexCenters','on', ...
                              'CData',cdat,'CDataMode', 'manual'); hold on;
                       else
                          set(ht,'EdgeColor','k','LineWidth',0.2,'EdgeAlpha',0.05,'EdgeLighting','gouraud','meshstyle','row', ...
                              'FaceColor','texturemap','FaceAlpha',1,'FaceLighting','gouraud', ...
                              'AlignVertexCenters','on', ...
                              'CData',flip(cdat,3),'CDataMode', 'manual'); hold on;
                       end
                        
                       
                    end
                end
                
        if ind>size(all_data_ST{1,targdist}(:,1),1)
            on=0;
        end
  

    end
            
    view(-130,20)
    
    
    axis tight
    grid off
    set(gca,'Projection','perspective')
    camlight left
    lighting gouraud
    xl = [-18 18]; %get(gca,'xlim');
    set(gca,'xlim', xl)
     yl = [-18 18]; %get(gca,'ylim');
    set(gca,'ylim', yl)
     zl = [-18 18]; %get(gca,'zlim');
    set(gca,'zlim', zl)
     
    hold on;
    
end
%     
%     
    
%     xlabel({'F1', 'ST from 500Hz'},'FontSize',16,'FontWeight','bold','Color','k'); 
%     ylabel({'F2', 'ST from 1500Hz'},'FontSize',16,'FontWeight','bold','Color','k'); 
%     zlabel({'F0', 'ST from 200Hz'},'FontSize',16,'FontWeight','bold','Color','k'); 
%     
    
    
   
    


% 
% print -painters
% print -depsc att_fig1.eps


