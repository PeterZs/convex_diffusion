function m = maxwellIndex(G, p, convex)
% Calculates a convex alternative to the Maxwell index as defined by 
% Szczepankiewicz et al., ISMRM 2018 (goo.gl/vVGQq2), which provides a
% measure of concomitant field contribution to gradient encoding waveforms.
%
% Inputs:	G		Input gradient waveform [T/m]
%			p		Parameter struct
%			  dir		Normalized encoding direction vector [x y z]
%			  dt		Time step [s]
%			  convex	Convexity flag [Bool]
%
% Outputs:	m		Maxwell index [s*T/m] ([s*T^2/m^2] for non-convex)


if nargin < 3
	convex = true;
end

% Calculate index
G = G * p.encodeDir;			% Project gradient onto axes
invG = invertFields(G,p.inv);	% Invert gradient pulse
M = G.' * invG * p.dt;			% Integrate gradient squared matrix
if convex
	m = sqrt(sum(M(:)));		% Convex maxwell index
else
	m = sqrt(trace(M*M'));		% Standard maxwell index using Frobenius norm
end