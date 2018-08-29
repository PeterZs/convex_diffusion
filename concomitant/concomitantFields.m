function B_CC = concomitantFields(G, p)
% Returns the concomitant field evolution for a given gradient waveform and
% orientation at the edge of the field of view (furthest point)
%
% Input:	G		Input gradient waveform amplitude G(t) [T/m]
%			p		Parameter structure
%			  B0			Static magnetic field strength [T]
%			  encodeDir		Normalized encoding direction vector [x y z]
%			  FOV			Field of view [x y z] [m]
%
% Output:	B_CC	Concomitant fields B_CC(t) [T]


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

% Evaluate final fields
B_CC = 1/(8*p.B0) * eval(subs(r * M_CC * r.'));