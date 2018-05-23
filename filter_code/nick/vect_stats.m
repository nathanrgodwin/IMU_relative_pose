function [ mu,covar,diffs ] = vect_stats( X,alpha_mu,alpha_cov)
% X column of arbitrary data
[n,n_vects] = size(X);
mu = alpha_mu*X(:,1) + sum(X(:,2:end),2)/(2*n_vects);

diffs = zeros(n,n_vects);
covar = zeros(n);
for i=1:n_vects
    diffs(:,i) = X(:,i) - mu;
    A = diffs';
    covar = covar + A*A';
end 
covar = covar/(2*n_vects);

A = (X(:,1) - mu)';
covar = covar + alpha_cov*(A*A');

end
