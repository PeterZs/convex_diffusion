function phi = residualPhase(B, p)
% residualPhase calculates the residual phase for a given field waveform
%
% Input:	B		Field [T] or gradient waveform [T/m]
%			p		Parameter strucutre
%			  gamma		Gyromagnetic ratio [Hz/T]
%			  dt		Timestep of waveform [s]
%			  inv		Inversion pulse parameter struct
%
% Output:	phi		Residual phase [rad]


% Apply inversion pulse to waveform
B = invertFields(B, p.inv);

% Residual phase
phi = 2*pi*p.gamma * trapz(B) * p.dt;