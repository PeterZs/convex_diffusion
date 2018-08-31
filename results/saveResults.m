function saveResults(sym, cvx, interp)
% Stores the waveform optimization results to diks under./waveforms/
%
% Input:	sym		Symmetric waveform data structure
%			cvx		Convex optimized waveform data structure
%			interp	Flag to perform interpolation for Siemens

%% Generate filename from parameters
name = ['M', num2str(cvx.param.MMT,'%d'), ...
		'_b', num2str(round(cvx.param.bTarget/1e6),'%d'), ...
		'_G', num2str(round(cvx.param.Gmax*1e3),'%d'), ...
		'_S', num2str(round(cvx.param.Smax),'%d'), ...
		'_dt', num2str(round(cvx.param.dt*1e6),'%d'), ...
		'_x', num2str(round(cvx.param.x*1e2),'%03d')];
if cvx.param.coco, name = [name '_coco']; end

path = [fullfile(fileparts(which(mfilename)),'..') '/waveforms/' name '/'];
if ~exist(path, 'dir')
	mkdir(path)
end

%% Create files
% Save results as structs
save([path 'sym'], 'sym')
save([path 'cvx'], 'cvx')

% Interpolate waveforms to 10us sampling for Siemens scanners
if interp
	interp_dt = 10e-6/sym.param.dt;
	sym.G1 = interp1(sym.G1, interp_dt:interp_dt:sym.n1);
	sym.G2 = interp1(sym.G2, interp_dt:interp_dt:sym.n2);
	cvx.G1 = interp1(cvx.G1, interp_dt:interp_dt:cvx.n1);
	cvx.G2 = interp1(cvx.G2, interp_dt:interp_dt:cvx.n2);
end

% Save waveforms as .txt files
fid = fopen([path 'sym_1.txt'], 'w');
fprintf(fid, '%f\r\n', sym.G1 / sym.param.Gmax);
fclose(fid);
fid = fopen([path 'sym_2.txt'], 'w');
fprintf(fid, '%f\r\n', sym.G1 / sym.param.Gmax);
fclose(fid);
fid = fopen([path 'cvx_1.txt'], 'w');
fprintf(fid, '%f\r\n', cvx.G1 / cvx.param.Gmax);
fclose(fid);
fid = fopen([path 'cvx_2.txt'], 'w');
fprintf(fid, '%f\r\n', cvx.G2 / cvx.param.Gmax);
fclose(fid);

% Save figures
h = get(groot, 'Children');
if size(h) == 2
	saveas(h(1), [path 'gradients.png'])
	saveas(h(2), [path 'moments.png']);
	% close(h(1)); close(h(2));
end