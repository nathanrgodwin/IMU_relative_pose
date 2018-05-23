function [ z_mean,covar ] = Z_stats( Z,alpha_mu,alpha_cov)
% Z is a column of predicted accel measurements
[z_mean,covar] = vect_stats(Z,alpha_mu,alpha_cov);

end

