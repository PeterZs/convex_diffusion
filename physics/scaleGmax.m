function G = scaleGmax(G, p)
% scaleGmax reduces gradient waveform amplitude to have the desired b-value
%
% Input:	G	Input gradient waveform [T/m]
%			p	Parameter strucutre
%			  bTarget	Desired b-value [s/m^2]
%
% Output:	G	Scaled output gradient waveform [T/m]


% Check initial b-value
b = bValue(G, p);
if p.bTarget >= b
    return % Inital waveform was fine (or too small)
end

% Return scaled gradient
G = G * sqrt(p.bTarget/b);