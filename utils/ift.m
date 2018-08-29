function [iSig] = ift (kSig, ftDims)
% ift performs centered and normalized inverse Fourier transform along 
% any specified dimensions
%
% kSig      DC-centered k-space input
% ftDims    Dimensions along which to perform the transform
% 
% iSig      Output signal

if nargin < 2
    ftDims = 1:ndims(kSig);
end

% Apply transform along every individual dimension
tmp = kSig;
for i = ftDims
    tmp = sqrt(size(tmp,i)) * ifft(ifftshift(tmp,i),[],i);
end
iSig = tmp;