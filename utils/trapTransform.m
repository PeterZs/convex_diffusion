function G = trapTransform(f,Gmax,SR,n,gap,gapPos)
% produce a gradient waveform from a description of trapezoidal durations
% (and signs) assuming G = Gmax in all plateaus
%
% Input:	f		Row vector indicating the duration of each gradient 
%					lobe in ms. Must correspond to an integer number of
%					timepoints. Negative numbers indicate trapezoids with
%					NEGATIVE polarity.
%			Gmax	All lobes assumed to be at maximum gradient strength
%			SR		Slew duration normalized to unit size (default: 1)
%			n		Normalized temporal resolution (default: 1)
%			gap		Normalized gap duration an RF pulse (default: 0)
%			gapPos	Position of RF pulse (how many traps to play prior
%
% Output:	g		Fully represented gradient waveform as a vector


% Set defaults
if nargin<4, n = 1; end
if nargin<5, gap = 0; end
if nargin<6, gapPos = floor(length(f)/2); end

% Check parameters
if min(abs(f)) < 1
  fprintf('ERROR - Need to allow time for slewing!!!\n');
  return;
end

% Start with a waveform with all values at Gmax
G = Gmax * ones((sum(abs(f)) + gap + 2*numel(f)*SR - (numel(f)-1))*n, 1);
count = 1;

% Loop through plateaus described and create trapezoids
for i = 1:length(f)
	PLAT = abs(f(i));
	tNow = count;
	
	% Ramp up
	G(tNow:tNow+SR-1) = G(tNow:tNow+SR-1).*(0:1/SR:1-1/SR)'*(f(i)/PLAT);
	tNow = tNow + SR;
	
	% Plateau
	G(tNow:tNow+PLAT*n-1) = G(tNow:tNow+PLAT*n-1)*f(i)/PLAT;
	tNow = tNow + PLAT*n;
	
	% Ramp down
	G(tNow:tNow+SR-1) = G(tNow:tNow+SR-1).*(1-(1/SR:1/SR:1))'*(f(i)/PLAT);
	count = tNow + SR-1;
	
	% Gap
	if i == gapPos
		G(count+1:count+gap*n) = G(count+1:count+gap*n)*0;
		count = count + gap*n;
	end
end