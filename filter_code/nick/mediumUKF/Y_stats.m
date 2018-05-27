function [ mu, cov, W_prime ] = Y_stats( Y, alpha_mu, alpha_cov, mu_0)
%mu_0 is an initial guess

Y_q1 = Y(1:4,:);
Y_vect = Y(5:7,:);

[mu_q1, cov_q1, W_prime_q1] = quat_stats(Y_q1, alpha_mu,alpha_cov,mu_0(1:4));
[mu_vect, cov_vect,W_prime_vec] = vect_stats(Y_vect, alpha_mu,alpha_cov);

mu = [mu_q1;mu_vect];
cov = blkdiag(cov_q1,cov_vect);
W_prime = [W_prime_q1;W_prime_vec];

end

