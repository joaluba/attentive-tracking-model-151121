function plottraj3d(T,col,titlestr)
% Plot state trajectory in 3d
% ----------- Input: -------------
% T - 3-dimensional trajectory
% col - color (name or rgb)
% titlestr - string to put in the title
% ------------------------------
plot3(T(:,1),T(:,2),T(:,3),col,'LineWidth',2)
title({'3-dim trajectory'; titlestr})
xlabel('F0'); ylabel('F1'); zlabel('F2');
xlim([100 400]);ylim([300 800]);zlim([800 2200]);
hold on
end