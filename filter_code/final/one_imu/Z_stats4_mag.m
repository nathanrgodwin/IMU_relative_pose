function [ z_mean,covar,Z_prime ] = Z_stats4_mag(Z,alpha_mu,alpha_cov,z0)
%for UKF4 with mag

% Z is a column of predicted meas
Z = Z(1:6,:);
[z_mean,covar] = vect_stats(Z,alpha_mu,alpha_cov);

end