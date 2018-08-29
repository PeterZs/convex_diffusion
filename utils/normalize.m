function [output, scale] = normalize(input)
% normalize scales data values to absolute values smaller or equal to 1.
%
% input     n-dimensional numerical input (real/complex)
% scale     Normalization factor
%
% output    Normalized output

scale = max(abs(input(:)));
output = input / scale;