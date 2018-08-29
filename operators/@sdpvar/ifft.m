function Y=ifft(X,N,dim)
%IFFT (overloaded)

x_lmi_variables = X.lmi_variables;
n = X.dim(1);
m = X.dim(2);
Y=X;
Y.basis = zeros(size(X.basis));
for i = 1:length(x_lmi_variables)+1
    x=reshape(X.basis(:,i),n,m);
    if exist('dim','var') && exist('N','var')
        z = ifft(full(x),N,dim);
    elseif exist('N','var')
        z = ifft(full(x),N);
    else
        z = ifft(full(x));
    end
    Y.basis(:,i) = z(:);
end
Y.dim(1) = size(z,1);
Y.dim(2) = size(z,2);
Y = clean(Y);
% Reset info about conic terms
if isa(Y,'sdpvar')
    Y.conicinfo = [0 0];
    Y = flush(Y);
end