function b = bValue(G, p)
% This function calculates the b-value for a given diffusion encoding
% gradient waveform
%
% Input:	G	Encoding gradient waveform [T/m]
%			p	Parameter strucutre
%			  gamma		Gyromagnetic ratio [Hz/T]
%			  dt		Timestep of waveform [s]
%			  inv		Inversion pulse parameter struct
%
% Output:	b	DW encoding constant [s/m^2]


% Initialize
n = numel(G);
C = tril(ones(n));
C2 = C'*C;

% Calculate value
G = invertFields(G, p.inv);
b = (2*pi*p.gamma)^2 * G'*(C2*G) * p.dt^3;