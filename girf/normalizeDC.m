function [output, scale] = normalizeDC(input, mode)
% normalizeDC scales the input signal to 1/sqrt(n) at DC-frequency
%
% input     Input signal: time domain or frequency domain (DC-centered)
% mode		Operation mode [1: time domain (default); 0: Fourier domain]
%
% scale     Normalization factor
% output    Normalized time domain output

if nargin < 2
	mode = 1;
end

n = numel(input);

if mode
	INPUT = ifftshift(ft(input));
	scale = abs(INPUT(1));
	output = input / scale / sqrt(n);
else
	INPUT = ifftshift(input);
	scale = abs(INPUT(1));
	output = input / scale / sqrt(n);
end

return