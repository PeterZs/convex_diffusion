function output = timeShift(input, dt, delay)
% timeShift delays a frequency domain input by specified time amount
% through multiplication with an appropriate delaying signal
%
% Inputs:	input	Frequency domain signal to be shifted
%			delay	Delay time [s]
%			dt		Input signal dwell time [s]

N = length (input);
df = 1 / (N*dt);
f = (-N/2:N/2-1)' * df;
ftdelay = exp(-2i*pi*f*delay);
output = input .* ftdelay;