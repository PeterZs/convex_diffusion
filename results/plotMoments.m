function plotMoments(sym, cvx)
% Plots symmetric and optimized gradient waveforms and moment evolution%
%
% Input:	sym		Symmetric waveform data structure
%			cvx		Convex optimized waveform data structure

%% Form time vectors
dt = sym.param.dt;
sym.tVec = (0:sym.n-1) * dt * 1e3;					% [ms]
cvx.tVec = (0:cvx.n-1) * dt * 1e3;					% [ms]

%% Plot gradient waveforms
figure('unit','normalized', 'outerposition',[0 0 1 1]);
subplot(2,3,[1 2 3]);
title({['       Convex: ' cvx.info], ...
	   ['Symmetric: ' sym.info]}, 'FontSize', 20);

hold on;
plot(sym.tVec, sym.G, 'LineWidth',4);
plot(cvx.tVec, cvx.G, 'LineWidth',4);
plot(sym.tInv*1e3,0,'ko');
plot(cvx.tInv*1e3,0,'kx');
hold off;

xlabel('Time [ms]');
ylabel('Amplitude [mT/m]');
legend('G_{sym}','G_{cvx} ');
set(gca, 'FontSize', 16);

%% Plot M0
subplot(2,3,4);
title('M_0 Evolution','FontSize', 20);

hold on;
plot(sym.tVec, sym.M(1,:), 'LineWidth',4);
plot(cvx.tVec, cvx.M(1,:), 'LineWidth',4);
hold off

xlabel('Time [ms]');
ylabel('Moment [rad/m]');
legend(['\sigma_{sym}=' num2str(sym.stdM(1),'%1.2e')], ...
	   ['\sigma_{cvx} =' num2str(cvx.stdM(1),'%1.2e')], ...
	   'Location','southwest');
set(gca, 'FontSize', 16);

%% Plot M1
subplot(2,3,5);
title('M_1 Evolution', 'FontSize', 20);

hold on;
plot(sym.tVec, sym.M(2,:), 'LineWidth',4);
plot(cvx.tVec, cvx.M(2,:), 'LineWidth',4);
hold off

xlabel('Time [ms]');
ylabel('Moment [rad/m/s]');
legend(['\sigma_{sym}=' num2str(sym.stdM(2),'%1.2e')], ...
	   ['\sigma_{cvx} =' num2str(cvx.stdM(2),'%1.2e')], ...
	   'Location','southwest');
set(gca, 'FontSize', 16);

%% Plot M2
subplot(2,3,6);
title('M_2 Evolution', 'FontSize', 20);

hold on;
plot(sym.tVec, sym.M(3,:), 'LineWidth',4);
plot(cvx.tVec, cvx.M(3,:), 'LineWidth',4);
hold off

xlabel('Time [ms]');
ylabel('Moment [rad/m/s^2]');
legend(['\sigma_{sym}=' num2str(sym.stdM(3),'%1.2e')], ...
	   ['\sigma_{cvx} =' num2str(cvx.stdM(3),'%1.2e')], ...
	   'Location','southwest');
set(gca, 'FontSize', 16);