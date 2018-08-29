function girf = loadGIRF(T, dt)
% loadGIRF loads and adapts a gradient impulse response function from file
%
% Input:	T		Length of GIRF [s]
%			dt		Time step [s]
%
% Output:	girf	Time domain gradient impulse response function

% Set parameters
tOffset = -2.97e-3;	% Global delay to correct

load([fileparts(which(mfilename)) '/philips/', 'GIRF_X.mat'])
GIRF = downsampleGIRF(GIRF, Fs, round(1/dt));
GIRF = timeShift(GIRF,dt,tOffset);	% Correct offset
girf = real(ift(GIRF));				% Discard imaginary part from FFT rounding error
girf = girf(1:round(T/dt));			% Truncate length
girf = normalizeDC(girf);			% Normalize at DC

end