function Bc = kCenterFields (B)
% kCenterFields returns the fields at k space center for a given time-
% -varying spatial field distribution B(t,x,y,z)
%
% Input:	B		Spatially-varying field distribution B(t,x,y,z) [T,m,m,m]
%
% Output:	Bc		Field variation at k space center [T]

kB = ft(B,[2,3,4]);
s = size(kB);
s = floor(s(2:end) / 2) + 1;
Bc = kB(:,s(1),s(2),s(3));