function h = plotGradients(sym, code, coco)
% Plots symmetric and optimized gradient waveforms and moment evolution
%
% Input:	sym		Symmetric waveform data structure
%			code	Convex optimized waveform data structure
%			coco	Concomitant-corrected optimized waveform data structure
%
% Output:	h		Figure handle

h = figure('unit','normalized', 'outerposition',[0 0 1 1], 'Color', 'w');
warning('off', 'MATLAB:subplot:InvalidPositionSyntax');

%% Form time vectors
dt = sym.param.dt;
sym.tVec = (0:sym.n-1) * dt * 1e3;						% [ms]
code.tVec = (0:code.n-1) * dt * 1e3;					% [ms]
coco.tVec = (0:coco.n-1) * dt * 1e3;					% [ms]

%% Plot gradient waveforms
ax = subplot(2,3,1:3, 'Units', 'normalized', 'Position', [0.13 0.575 0.775 0.325]);
title({['Sym: ' sym.info], ['CODE: ' code.info], ['COCO: ' coco.info]});

% Plot lines
hold on;
plot(sym.tVec, sym.G*1e3, 'LineWidth',4);
plot(code.tVec, code.G*1e3, 'LineWidth',4);
plot(coco.tVec, coco.G*1e3, 'LineWidth',4);
plot(sym.tInv*1e3,0,'kx');
plot(code.tInv*1e3,0,'kx');
plot(coco.tInv*1e3,0,'kx');
hold off;

% Add labels
xlabel('Time [ms]');
ylabel('Amplitude [mT/m]');
legend('G_{sym}','G_{CODE}','G_{CODE}');
set(ax, 'FontSize', 16);


%% Plot M0
ax = subplot(2,3,4);
title('M_0 Evolution','FontSize', 20);

% Plot lines
hold on;
plot(sym.tVec, sym.M(1,:), 'LineWidth',4);
plot(code.tVec, code.M(1,:), 'LineWidth',4);
plot(coco.tVec, coco.M(1,:), 'LineWidth',4);
hold off

% Add annotations
yr = max(yticks)-min(yticks);
y1 = min(yticks)+0.20*yr; y2 = min(yticks)+0.12*yr; y3 = min(yticks)+0.04*yr;

mText = ['$\sigma_{sym}=' num2str(sym.stdM(1),'%1.3g') ' \frac{rad}{m}$'];
text(1,y1, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma_{CODE}=' num2str(code.stdM(1),'%1.3g') ' \frac{rad}{m}$'];
text(1,y2, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma_{CODE}=' num2str(coco.stdM(1),'%1.3g') ' \frac{rad}{m}$'];
text(1,y3, mText, 'Interpreter','latex', 'FontSize',16)

% Add labels
xlabel('Time [ms]');
ylabel('Moment [rad/m]');
set(ax, 'FontSize', 16);


%% Plot M1
ax = subplot(2,3,5);
title('M_1 Evolution','FontSize', 20);

% Plot lines
hold on;
plot(sym.tVec, sym.M(2,:), 'LineWidth',4);
plot(code.tVec, code.M(2,:), 'LineWidth',4);
plot(coco.tVec, coco.M(2,:), 'LineWidth',4);
hold off

% Add annotations
yr = max(yticks)-min(yticks);
y1 = min(yticks)+0.20*yr; y2 = min(yticks)+0.12*yr; y3 = min(yticks)+0.04*yr;

mText = ['$\sigma_{sym}=' num2str(sym.stdM(2),'%1.3g') ' \frac{rad}{m/s}$'];
text(1,y1, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma_{CODE}=' num2str(code.stdM(2),'%1.3g') ' \frac{rad}{m/s}$'];
text(1,y2, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma_{CODE}=' num2str(coco.stdM(2),'%1.3g') ' \frac{rad}{m/s}$'];
text(1,y3, mText, 'Interpreter','latex', 'FontSize',16)

% Add labels
xlabel('Time [ms]');
ylabel('Moment [rad/m/s]');
set(ax, 'FontSize', 16);


%% Plot M2
ax = subplot(2,3,6);
title('M_2 Evolution', 'FontSize', 20);

% Plot lines
hold on;
plot(sym.tVec, sym.M(3,:), 'LineWidth',4);
plot(code.tVec, code.M(3,:), 'LineWidth',4);
plot(coco.tVec, coco.M(3,:), 'LineWidth',4);
hold off

% Add annotations
yr = max(yticks)-min(yticks);
y1 = min(yticks)+0.20*yr; y2 = min(yticks)+0.12*yr; y3 = min(yticks)+0.04*yr;

mText = ['$\sigma_{sym}=' num2str(sym.stdM(3),'%1.3g') ' \frac{rad}{m/s^2}$'];
text(1,y1, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma_{CODE}=' num2str(code.stdM(3),'%1.3g') ' \frac{rad}{m/s^2}$'];
text(1,y2, mText, 'Interpreter','latex', 'FontSize',16)
mText = ['$\sigma_{CODE}=' num2str(coco.stdM(3),'%1.3g') ' \frac{rad}{m/s^2}$'];
text(1,y3, mText, 'Interpreter','latex', 'FontSize',16)

% Add labels
xlabel('Time [ms]');
ylabel('Moment [rad/m/s^2]');
set(ax, 'FontSize', 16);