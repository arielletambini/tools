function t = rtotval(r,n)

if length(r)>1;
    n = n*ones(size(r));
end
t = r .* sqrt( (n-2) ./ (1-(r.^2)) );