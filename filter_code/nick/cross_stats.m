function [ P_xz ] = cross_stats( W_prime, Z,alpha_mu, alpha_cov )
%W_prime is zero-centered Y points

[n,n_vects] = size(W_prime);
z_mean = (alpha_mu*Z(:,1) + sum(Z(:,2:end),2))/(n_vects);

P_xz = zeros(n);
for i=2:n_vects
    A = W_prime(:,i);
    B = (Z(:,i) - z_mean);
    P_xz = P_xz + A*B';
end 

A = W_prime(:,1);
B = (Z(:,1) - z_mean);
P_xz = (P_xz + alpha_cov*A*B')/n_vects;

end

