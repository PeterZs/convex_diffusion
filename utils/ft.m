function [kSig] = ft (iSig, ftDims)
% ft performs centered and normalized Fourier transform along any
% specified dimensions
%
% iSig      Input signal
% ftDims    Dimensions along which to perform the transform
% 
% kSig      DC-centered k-space output

if nargin < 2
    ftDims = 1:ndims(iSig);
end

% Apply transform along every individual dimension
tmp = iSig;
for i = ftDims
    tmp = 1/sqrt(size(tmp,i)) * fftshift(fft(tmp,[],i),i);
end
kSig = tmp;