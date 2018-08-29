function AF = maxwellAttenuation(G, p)
% Calculates the attention caused by concomitant field contributions for a 
% given gradient waveform and orientation at the field of view edge
% (Szczepankiewicz, ISMRM 2018)
%
% Input:	G	Input gradient waveform amplitude G(t) [T/m]
%			p	Parameter structure
%			  gamma		Gyromagnetic ratio [Hz/T]
%			  dt		Timestep of waveform [s]
%			  B0		Static magnetic field strength [T]
%			  dir		Normalized encoding direction vector [x y z]
%			  FOV		Field of view [x y z] [m]
%			  inv		Inversion pulse paramter structure
%
% Output:	AF	Concomitant field attenuation


% Define symbolic gradients and concomitant field matrix
syms x y z
r = [x y z];
syms Gx Gy Gz
M_CC = [Gz.*Gz			0			-2*Gx.*Gz;
		0				Gz.*Gz		-2*Gy.*Gz;
		-2*Gx.*Gz		-2*Gy.*Gz	4*Gx.*Gx + 4*Gy.*Gy];

% Substitute symbolic expressions
G = G * p.encodeDir;
Gx = G(:,1);		Gy = G(:,2);		Gz = G(:,3);
x = p.FOV(1)/2;		y = p.FOV(2)/2;		z = p.FOV(3)/2;

% True gradients at edge of volume
E = G + 1/(4*p.B0) * eval(subs(r * M_CC));

% Concomitant field moment wave vector
k = residualPhase(E, p);
k_slice = dot(p.sliceDir, k);
k_phase = dot(p.phaseDir, k);

% Calculate attenuation factors
sliceAF = abs(sinc(k_slice * p.ST));
phaseAF = exp(-abs(k_phase * p.ESP/(p.dk*p.T2star)));
AF = sliceAF * phaseAF;