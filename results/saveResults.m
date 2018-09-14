function saveResults(sym, asym, coco)
% Stores the waveform optimization results to diks under ./waveforms/
%
% Input:	sym		Symmetric waveform data structure
%			asym		Convex optimized waveform data structure
%			coco	Concomitant-corrected optimized waveform data structure

%% Generate filename from parameters
name = ['M', num2str(asym.param.MMT,'%d'), ...
		'_b', num2str(round(asym.param.bTarget/1e6),'%d'), ...
		'_G', num2str(round(asym.param.Gmax*1e3),'%d'), ...
		'_S', num2str(round(asym.param.Smax),'%d')];

path = [fullfile(fileparts(which(mfilename)),'..') '/waveforms/' name '/'];
if ~exist(path, 'dir')
	mkdir(path)
end

%% Create files
% Save results as structs
save([path name '_sym'], 'sym')
save([path name '_asym'], 'asym')
save([path name '_coco'], 'coco')


% Interpolate waveforms to 10us sampling for Siemens scanners
if asym.param.interp
	rateFactor = 10e-6/sym.param.dt;
	sym.G1 = interp1(sym.G1, 1:rateFactor:sym.n1, 'pchip');
	sym.G2 = interp1(sym.G2, 1:rateFactor:sym.n2, 'pchip');
	asym.G1 = interp1(asym.G1, 1:rateFactor:asym.n1, 'pchip');
	if ~isempty(asym.G2)
		asym.G2 = interp1(asym.G2, 1:rateFactor:asym.n2, 'pchip');
	end
	coco.G1 = interp1(coco.G1, 1:rateFactor:coco.n1, 'pchip');
	if ~isempty(coco.G2)
		coco.G2 = interp1(coco.G2, 1:rateFactor:coco.n2, 'pchip');
	end
end

% Save waveforms as .txt files
fid = fopen([path name '_sym_1.txt'], 'w');
fprintf(fid, '%f\r\n', sym.G1 / sym.param.Gmax);
fclose(fid);
fid = fopen([path name '_sym_2.txt'], 'w');
fprintf(fid, '%f\r\n', sym.G2 / sym.param.Gmax);
fclose(fid);
fid = fopen([path name '_asym_1.txt'], 'w');
fprintf(fid, '%f\r\n', asym.G1 / asym.param.Gmax);
fclose(fid);
if ~isempty(asym.G2)
	fid = fopen([path name '_asym_2.txt'], 'w');
	fprintf(fid, '%f\r\n', asym.G2 / asym.param.Gmax);
	fclose(fid);
end
fid = fopen([path name '_coco_1.txt'], 'w');
fprintf(fid, '%f\r\n', coco.G1 / coco.param.Gmax);
fclose(fid);
if ~isempty(coco.G2)
	fid = fopen([path name '_coco_2.txt'], 'w');
	fprintf(fid, '%f\r\n', coco.G2 / coco.param.Gmax);
	fclose(fid);
end

% Save figures
h = get(groot, 'Children');
if size(h,1) == 2
	saveas(h(1), [path name '_residuals.png'])
	saveas(h(2), [path name '_gradients.png']);
	% close(h(1)); close(h(2));
end