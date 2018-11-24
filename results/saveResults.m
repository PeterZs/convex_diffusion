function saveResults(sym, code, coco)
% Stores the waveform optimization results to disk under ./waveforms/
%
% Input:	sym		Symmetric waveform data structure
%			code	Convex optimized waveform data structure
%			coco	Concomitant-corrected optimized waveform data structure

%% Generate filename from parameters
name = generateName(sym.param);
path = [fullfile(fileparts(which(mfilename)),'..') '/waveforms/' name '/'];
if ~exist(path, 'dir')
	mkdir(path)
end

%% Create files
% Save results as structs
save([path name '_sym'], '-struct', 'sym')
save([path name '_code'], '-struct', 'code')
save([path name '_coco'], '-struct', 'coco')


% Interpolate waveforms to 10us sampling for Siemens scanners
if code.param.interp
	rateFactor = 10e-6/sym.param.dt;
	sym.G1 = interp1(sym.G1, 1:rateFactor:sym.n1, 'pchip');
	sym.G2 = interp1(sym.G2, 1:rateFactor:sym.n2, 'pchip');
	code.G1 = interp1(code.G1, 1:rateFactor:code.n1, 'pchip');
	if numel(code.G2)>1
		code.G2 = interp1(code.G2, 1:rateFactor:code.n2, 'pchip');
	end
	coco.G1 = interp1(coco.G1, 1:rateFactor:coco.n1, 'pchip');
	if numel(coco.G2)>1
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
fid = fopen([path name '_code_1.txt'], 'w');
fprintf(fid, '%f\r\n', code.G1 / code.param.Gmax);
fclose(fid);
if ~isempty(code.G2)
	fid = fopen([path name '_code_2.txt'], 'w');
	fprintf(fid, '%f\r\n', code.G2 / code.param.Gmax);
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