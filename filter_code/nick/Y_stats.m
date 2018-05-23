function [ mu, cov, W_prime ] = Y_stats( Y, alpha_mu, alpha_cov, mu_0)
%mu_0 is an initial guess
%check weights later
%change to account for state difference: only 2 quats

Y_q1 = Y(1:4,:);
Y_q2 = Y(5:8,:);
Y_vects = Y(9:end,:);

[mu_q1, cov_q1, W_prime_q1] = quat_stats(Y_q1, alpha_mu,alpha_cov,mu_0(1:4));
[mu_q2, cov_q2, W_prime_q2] = quat_stats(Y_q2, alpha_mu,alpha_cov,mu_0(5:8));
[mu_vects, cov_vects, W_prime_vects] = vect_stats(Y_vects, alpha_mu,alpha_cov);

mu = [mu_q1;mu_q2;mu_vects];
cov = blkdiag(cov_q1,cov_q2,cov_vects);
W_prime = [W_prime_q1;W_prime_q2;W_prime_vects];

end

