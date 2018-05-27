function [ P_xz ] = cross_stats( W_prime, Z,alpha_mu, alpha_cov )
%W_prime is zero-centered Y points

[n,n_vects] = size(W_prime);
[m, ~] = size(Z);

%[ z_mean,~ ] = Z_stats(Z,alpha_mu,alpha_cov, Z(:,1));
z_mean = alpha_mu*Z(:,1) + sum(Z(:,2:end),2)/(n_vects-1);

P_xz = zeros(n,m);
for i=2:n_vects
    A = W_prime(:,i);
    B = Z(:,i) - z_mean;
    P_xz = P_xz + A*B';
end 
P_xz = P_xz/(n_vects-1);

A = W_prime(:,1);
B = Z(:,1) - z_mean;
P_xz = P_xz + alpha_cov*A*B';

end

