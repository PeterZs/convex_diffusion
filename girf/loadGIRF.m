function girf = loadGIRF(T, dt)
% loadGIRF loads and adapts a gradient impulse response function from file
%
% Input:	T		Duration of final GIRF [s]
%			dt		Time step [s]
%
% Output:	girf	Time domain gradient impulse response function

% Set parameters
tOffset = -2.97e-3;						% Global delay to correct
dir = ['X', 'Y', 'Z'];					% Directions that are loaded

for i = 1:numel(dir)
	
	load([fileparts(which(mfilename)) '/philips/', 'GIRF_' dir(i) '.mat'])
	GIRF = downsampleGIRF(GIRF, Fs, round(1/dt));
	GIRF = timeShift(GIRF,dt,tOffset);	% Correct offset
	girfDir = ift(GIRF);				% Transform to time domain
	
	girfDir = real(girfDir);			% Discard imaginary part from FFT rounding error
	girfDir = girfDir(1:round(T/dt));	% Truncate length
	girf(:,i) = normalizeDC(girfDir);	% Normalize at DC
	
end