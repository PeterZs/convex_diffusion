function plotMoments(sym, cvx)
% Plots moment evolution and residual phase from concomitant field effects 
%
% Input:	sym		Symmetric waveform data structure
%			cvx		Convex optimized waveform data structure

figure('unit','normalized', 'outerposition',[0 0 1 1]);

%% Form time vectors
dt = sym.param.dt;
sym.tVec = (0:sym.n-1) * dt * 1e3;					% [ms]
cvx.tVec = (0:cvx.n-1) * dt * 1e3;					% [ms]

%% Plot M0
subplot(2,3,1);
title('M_0 Evolution','FontSize', 20);

hold on;
plot(sym.tVec, sym.M(1,:), 'LineWidth',4);
plot(cvx.tVec, cvx.M(1,:), 'LineWidth',4);
hold off

yr = max(yticks)-min(yticks); y1 = min(yticks)+0.15*yr; y2 = min(yticks)+0.05*yr;
mText = ['$\sigma(M_{0,sym})=' num2str(sym.stdM(1),'%1.3g') ' \frac{rad}{m}$'];
text(1,y1, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma(M_{0,cvx})=' num2str(cvx.stdM(1),'%1.3g') ' \frac{rad}{m}$'];
text(1,y2, mText, 'Interpreter','latex', 'FontSize',16)

xlabel('Time [ms]');
ylabel('Moment [rad/m]');
legend('M_{0,sym}','M_{0,cvx}','location','northwest');
set(gca, 'FontSize', 16);

%% Plot M1
subplot(2,3,2);
title('M_1 Evolution', 'FontSize', 20);

hold on;
plot(sym.tVec, sym.M(2,:), 'LineWidth',4);
plot(cvx.tVec, cvx.M(2,:), 'LineWidth',4);
hold off

yr = max(yticks)-min(yticks); y1 = min(yticks)+0.15*yr; y2 = min(yticks)+0.05*yr;
mText = ['$\sigma(M_{1,sym})=' num2str(sym.stdM(2),'%1.3g') ' \frac{rad\cdot s}{m}$'];
text(1,y1, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma(M_{1,cvx})=' num2str(cvx.stdM(2),'%1.3g') ' \frac{rad\cdot s}{m}$'];
text(1,y2, mText, 'Interpreter','latex', 'FontSize',16)

xlabel('Time [ms]');
ylabel('Moment [rad/m/s]');
legend('M_{1,sym}','M_{1,cvx}','location','northwest');
set(gca, 'FontSize', 16);

%% Plot M2
subplot(2,3,3);
title('M_2 Evolution', 'FontSize', 20);

hold on;
plot(sym.tVec, sym.M(3,:), 'LineWidth',4);
plot(cvx.tVec, cvx.M(3,:), 'LineWidth',4);
hold off

yr = max(yticks)-min(yticks); y1 = min(yticks)+0.15*yr; y2 = min(yticks)+0.05*yr;
mText = ['$\sigma(M_{2,sym})=' num2str(sym.stdM(3),'%1.3g') ' \frac{rad\cdot s^2}{m}$'];
text(1,y1, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma(M_{2,cvx})=' num2str(cvx.stdM(3),'%1.3g') ' \frac{rad\cdot s^2}{m}$'];
text(1,y2, mText, 'Interpreter','latex', 'FontSize',16)

xlabel('Time [ms]');
ylabel('Moment [rad/m/s^2]');
legend('M_{2,sym}','M_{2,cvx}','location','northwest');
set(gca, 'FontSize', 16);

%% Plot concomitant field phase evolution
subplot(2,3,4:6);
title('Concomitant field phase evolution', 'FontSize', 20);

hold on;
plot(sym.tVec, sym.phiCC, 'LineWidth',4);
plot(cvx.tVec, cvx.phiCC, 'LineWidth',4);
plot(sym.tInv*1e3,sym.phiCC(sym.nInv),'ko');
plot(cvx.tInv*1e3,cvx.phiCC(cvx.nInv),'kx');
hold off;

mText = ['$m_{max,sym} = $' num2str(sym.m1*1e3,'%1.2f') '$ \frac{mT}{m} \sqrt{s}$'];
text(sym.tInv*1e3, sym.phiCC(sym.nInv)*0.98-4, mText, ...
	'HorizontalAlignment','center', 'Interpreter', 'latex', 'FontSize', 16)
mText = ['$m_{max,cvx} = $' num2str(cvx.m1*1e3,'%1.2f') '$ \frac{mT}{m} \sqrt{s}$'];
text(cvx.tInv*1e3, cvx.phiCC(cvx.nInv)*0.98-4, mText, ...
	'HorizontalAlignment','center', 'Interpreter', 'latex', 'FontSize', 16)

yr = max(yticks)-min(yticks); y1 = max(yticks)-0.05*yr; y2 = max(yticks)-0.15*yr;
mText = ['$AF_{sym}=' num2str(sym.AF,'%1.3g') '$'];
text(1,y1, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$AF_{cvx}=' num2str(cvx.AF,'%1.3g') '$'];
text(1,y2, mText, 'Interpreter','latex', 'FontSize',16)

xlabel('Time [ms]');
ylabel('Residual phase [rad]');
legend('\phi_{sym}','\phi_{cvx}');
set(gca, 'FontSize', 16);