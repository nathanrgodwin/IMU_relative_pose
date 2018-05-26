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

n_state = 17;
n_state_vect = n_state - 2; %since 2 quats --> vect
n_sigma_points = n_state_vect*2+1;
n_meas = 18; %ai,aj,wi,wj,GRI,GRJ
n_steps= size(data,2);

% dt = t(2) - t(1);
% g_quat = [0;0;0;1];%gravity vector, units of g 

%M indicates storage variable
%hat indicates estimate
x_hatM = zeros(n_state,n_steps);
%x_hatM(:,1) = [1 0 0 0,1 0 0 0,0 0 0,0 0 0, 0 0 0, 0 0 0]';
x_hatM(:,1) = [1 0 0 0,1 0 0 0,0 0 0,0 0 0, 0 0 0]';
P_hatM = zeros(n_state_vect,n_state_vect,n_steps);
P_hatM(:,:,1) = .001*eye(n_state_vect);

% x t|t-1 . ap = 'a priori', after prediction step
x_apM = zeros(n_state,n_steps);
P_apM = zeros(n_state_vect,n_state_vect,n_steps);

%measurements z: 12, 18 including orientations from matlab
z = data;

% expected measurement z at t 
z_apM = zeros(n_meas,n_steps); 
P_zzM = zeros(n_meas,n_meas,n_steps);

%innovation nu = z - z_ap
nuM = zeros(n_meas,n_steps);
P_nuM = zeros(n_meas,n_meas,n_steps);

P_xzM = zeros(n_state_vect,n_meas,n_steps); % cross corr 
KM = zeros(n_state_vect,n_meas,n_steps); % kalman gain

X = zeros(n_state,n_sigma_points);%sigma points for x_hat
Y = zeros(n_state_vect,n_sigma_points);%sigma points for x_ap
% Z = zeros(n_meas,n_sigma_points);%sigma points for z_ap

%noise covariances. assumed diagonal
%orientation, process noise will be in rot vel perturbations converted to quats
q = 2;
r = 1;
Q = q*eye(n_state_vect);
R = r*eye(n_meas); 

%weights for averaging 

alpha_mu = 1; %or 0
alpha_cov = 1; % or 2 

for i = 1: n_steps
    i
    %PREDICTION
    X = gen_sigma_points(x_hatM(:,i),P_hatM(:,:,i) + Q); 
%     figure(1)
%     surf(X); xlabel('x');ylabel('y');title('X');
    Y = process_a(X);
%     figure(2)
%     surf(Y); xlabel('x');ylabel('y');title('Y');
    [x_ap, P_ap, W_prime] = Y_stats(Y,alpha_mu,alpha_cov,x_hatM(:,i));% stats from Y. W_prime: Y with x_ap subtracted from each. W_prime in vector space
    
    %UPDATE
    Z = measurement_h(Y);% measurement model h to get sigma points from Y
    [z_ap, P_zz, Z_prime] = Z_stats(Z,alpha_mu,alpha_cov, z_apM(:,i));
    
    nu = z(:,i) - z_ap;
    P_nu = P_zz + R;
    P_xz = cross_stats(W_prime,Z_prime,alpha_cov);
    K = P_xz*P_nu^-1;
    % x_k|k = x_ap + K*nu
%     Kv = K*nu;
    Kv = P_xz*(P_nu\nu);    
    
    x_hat = zeros(n_state,1);
    x_hat(1:4) = quatproduct(x_ap(1:4), aa2quat(Kv(1:3)));
    x_hat(5:8) = quatproduct(x_ap(5:8), aa2quat(Kv(4:6)));

    x_hat(9:end) = x_ap(9:end) + Kv(7:end);
%     x_hat(1:4,i+1) = quatproduct( x_ap(1:4,i+1), aa2quat(K(1:4,1:4,i+1)*nu(1:3,i+1)) );
%     x_hat(5:8,i+1) = quatproduct( x_ap(5:8,i+1), aa2quat(K(5:8,5:8,i+1)*nu(5:8,i+1)) );
%     x_hat(9:end,i+1) = x_ap(9:end) + K(9:end,9:end,i+1)*nu(9:end,i+1);

%     P_hat = P_ap - K*P_nu*K';
    P_hat = P_ap - P_xz*((P_nu')\(P_xz'));
    
    if min(eig(P_hat)) < 0
        P_hat = nearestSPD(P_hat);
        fprintf('non PSD P_hat');
    end 
    %STORE MEMORY
    x_hatM(:,i+1) = x_hat;
    P_hatM(:,:,i+1) = P_hat;
    x_apM(:,i+1) = x_ap;
    P_apM(:,:,i+1) = P_ap;
    z_apM(:,i+1) = z_ap;
    P_zzM(:,:,i+1) = P_zz;
    nuM(:,i+1) = nu;
    P_nuM(:,:,i+1) = P_nu;
    P_xzM(:,:,i+1) = P_xz;
    KM(:,:,i+1) = K;
end 

%% plot results 

axis_len = 1;
axis_tips = axis_len*eye(3);


function A_=inversePD(A)
%A:positive definite matrix
M=size(A,1);
[R b] = chol(A);
if b~=0
    return
end
R_ = R \ eye(M);
A_ = R_ * R_';
end
