function M = encodingMoments(G, p)
% encodingMoments calculates the gradient moments for each time step of the
% diffusion encoding for a given input gradient waveform
%
% Input:	G		Encoding gradient waveform [T/m]
%			p		Parameter strucutre
%			  gamma		Gyromagnetic ratio [Hz/T]
%			  dt		Timestep of waveform [s]
%			  inv		Inversion pulse parameter struct
%
% Output:	M0		0th order gradient moment over time [rad/m]
%			M1		1st order gradient moment over time [rad/(m/s)]
%			M2		2nd order gradient moment over time [rad/(m/s^2)]


% Form time vector
n = numel(G);
tVec = (0:n-1)'*p.dt;	% [s]

% Apply inversion pulse to gradient waveform
G = invertFields(G, p.inv);

% Calculate gradient moments over time
M0 = 2*pi*p.gamma * cumtrapz(tVec.^0 .* G) * p.dt;
M1 = 2*pi*p.gamma * cumtrapz(tVec.^1 .* G) * p.dt;
M2 = pi*p.gamma * cumtrapz(tVec.^2 .* G) * p.dt;
M = [M0, M1, M2]';