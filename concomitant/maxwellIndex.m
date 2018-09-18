function m = maxwellIndex(G, p, type)
% Calculates a simplified alternative to the Maxwell index as defined by 
% Szczepankiewicz et al., ISMRM 2018 (goo.gl/vVGQq2), which provides a
% measure of concomitant field contribution to gradient encoding waveforms.
%
% Inputs:	G		Input gradient waveform [T/m]
%			p		Parameter struct
%			  dir		Normalized encoding direction vector [x y z]
%			  dt		Time step [s]
%			  type	Index type [0,1,2]
%
% Outputs:	m		Maxwell index [s*T^2/m^2]


if nargin < 3
	type = 0;
end

% Calculate index
G = G * p.encodeDir;			% Project gradient onto axes
invG = invertFields(G,p.inv);	% Invert gradient pulse
M = G.' * invG * p.dt;			% Integrate gradient squared matrix
switch type
	case 0
		m = trace(M);			% Simplified Maxwell index
	case 1
		m = sqrt(trace(M*M.'));	% Maxwell index using Frobenius norm
	case 2
		m = sum(G.*invG)*p.dt;	% Diect integration
end