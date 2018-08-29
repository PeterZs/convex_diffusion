function M = gradientMoments(G, p)
% gradientMoments calculates the final gradient moments for a given input
% gradient waveform
%
% Input:	G	Encoding gradient waveform [T/m]
%			p	Parameter strucutre
%			  gamma		Gyromagnetic ratio [Hz/T]
%			  dt		Timestep of waveform [s]
%			  inv		Inversion pulse parameter struct
%
% Output:	M	Column vector of final moments


% Form time vector
n = numel(G);
tVec = (0:n-1)'*p.dt;	% [s]

% Apply inversion pulse to gradient waveform
G = invertFields(G, p.inv);

% Calculate final moments
M0 = 2*pi*p.gamma * trapz(tVec.^0 .* G) * p.dt;
M1 = 2*pi*p.gamma * trapz(tVec.^1 .* G) * p.dt;
M2 = pi*p.gamma * trapz(tVec.^2 .* G) * p.dt;
M = [M0 M1 M2];