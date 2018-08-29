function res = mtimes(a,b)

dims = 1:ndims(b);
order = [a.dim dims(dims~=a.dim)];
b = permute (b,order);
s = size(b);
if a.adjoint
    if a.recover
        res = cumsum (-b,1,'reverse');
    else
        res = adjD(b);
    end
else
    if a.recover
        res = [diff(b,1,1);b(end,:,:,:,:,:,:,:,:,:,:,:)];
    else
        res = D(b);
    end
end
res = reshape (res,s);
res = ipermute (res,order);

end


function y = D(x)

y = x([2:end,end],:,:,:,:,:,:,:,:,:,:,:) - x;

end


function y = adjD(x)

if size(x,1)>1
    y = x([1,1:end-1],:,:,:,:,:,:,:,:,:,:,:) - x;
end
y(1,:) = -x(1,:);

end