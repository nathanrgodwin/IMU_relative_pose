function [ z_mean,covar ] = Z_stats( Z,alpha_mu,alpha_cov,z0)
% Z is a column of predicted meas
% z contains quats 
% Z_vect = Z(1:12,:);
% Z_q1 = Z(13:16,:);
% Z_q2 = Z(17:20,:);
% 
% [z_mean_vect,covar_vect] = vect_stats(Z_vect,alpha_mu,alpha_cov);
% [z_q1,covar_q1] = quat_stats(Z_q1,alpha_mu,alpha_cov,z0);
% [z_q2,covar_q2] = quat_stats(Z_q2,alpha_mu,alpha_cov,z0);
% 
% z_mean = [z_mean_vect;z_q1;z_q2];
% covar = blkdiag(covar_vect,covar_q1,covar_q2);

%for z not containing quats
[z_mean,covar] = vect_stats(Z,alpha_mu,alpha_cov);

end

