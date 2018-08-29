function s = finalResults(s)
% Calculates auxiliary results for the optimized waveforms
%
% Input:	s	Waveform data structure

dt = s.param.dt;	% Shorthand access

%% Final time series data
% Eddy-current and other linear gradient perturbations
girf = loadGIRF(s.param.tRead, dt);
s.G_EC = conv(s.G,girf);
s.G_EC(1:s.n) = s.G_EC(1:s.n) - s.G;

% Concomitant fields
s.B_CC = concomitantFields(s.G, s.param);

% Residual phases over time
s.phiEC = encodingPhase(s.G_EC, s.param);
s.phiCC = encodingPhase(s.B_CC, s.param);

% Gradient moments over time
s.M = encodingMoments(s.G, s.param);

%% Calculate final values
% Concomitant field attenuation factor
s.AF = maxwellAttenuation(s.G, s.param);

% Residual phases
s.resEC = residualPhase(s.G_EC(1:s.nE), s.param);
s.resCC = residualPhase(s.B_CC, s.param);

% Gradient moments
s.moments = gradientMoments(s.G, s.param);

% Info string
s.info = infoString(s);