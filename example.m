% This script serves as an example to compare diffusion encoding gradient
% waveforms generated by an analytical method creating symmetric
% waveforms against a convex optimization method generating concomitant
% field corrected asymmetric waveforms.
%
% Settings and targets can be adapted as suited in parameters.m


%% Initialize
SAVE = false;	% Set flag to save results to disk
path = fileparts(which(mfilename));
addpath(genpath(path))

%% Create waveforms
tic

% Symmetric waveform
p = parameters('sym');
sym = symmetricDiffusion(p);
sym.elapsed = toc;

% Asymetric waveform
p = parameters('code');
code = convexDiffusion(p, 0, sym.n, 1);
code.elapsed = toc;

% Maxwell-compensated waveform
p = parameters('coco');
coco = convexDiffusion(p, code.nEnc, sym.n, 1);
coco.elapsed = toc;

%% Calculate and display results
sym = finalResults(sym);
fprintf(['Symmetric:   ' sym.info '\n']);
asym = finalResults(asym);
fprintf(['CODE:  ' code.info '\n']);
coco = finalResults(coco);
fprintf(['COCO: ' coco.info '\n']);

% Create plots
h1 = plotGradients(sym, code, coco);
h2 = plotResiduals(sym, code, coco);

% Save to disk
if SAVE
	saveResults(sym, code, coco);
	saveFigures(p, h1, h2);
end