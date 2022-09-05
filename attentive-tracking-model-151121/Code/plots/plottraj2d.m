function plottraj2d(T,col,titlestr)
% Plot state trajectory in 3d
% ----------- Input: -------------
% T - 3-dimensional trajectory
% col - color (name or rgb)
% titlestr - string to put in the title
% ------------------------------

% plot F0 trajectory:
subplot(3,1,1)
plot(T(:,1),col,'LineWidth',2)
xlabel('time [n]'); ylabel('F0');ylim([100 400]);
hold on
% plot F1 trajectory:
subplot(3,1,2)
plot(T(:,2),col,'LineWidth',2)
xlabel('time [n]'); ylabel('F1');ylim([300 900]);
hold on
% plot F2 trajectory:
subplot(3,1,3)
plot(T(:,3),col,'LineWidth',2)
xlabel('time [n]'); ylabel('F2');ylim([800 2500]);
hold on
% give title to the plot:
sgtitle({'Parameter trajectories'; titlestr})
end