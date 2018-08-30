function cvx = convexDiffusion(nBot, nTop)
% Generates diffusion encoding waveforms for a target b-value subject to 
% hardware constraints and sequence timing parameters with optimized
% concomitant field and gradient moment evolution

%% Initialize
% Create data structures
cvx = struct();
cvx.param = parameters('cvx');
p = cvx.param;	% Shorthand access to parameters
dt = p.dt;		% Easy access for frequent use

% Define the moment nulling vector
switch p.MMT
  case 0
    mvec =  [0, inf, inf]; 	% M0-nulled gradient
  case 1
    mvec =  [0, 0, inf];	% M0/M1-nulled gradilent
  case 2
    mvec =  [0, 0, 0];		% M0/M1/M2-nulled gradient
end

% Optimization values
done = 0; bBot = 0; n = nTop;

%% Optimize
fprintf('Optimizing... \n');
while not(done)
	% Set encoding length and inversion time
	n1 = ceil(p.x * (n-p.nRF));
	n2 = floor((1-p.x) * (n-p.nRF));
	nPre = max(0, n2 - n1 + round(p.nRead/2));
	nInv = n1 + round(p.nRF/2);
	nE = 2 * nInv;
	nPost = max(0, nE - n - round(p.nRead/2));
	
	% Display bounds
	fprintf('	tE <= %2.2fms ', (nPre+nTop+nPost+p.nRead/2)*dt*1e3);
	fprintf('	... tE > %2.2fms', (nPre+nBot+nPost+p.nRead/2)*dt*1e3);
		
	% Initialize optimization step
	G = sdpvar(n,1);
	D = diag(-ones(n,1),0) + diag(ones(n-1,1),1);
	D = D(1:end-1,:);
	S = D * G / dt;
	C = tril(ones(n));

	% Calculate concomitant field fields
	if p.coco
		m1 = maxwellIndex(G(1:n1), p);
		m2 = maxwellIndex(G(n-n2:n), p);
	else
		m1 = 0; m2 = 0;
	end

	% Define constraints on G(t)
	p.inv.n = nInv;
	rfPulse = max(n1,1):min(n1+p.nRF,n);
	constraints = [ G(1) == 0, G(n) == 0, G(rfPulse) == 0 ...
					G <= p.Gmax, G >= -p.Gmax ...
					S <= p.Smax, S >= -p.Smax, ...
					m1 <= p.mMax, m2 <= p.mMax, ...
					abs(gradientMoments(G, p)) <= mvec ];

	% Set objective function and options
	objective = -abs(sum(cumsum(C*G)));
	if p.TV
		slewTV = trapz(abs(D*[0;S]/dt)) / (n-2);
		objective = objective + p.lambda * slewTV;
	end
	options = sdpsettings('verbose',0,'solver','cplex','cachesolvers',1);

	% Run gradient optimization
	optimize(constraints, objective, options);
	G_tmp = value(G);
	
	% Check b-value of gradient
	b = bValue(G_tmp, p);
	if isnan(b), b = 0; end
	fprintf(' ... b = %2.2f s/mm^2 \n', b*1e-6);
	
	% Check termination condition
	if (nTop <= nBot) || (abs(b-p.bTarget) <= 0.01*p.bTarget)
		% Done - return waveform
		cvx.G = scaleGmax(G_tmp, p);
		fprintf('	DONE \n');
		done = 1;
	else
		% Test b-value against desired b-value
		if (b > p.bTarget)
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
	if( n > p.nMax )
		fprintf('n = %d > nMax = %d: terminating bisection \n',n,p.nMax);
		cvx.G = NaN * ones(size(n));
		done = 1;
	end
end

%% Set final values
% Lengths & durations
cvx.nPre = nPre;			cvx.tPre = cvx.nPre * dt;
cvx.nEnc = n;				cvx.tEnc = cvx.nEnc * dt;
cvx.nPost = nPost;			cvx.tPost = cvx.nPost* dt;
cvx.nInv = nPre + nInv;		cvx.tInv = cvx.nInv * dt;
cvx.param.inv.n = cvx.nInv;
cvx.nE = 2 * cvx.nInv;		cvx.tE = cvx.nE * dt;
cvx.n1 = nPre + n1;			cvx.t1 = cvx.n1 * dt;
cvx.n2 = n2 + nPost;		cvx.t2 = cvx.n2 * dt;

% Add dead time before/after the encoding to center the readout in tE
cvx.G = [zeros(nPre,1); cvx.G; zeros(nPost,1)];
cvx.n = length(cvx.G);
cvx.b = bValue(cvx.G, p);

% Split waveforms to pre/post inversion parts

% Split waveforms to pre/post inversion parts
cvx.G1 = cvx.G(1:cvx.n1);
cvx.G2 = cvx.G(cvx.n1+cvx.param.nRF:end);