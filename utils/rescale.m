function A = rescale(A,l,u)
% Rescales the input data to the range [l,u]
%
% Input:	A	Data to be rescaled
%			l	Lower bound
%			u	Upper bound

A = A - min(A(:));
A = (A/range(A(:))) * (u-l);
A = A + l;