clear all
close all
gen_data
%% states
% 1: G_R_I = 4x1 quat
% 2: I_R_J = 4x1 quat
% 3: I_P_J = 3x1 position % UNNEEDED 
% 4: G_w = 3x1 rot vel
% 5: G_P_I = 3x1 position
% 6: G_V_I_0 = 3x1 translation vel
% 7: G_V_I_neg1 = 3x1 %translation vel

n_state = 20;
n_state_vect = n_state - 2; %since 2 quats --> vect
n_sigma_points = n_state_vect*2+1;
n_meas = 18; %ai,aj,wi,wj,GRI,GRJ
n_steps= size(data,2);

% dt = t(2) - t(1);

% g_quat = [0;0;0;1];%gravity vector, units of g 

%estimates
x_hat = zeros(n_state,n_steps);
x_hat(:,1) = [1 0 0 0,1 0 0 0,0 0 0,0 0 0, 0 0 0, 0 0 0]';
P_hat = zeros(n_state_vect,n_state_vect,n_steps);
P_hat(:,:,1) = .001*eye(n_state_vect);

% x t|t-1 . ap = 'a priori', after prediction step
x_ap = zeros(n_state,n_steps);
P_ap = zeros(n_state_vect,n_state_vect,n_steps);

%measurements z: 12, 18 including orientations from matlab
z = data;

% expected measurement z at t 
z_ap = zeros(n_meas,n_steps); 
P_zz = zeros(n_meas,n_meas,n_steps);

%innovation nu = z - z_ap
nu = zeros(n_meas,n_steps);
P_nu = zeros(n_meas,n_meas,n_steps);

P_xz = zeros(n_meas,n_meas,n_steps); % cross corr 
K = zeros(n_meas,n_meas,n_steps); % kalman gain

X = zeros(n_state,n_sigma_points);%sigma points for x_hat
Y = zeros(n_state_vect,n_sigma_points);%sigma points for x_ap
% Z = zeros(n_meas,n_sigma_points);%sigma points for z_ap

%noise covariances. assumed diagonal
%orientation, process noise will be in rot vel perturbations converted to quats
q = 1;
r = 1;
Q = q*eye(n_state_vect);
R = r*eye(n_state_vect); 

%weights for averaging 

alpha_mu = .5; %or 0
alpha_cov = .5; % or 2 

for i = 1: n_steps
    %PREDICTION
    X = gen_sigma_points(x_hat(:,i),P_hat(:,:,i) + Q); 
    Y = process_a(X);
    [x_ap(:,i+1), P_ap(:,:,i+1), W_prime] = Y_stats(Y,alpha_mu,alpha_cov,x_hat(:,i));% stats from Y. W_prime: Y with x_ap subtracted from each. W_prime in vector space
        %   ^ Winson changed i to i+1
    
    %UPDATE
    Z = measurement_h(Y);% measurement model h to get sigma points from Y
    [z_ap(:,i+1), P_zz(:,:,i+1)] = Z_stats(Z,alpha_mu,alpha_cov, z_ap(:,i));
    
    nu(:,i+1) = z(:,i+1) - z_ap(:,i+1);
    P_nu(:,:,i+1) = P_zz(:,:,i+1) + R;
    P_xz(:,:,i+1) = cross_stats(W_prime,Z,alpha_mu,alpha_cov);
    K(:,:,i+1) = P_xz(:,:,i+1)*P_nu(:,:,i+1)^-1;
    % x_k|k = x_ap + K*nu
    Kv = K(:,:,i+1)*nu(:,i+1);
    
    x_hat(1:4,i+1) = quatproduct(x_ap(1:4,i+1), aa2quat(Kv(1:3)));
    x_hat(5:8,i+1) = quatproduct(x_ap(5:8,i+1), aa2quat(Kv(4:6)));

    x_hat(9:end,i+1) = x_ap(9:end,i+1) + Kv(7:end);
%     x_hat(1:4,i+1) = quatproduct( x_ap(1:4,i+1), aa2quat(K(1:4,1:4,i+1)*nu(1:3,i+1)) );
%     x_hat(5:8,i+1) = quatproduct( x_ap(5:8,i+1), aa2quat(K(5:8,5:8,i+1)*nu(5:8,i+1)) );
%     x_hat(9:end,i+1) = x_ap(9:end) + K(9:end,9:end,i+1)*nu(9:end,i+1);
    %P = P_ap - K*P_nu*K'
    P_hat(:,:,i+1) = P_ap(:,:,i+1) - K(:,:,i+1)*P_nu(:,:,i+1)*K(:,:,i+1)';    
end 

%% plot results 

axis_len = 1;
axis_tips = axis_len*eye(3);
