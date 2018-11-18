function h = plotResiduals(sym, asym, coco)
% Plots residual phase from concomitant field effects
%
% Input:	sym		Symmetric waveform data structure
%			asym	Convex optimized waveform data structure
%			coco	Concomitant-corrected optimized waveform data structure
%
% Output:	h		Figure handle

h = figure('unit','normalized', 'outerposition',[0 0 1 0.5], 'Color', 'w');

%% Form time vectors
dt = sym.param.dt;
sym.tVec = (0:sym.n-1) * dt * 1e3;		% [ms]
asym.tVec = (0:asym.n-1) * dt * 1e3;	% [ms]
coco.tVec = (0:coco.n-1) * dt * 1e3;	% [ms]

%% Plot concomitant field phase evolution
ax = subplot(1,1,1);
title('Concomitant field phase evolution', 'FontSize', 20);

% Plot lines
hold on;
plot(sym.tVec, sym.phiCC, 'LineWidth',4);
plot(asym.tVec, asym.phiCC, 'LineWidth',4);
plot(coco.tVec, coco.phiCC, 'LineWidth',4);
plot(sym.tInv*1e3,sym.phiCC(sym.nInv),'kx');
plot(asym.tInv*1e3,asym.phiCC(asym.nInv),'kx');
plot(coco.tInv*1e3,coco.phiCC(coco.nInv),'kx');
hold off;

% Add annotations
yr = max(yticks)-min(yticks);
y1 = max(yticks)-0.04*yr; y2 = max(yticks)-0.12*yr; y3 = max(yticks)-0.20*yr;

mText = ['$m_{sym} = $' num2str(sym.m1*1e6,'%1.2f') '$ \frac{\mu s \cdot T^2}{m^2}$'];
text(sym.tInv*1e3, sym.phiCC(sym.nInv)-0.05*yr, mText, ...
	'HorizontalAlignment','center', 'Interpreter', 'latex', 'FontSize', 16)
mText = ['$m_{asym} = $' num2str(asym.m1*1e6,'%1.2f') '$ \frac{\mu s \cdot T^2}{m^2}$'];
text(asym.tInv*1e3, asym.phiCC(asym.nInv)-0.05*yr, mText, ...
	'HorizontalAlignment','center', 'Interpreter', 'latex', 'FontSize', 16)
mText = ['$m_{coco} = $' num2str(coco.m1*1e6,'%1.2f') '$ \frac{\mu s \cdot T^2}{m^2}$'];
text(coco.tInv*1e3, coco.phiCC(coco.nInv)-0.05*yr, mText, ...
	'HorizontalAlignment','center', 'Interpreter', 'latex', 'FontSize', 16)

mText = ['$AF_{sym}=' num2str(sym.AF_slice,'%1.2g') '_{slice} \cdot ' ...
		num2str(sym.AF_phase,'%1.2g') '_{phase}=' num2str(sym.AF,'%1.2g') '$'];
text(1,y1, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$AF_{asym}=' num2str(asym.AF_slice,'%1.2g') '_{slice} \cdot ' ...
		num2str(asym.AF_phase,'%1.2g') '_{phase}=' num2str(asym.AF,'%1.2g') '$'];
text(1,y2, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$AF_{coco}=' num2str(coco.AF_slice,'%1.2g') '_{slice} \cdot ' ...
		num2str(coco.AF_phase,'%1.2g') '_{phase}=' num2str(coco.AF,'%1.2g') '$'];
text(1,y3, mText, 'Interpreter','latex', 'FontSize',16)

% Add labels
xlabel('Time [ms]');
ylabel('Residual phase [rad]');
legend('\phi_{sym}','\phi_{asym}','\phi_{coco}');
set(ax, 'FontSize', 16);