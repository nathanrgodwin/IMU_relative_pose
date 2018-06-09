function [ z_mean,covar,Z_prime ] = Z_stats_4_mag(Z,alpha_mu,alpha_cov,z0)
% Z is a column of predicted meas

[z_mean,covar] = vect_stats(Z,alpha_mu,alpha_cov);

end

