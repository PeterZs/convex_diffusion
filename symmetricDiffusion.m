function sym = symmetricDiffusion(p)
% Returns the tE for symmetric DWI waveforms with a specified b-value and
% sequence timing parameters. The waveforms are constructed using:
%		Monopolar pulse pair for M0 nulled
%		Bipolar pulse pair for M0/M1 nulled
%		Modified bipolar pair for M0/M1/M2 nulled (Stoeck et al, MRM 2015)
%
% Input:	p		Parameter structure
%
% Output:	sym		Output waveform data structure

%% Initialize
% Create data structures
sym = struct();
sym.param = p;
dt = p.dt;		% Shorthand access for frequent use

% Initialize
tRamp = p.Gmax/p.Smax;			% Gradient ramp time [s]
tRamp = ceil(tRamp/p.dt)*p.dt;	% Round with to nearest full timestep
nRamp = ceil(tRamp/p.dt);		% Normalized ramp time
N = ceil(5e-5/p.dt);			% Minimal lobe duration in timesteps
b = 0;							% Initialize b

%%  Design symmetric waveform
while (b <= p.bTarget-p.bTol)	% Repeat until the b-value is large enough

	% Create G(t) vector from lobe durations
	switch p.MMT
		case 0 % Monopolar pair
			nGap = p.nRF + max(0,p.mix*(p.nEPI-p.nPre));
			G = trapTransform([N,N],p.Gmax,nRamp,1,nGap,1);
		case 1 % Bipolar pair
			nGap = p.nRF + max(0,p.mix*(p.nEPI-p.nPre));
			G = trapTransform([N,-N,N,-N],p.Gmax,nRamp,1,nGap,2);
		case 2 % Modified bipolar pair
			N2  = 2*N + nRamp;
			nGap = p.nRF + max(0,p.mix*(p.nEPI-p.nPre));
			G = trapTransform([N,-N2,-N2,N],p.Gmax,nRamp,1,nGap,2);
	end

	% Test b-value
	nEnc = length(G);
	p.inv.n = round(nEnc/2) + p.mix*round((nGap-p.nRF)/2);
	b = bValue(G, p);
	
	% Increment lobe duration
	N = N + 1;
	
	% Check break condition
	if (p.tMax < nEnc*dt)
		break;
	end

end

%% Set final values
% Scale gradient to target b-value
sym.G = scaleGmax(G, p);
sym.b = bValue(sym.G, p);

% Lengths and durations
sym.nPre = max(p.nPre, not(p.mix)*p.nEPI);	sym.tPre = sym.nPre * dt;
sym.nEnc = nEnc;							sym.tEnc = sym.nEnc * dt;
sym.nPost = max(0,p.nPre-p.nEPI);			sym.tPost = sym.nPost * dt;
sym.nInv = p.inv.n + sym.nPre;				sym.tInv = sym.nInv * dt;
sym.param.inv.n = sym.nInv;						
sym.nE = 2 * sym.nInv;						sym.tE = sym.nE * dt;
sym.n1 = round(sym.nEnc/2)-round(p.nRF/2);	sym.t1 = sym.n1 * dt;
sym.n2 = sym.n1;							sym.t2 = sym.n2 * dt;

% Split waveforms to pre/post inversion parts
sym.G1 = sym.G(1:sym.n1);
sym.G2 = sym.G((end-sym.n2+1):end);
sym.m1 = maxwellIndex(sym.G1,sym.param);
sym.m2 = maxwellIndex(sym.G2,sym.param);
sym.m = maxwellIndex(sym.G,sym.param);

% Add pre-time to waveform
sym.G = [zeros(sym.nPre,1); sym.G; zeros(sym.nPost,1)];
sym.n = numel(sym.G);