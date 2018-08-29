function  res = TV_Dim(dim,recover)
% TV_Dim implements finite difference operator along a  specified dimension
%
% dim       Dimension of data along which to calculate the TV
% recover	Specifies if the original magnitude should be recovered by the
%           inverse transform by saving magnitude information in the last
%           element of the forward transform

res.adjoint = 0;
res.dim = dim;
if exist('recover','var')
    res.recover = recover;
else
    res.recover = false;
end
res = class(res,'TV_Dim');

return