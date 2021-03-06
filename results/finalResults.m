function s = finalResults(s)
% Calculates auxiliary results for the optimized waveforms
%
% Input:	s		Waveform data structure
%			girf	Gradient impulse response function in time domain

dt = s.param.dt;	% Shorthand access

% Concomitant fields
s.B_CC = concomitantFields(s.G, s.param);

% Residual phases over time
s.phiCC = encodingPhase(s.B_CC, s.param);

% Gradient moments over time
s.M = encodingMoments(s.G, s.param);

%% Calculate final values
% Concomitant field attenuation factor
[s.AF, s.AF_slice, s.AF_phase] = maxwellAttenuation(s.G, s.param);

% Residual phases
s.resCC = residualPhase(s.B_CC, s.param);

% Gradient moments
s.moments = gradientMoments(s.G, s.param);

% Standard deviation of moment evolution
s.stdM = std(s.M(:,(s.nPre+1):(s.n-s.nPost)),0,2);	% Only take encoding part

% Info string
s.info = infoString(s);