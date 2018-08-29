function phi = encodingPhase(B, p)
% encodingPhase calculates the phase evolution for a given field waveform
%
% Inputs:	B		Field [T] or gradient waveform [T/m]
%			p		Parameter strucutre
%			  gamma		Gyromagnetic ratio [Hz/T]
%			  dt		Timestep of waveform [s]
%			  inv		Inversion pulse parameter struct
%
% Outputs:	phi		Phase time evolution [rad] or [rad/m]


% Apply inversion pulse to waveform
B = invertFields(B, p.inv);

% Residual phase time evolution
phi = 2*pi*p.gamma * cumtrapz(B) * p.dt;