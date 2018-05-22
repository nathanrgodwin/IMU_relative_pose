function [ z_mean,covar ] = vect_stats( Z,alpha_mu,alpha_cov)
% Z is a column of predicted accel measurements
[n,n_vects] = size(Z);
z_mean = alpha_mu*Z(:,1) + sum(Z(:,2:end),2)/(2*n);

covar = zeros(n);
for i=1:n_vects
    A = (Z(:,i) - z_mean)';
    covar = covar + A*A';
end 
covar = covar/(2*n);

A = (Z(:,1) - z_mean)';
covar = covar + alpha_cov*(A*A');

end

