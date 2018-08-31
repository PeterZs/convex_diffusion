function s = finalResults(s)
% Calculates auxiliary results for the optimized waveforms
%
% Input:	s	Waveform data structure

dt = s.param.dt;	% Shorthand access

%% Final time series data
% Eddy-current and other linear gradient perturbations
girf = loadGIRF(s.param.tRead, dt);
for i = 1:numel(s.param.encodeDir)
	dir = s.param.encodeDir(i);
	s.G_EC(:,i) = conv(dir * s.G, girf(:,i));
	s.G_EC(1:s.n,i) = s.G_EC(1:s.n,i) - dir * s.G;
end

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
s.resEC = residualPhase(s.G_EC(1:s.nE,:), s.param);
s.resCC = residualPhase(s.B_CC, s.param);

% Gradient moments
s.moments = gradientMoments(s.G, s.param);

% Standard deviation of moment evolution
s.stdM = std(s.M(:,(s.nPre+1):(s.n-s.nPost)),0,2);	% Only take encoding part

% Info string
s.info = infoString(s);