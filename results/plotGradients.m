function plotGradients(sym, cvx)
% Plots symmetric and optimized gradient waveforms
%
% Input:	sym		Symmetric waveform data structure
%			cvx		Convex optimized waveform data structure

figure('unit','normalized', 'outerposition',[0 0 1 1]);

%% Form time vectors
dt = sym.param.dt;
sym.tVec = (0:sym.n-1) * dt * 1e3;					% [ms]
cvx.tVec = (0:cvx.n-1) * dt * 1e3;					% [ms]
sym.tVecEC = (0:numel(sym.G_EC(:,1))-1) * dt * 1e3;		% [ms]
cvx.tVecEC = (0:numel(cvx.G_EC(:,1))-1) * dt * 1e3;		% [ms]

%% Plot gradient waveforms
subplot(2,3,1:3);
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
legend('G_{sym}','G_{cvx}');
set(gca, 'FontSize', 16);

%% Plot eddy-current G_xx
subplot(2,3,4);
title('Eddy-current self-term G_{xx}', 'FontSize', 20);

hold on;
plot(sym.tVecEC, sym.G_EC(:,1), 'LineWidth',4);
plot(cvx.tVecEC, cvx.G_EC(:,1), 'LineWidth',4);
plot(sym.tInv*1e3,sym.G_EC(sym.nInv,1),'ko');
plot(cvx.tInv*1e3,cvx.G_EC(cvx.nInv,1),'kx');
plot(sym.tE*1e3,sym.G_EC(cvx.nE,1),'ko');
plot(cvx.tE*1e3,cvx.G_EC(cvx.nE,1),'kx');
hold off;

xlabel('Time [ms]');
ylabel('Amplitude [mT/m]');
legend('G_{xx,sym}','G_{xx,cvx}');
set(gca, 'FontSize', 16);

%% Plot eddy-current G_yy
subplot(2,3,5);
title('Eddy-current self-term G_{yy}', 'FontSize', 20);

hold on;
plot(sym.tVecEC, sym.G_EC(:,2), 'LineWidth',4);
plot(cvx.tVecEC, cvx.G_EC(:,2), 'LineWidth',4);
plot(sym.tInv*1e3,sym.G_EC(sym.nInv,2),'ko');
plot(cvx.tInv*1e3,cvx.G_EC(cvx.nInv,2),'kx');
plot(sym.tE*1e3,sym.G_EC(cvx.nE,2),'ko');
plot(cvx.tE*1e3,cvx.G_EC(cvx.nE,2),'kx');
hold off;

xlabel('Time [ms]');
ylabel('Amplitude [mT/m]');
legend('G_{yy,sym}','G_{yy,cvx}');
set(gca, 'FontSize', 16);

%% Plot eddy-current G_zz
subplot(2,3,6);
title('Eddy-current self-term G_{zz}', 'FontSize', 20);

hold on;
plot(sym.tVecEC, sym.G_EC(:,3), 'LineWidth',4);
plot(cvx.tVecEC, cvx.G_EC(:,3), 'LineWidth',4);
plot(sym.tInv*1e3,sym.G_EC(sym.nInv,3),'ko');
plot(cvx.tInv*1e3,cvx.G_EC(cvx.nInv,3),'kx');
plot(sym.tE*1e3,sym.G_EC(cvx.nE,3),'ko');
plot(cvx.tE*1e3,cvx.G_EC(cvx.nE,3),'kx');
hold off;

xlabel('Time [ms]');
ylabel('Amplitude [mT/m]');
legend('G_{zz,sym}','G_{zz,cvx}');
set(gca, 'FontSize', 16);