% load('Z_test.mat')
% alpha_mu = 0.5;
% alpha_cov = 0.5;
% [mu, covar, diffs] = vect_stats( X,alpha_mu,alpha_cov)
% 
% mu
% test_mu = sum(X(:,2:37),2)./36
% 
% covar
% test_covar = zeros(12)
% for i = 2:37
%     test_covar = test_covar + ( (X(:,i)-test_mu)*(X(:,i)-test_mu)' );
% end
% test_covar = test_covar./36
% 
% cov(X')


X = gen_sigma_points(state2vector(new_state()),eye(18)); 
Y = process_a(X);
Z = measurement_h(Y);% measurement model h to get sigma points from Y

y_idx = (1:4);
w_idx = [1:4, 20:22];
z_idx = (16:18);

quat2aa(Y(y_idx, w_idx))
Z(z_idx, w_idx)

quat_stats(Y(y_idx, w_idx), 1, 1, [1 0 0 0]')

% [x_ap, P_ap, W_prime] = Y_stats(Y,alpha_mu,alpha_cov,x_hatM(:,i));% stats from Y. W_prime: Y with x_ap subtracted from each. W_prime in vector space

%UPDATE
% [z_ap, P_zz] = Z_stats(Z,alpha_mu,alpha_cov, z_apM(:,i));

