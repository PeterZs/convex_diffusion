function cvx = convexDiffusion(p, nBot, nTop, verbose)
% Generates diffusion encoding waveforms for a target b-value subject to 
% hardware constraints and sequence timing parameters with optimized
% concomitant field and gradient moment evolution
%
% Input:	p		Parameter structure
%			nBot	Lower bound on gradient encoding length
%			nTop	Upper bound on gradient encoding length
%			verbose	Print optimization info to output [Bool]
%
% Output:	cvx		Output waveform data structure

%% Initialize
% Create data structures
cvx = struct();
cvx.param = p;
dt = p.dt;		% Shorthand access for frequent use

% Define the moment nulling vector
switch p.MMT
  case 0
    mvec =  [0, inf, inf]; 	% M0-nulled gradient
  case 1
    mvec =  [0, 0, inf];	% M0/M1-nulled gradilent
  case 2
    mvec =  [0, 0, 0];		% M0/M1/M2-nulled gradient
end

% Initialize optimization values
nMax = round(p.tMax/dt);
n = nTop;
done = 0;
if p.coco
	bBot = p.bTarget;
else
	bBot = 0;
end

%% Optimize
if verbose, fprintf('Optimizing... \n'); end
while not(done)
	
	% Set encoding length and inversion time
	if isnan(p.x)
		x = min(1, (n+p.nRead/2-p.nRF) / (2*n-2*p.nRF));
	else
		x = p.x;
	end
	n1 = round(x * (n-p.nRF));
	n2 = round((1-x) * (n-p.nRF));
	nPre = max(0, n2 - n1 + round(p.nRead/2));
	nInv = n1 + round(p.nRF/2);
	p.inv.n = nInv;
	nE = 2 * nInv;
	nPost = max(0, nE - n - round(p.nRead/2));
	
	% Display bounds
	if verbose, fprintf ('	%2.2f ms < (tE = %2.2fms) <= %2.2fms ... ', ...
						(nPre+[nBot n nTop]+nPost+p.nRead/2)*dt*1e3); end
		
	% Initialize optimization step
	G = sdpvar(n,1);
	D = diag(-ones(n,1),0) + diag(ones(n-1,1),1);
	D = D(1:end-1,:);
	S = D * G / dt;
	C = tril(ones(n));

	% Define constraints on G(t)
	rfPulse = max(n1,1):min(n1+p.nRF,n);
	constraints = [ G(1) == 0, G(2)>=0, G(n) == 0, G(rfPulse) == 0 ...
					G <= p.Gmax, G >= -p.Gmax ...
					S <= p.Smax, S >= -p.Smax ...
					abs(gradientMoments(G,p)) <= mvec ];

	% Set objective function and options
	objective = -abs(sum(cumsum(C*G)));
	if p.TV
		slewTV = trapz(abs(D*[0;S]/dt)) / (n-2);
		objective = objective + p.lambda * slewTV;
	end
	options = sdpsettings('verbose',0,'solver','cplex','cachesolvers',1);

	% Run gradient optimization
	optimize(constraints, objective, options);
	
	% Concomitant field compensation
	if p.coco
		% Set Maxwell index bound
		m1 = maxwellIndex(G(1:n1), p);
		m2 = maxwellIndex(G((n-n2):n), p);
		mMax = max(p.mMin,value(m2));
		
		% Re-run optimization with additional Maxwell constraint
		constraints = [constraints, m1 <= mMax];
		optimize(constraints, objective, options);
		
		% Optimize again if result was not sufficiently contrained
		if (abs(value(m1-m2)) > p.mMin) && (value(m2) > p.mMin)
			mMax = max(p.mMin,value(m2));
			constraints = [constraints, m1 <= mMax];
			optimize(constraints, objective, options);
		end
		
		% Print index values
		if verbose, fprintf('m1 = %2.2f ... m2 = %2.2f ... ', value([m1 m2])*1e6); end
	end
	
	% Check b-value of gradient
	G_tmp = value(G);
	b = bValue(G_tmp, p);
	if isnan(b), b = 0; end
	if verbose, fprintf('b = %2.2f s/mm^2 \n', b*1e-6); end

	% Check termination condition
	if (nTop <= nBot) || (abs(b-p.bTarget) <= p.bTol)
		% Done - return waveform
		cvx.G = scaleGmax(G_tmp, p);
		cvx.b = bValue(cvx.G, p);
		if verbose, fprintf('	DONE \n'); end
		done = 1;
	else
		% Test b-value against desired b-value
		if b > p.bTarget
			nTop = n;
			c = p.bTarget/(b+bBot);
			n = floor((1-c)*nBot + c*nTop);
			bTop = b;
		elseif  n == nTop
			% nTop was infeasible to start with: improper bounds
			nBot = nTop;
			nTop = nTop + round(10e-3/dt);	% +10ms
			n = nTop;
			bBot = b;
		else
			nBot = n + 1;
			c = p.bTarget/(b+bTop);
			n = floor((1-c)*nBot + c*nTop);
			bBot = b;
		end
	end
	
	% Hard termination condition
	if n > nMax 
		fprintf('n = %d > nMax = %d: terminating bisection \n',n,nMax);
		cvx.G = value(G);
		cvx.b = b;
		done = 1;
	end
end

%% Set final values
% Lengths & durations
cvx.param.x = x;
cvx.nPre = nPre;			cvx.tPre = cvx.nPre * dt;
cvx.nEnc = n;				cvx.tEnc = cvx.nEnc * dt;
cvx.nPost = nPost;			cvx.tPost = cvx.nPost* dt;
cvx.nInv = nPre + nInv;		cvx.tInv = cvx.nInv * dt;
cvx.param.inv.n = cvx.nInv;
cvx.nE = 2 * cvx.nInv;		cvx.tE = cvx.nE * dt;
cvx.n1 = n1;				cvx.t1 = cvx.n1 * dt;
cvx.n2 = n2+1;				cvx.t2 = cvx.n2 * dt;

% Split waveforms to pre/post inversion parts
cvx.G1 = cvx.G(1:cvx.n1);
cvx.G2 = cvx.G((end-cvx.n2+1):end);
cvx.m1 = maxwellIndex(cvx.G1,cvx.param);
cvx.m2 = maxwellIndex(cvx.G2,cvx.param);
cvx.m = maxwellIndex(cvx.G, cvx.param);

% Add dead time before/after the encoding to center the readout in tE
cvx.G = [zeros(nPre,1); cvx.G; zeros(nPost,1)];
cvx.n = length(cvx.G);