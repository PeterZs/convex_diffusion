function plotPhase(sym, cvx)
% Plots residual phase from eddy-current and concomitant field effects
%
% Input:	sym		Symmetric waveform data structure
%			cvx		Convex optimized waveform data structure

%% Form time vectors
dt = sym.param.dt;
sym.tVec = (0:sym.n-1) * dt * 1e3;					% [ms]
cvx.tVec = (0:cvx.n-1) * dt * 1e3;					% [ms]
sym.tVecEC = (0:numel(sym.G_EC)-1) * dt * 1e3;		% [ms]
cvx.tVecEC = (0:numel(cvx.G_EC)-1) * dt * 1e3;		% [ms]

%% Plot eddy-current phase evolution
figure('unit','normalized', 'outerposition',[0.33 0.33 0.66 0.66]);
subplot(2,1,1);
title('Eddy-current phase evolution', 'FontSize', 20);

hold on;
plot(sym.tVecEC, sym.phiEC, 'LineWidth',4);
plot(cvx.tVecEC, cvx.phiEC, 'LineWidth',4);
plot(sym.tInv*1e3,sym.phiEC(sym.nInv),'ko');
plot(cvx.tInv*1e3,cvx.phiEC(cvx.nInv),'kx');
plot(sym.tE*1e3,sym.resEC,'ko');
plot(cvx.tE*1e3,cvx.resEC,'kx');
hold off;

xlabel('Time [ms]');
ylabel('Residual phase [rad/m]');
legend(['\phi_{sym}=' num2str(sym.resEC,'%1.2e')], ...
	   ['\phi_{cvx} =' num2str(cvx.resEC,'%1.2e')]);
set(gca, 'FontSize', 16);

%% Plot concomitant field phase evolution
subplot(2,1,2);
title('Concomitant field phase evolution', 'FontSize', 20);

hold on;
plot(sym.tVec, sym.phiCC, 'LineWidth',4);
plot(cvx.tVec, cvx.phiCC, 'LineWidth',4);
plot(sym.tInv*1e3,sym.phiCC(sym.nInv),'ko');
plot(cvx.tInv*1e3,cvx.phiCC(cvx.nInv),'kx');
hold off;

xlabel('Time [ms]');
ylabel('Residual phase [rad]');
legend(['AF_{sym}=' num2str(sym.AF,'%1.3g')], ...
	   ['AF_{cvx} =' num2str(cvx.AF,'%1.3g')]);
set(gca, 'FontSize', 16);