function saveFigures(param, h1, h2)
% Stores the waveform optimization result plots to disk under ./waveforms/
%
% Input:	param	Optimization parameter struct
%			h1		Gradient plot figure handle
%			h2		Residual phase plot figure handle

%% Generate filename and path
name = generateName(param);
path = [fullfile(fileparts(which(mfilename)),'..') '/waveforms/' name '/'];
if ~exist(path, 'dir')
	mkdir(path)
end

%% Save figures
if isvalid(h1) && isvalid(h2)
% 	export_fig(h1, [path name '_gradients'], '-png');	% '-eps'
% 	export_fig(h2, [path name '_residuals'], '-png');
	saveas(h1,[path name '_gradients.png']);
	saveas(h2,[path name '_residuals.png']);
	close(h1); close(h2);
end