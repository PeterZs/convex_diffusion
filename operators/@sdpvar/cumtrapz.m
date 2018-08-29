function Y = cumtrapz(Y)
%CUMTRAPZ (overloaded)

Y.basis = cumtrapz(Y.basis,1);
% Reset info about conic terms
Y.conicinfo = [0 0];
Y = clean(Y);
