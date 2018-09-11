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
save([path name '_sym'], 'sym')
save([path name '_cvx'], 'cvx')

% Interpolate waveforms to 10us sampling for Siemens scanners
if interp
	interp_dt = 10e-6/sym.param.dt;
	sym.G1 = interp1(sym.G1, interp_dt:interp_dt:sym.n1, 'pchip', 0);
	sym.G2 = interp1(sym.G2, interp_dt:interp_dt:sym.n2, 'pchip', 0);
	cvx.G1 = interp1(cvx.G1, interp_dt:interp_dt:cvx.n1, 'pchip', 0);
	if ~isempty(cvx.G2)
		cvx.G2 = interp1(cvx.G2, interp_dt:interp_dt:cvx.n2, 'pchip', 0);
	end
end

% Save waveforms as .txt files
fid = fopen([path name '_sym_1.txt'], 'w');
fprintf(fid, '%f\r\n', sym.G1 / sym.param.Gmax);
fclose(fid);
fid = fopen([path name '_sym_2.txt'], 'w');
fprintf(fid, '%f\r\n', sym.G1 / sym.param.Gmax);
fclose(fid);
fid = fopen([path name '_cvx_1.txt'], 'w');
fprintf(fid, '%f\r\n', cvx.G1 / cvx.param.Gmax);
fclose(fid);
if ~isempty(cvx.G2)
	fid = fopen([path name '_cvx_2.txt'], 'w');
	fprintf(fid, '%f\r\n', cvx.G2 / cvx.param.Gmax);
	fclose(fid);
end

% Save figures
h = get(groot, 'Children');
if size(h,1) == 2
	saveas(h(1), [path name '_moments.png'])
	saveas(h(2), [path name '_gradients.png']);
	% close(h(1)); close(h(2));
end