function [ z_mean,covar ] = Z_stats( Z,alpha_mu,alpha_cov,z0)
% Z is a column of predicted meas
% z contains quats 
Z_vect = Z(1:12,:);
Z_q1 = aa2quat(Z(13:15,:));
Z_q2 = aa2quat(Z(16:18,:));

[z_mean_vect,covar_vect] = vect_stats(Z_vect,alpha_mu,alpha_cov);
[z_q1,covar_q1, ~] = quat_stats(Z_q1,alpha_mu,alpha_cov,aa2quat(z0(15:17)));
[z_q2,covar_q2, ~] = quat_stats(Z_q2,alpha_mu,alpha_cov,aa2quat(z0(16:18)));

z_mean = [z_mean_vect;quat2aa(z_q1);quat2aa(z_q2)];
covar = blkdiag(covar_vect,covar_q1,covar_q2);

%for z not containing quats
%[z_mean,covar] = vect_stats(Z,alpha_mu,alpha_cov);

end

