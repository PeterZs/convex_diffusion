function generatePlots(inFolder)
% Batch generation of gradient plots for pre-optimized waveforms
%
% Input:	inFolder	Given input folder


%% Change to specified folder
oldFolder = cd(inFolder);
addpath(genpath(pwd));

% Get list of all subfolders
list = dir;
list = string({list.name})';
list = list(3:end);

%% Create plots
for i = 1:numel(list)
	
	% Load files
	sym = load(strcat(inFolder,'/',list(i),'/',list(i),'_sym.mat'));
	asym = load(strcat(inFolder,'/',list(i),'/',list(i),'_asym.mat'));
	coco = load(strcat(inFolder,'/',list(i),'/',list(i),'_coco.mat'));
	
	h1 = plotGradients(sym, asym, coco);
	h2 = plotResiduals(sym, asym, coco);

	% Save figures
	if isvalid(h1) && isvalid(h2)
		export_fig(h1, strcat(inFolder,'/',list(i),'/',list(i),'_gradients'), '-png', '-eps');
		export_fig(h2,strcat(inFolder,'/',list(i),'/',list(i),'_residuals'), '-png', '-eps');
		close(h1); close(h2);
	end
	
end

%% Change back to original folder
rmpath(genpath(pwd));
cd(oldFolder);