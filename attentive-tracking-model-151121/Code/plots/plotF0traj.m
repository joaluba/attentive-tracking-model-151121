function plotF0traj(T,col,titlestr)
% Plot F0 trajectory
% ----------- Input: -------------
% T - 3-dimensional trajectory
% col - color (name or rgb)
% titlestr - string to put in the title
% ------------------------------
plot(T(:,1),col,'LineWidth',2)
xlabel('time [n]'); ylabel('F0');ylim([100 400]);
hold on
sgtitle({'F0 trajectories'; titlestr})
end