function [x_hatM, P_hatM] = UKF4(data,t,Q,R)

if size(data,1) > 8
    data = data(1:6,:);
end
%measurements AxAyAz from I IMU
z = data(1:3,:); %measurements
u = data(4:6,:);

%% states
% 1: G_R_I = 4x1 quat

n_state = 4;
n_state_vect = n_state - 1; %since 1 quat --> vect
n_sigma_points = n_state_vect*2+1;
n_meas = 3;
n_steps= size(data,2);

g_quat = [0;0;0;9.8];%gravity vector, units of m/s^2

%M indicates storage variable
%hat indicates estimate
x_hatM = zeros(n_state,n_steps);
x_hatM(:,1) = [1 0 0 0];
P_hatM = zeros(n_state_vect,n_state_vect,n_steps);
P_hatM(:,:,1) = .0001*eye(n_state_vect);

% x t|t-1 . ap = 'a priori', after prediction step
x_apM = zeros(n_state,n_steps);
P_apM = zeros(n_state_vect,n_state_vect,n_steps);

% expected measurement z at t
z_apM = zeros(n_meas,n_steps);
P_zzM = zeros(n_meas,n_meas,n_steps);

%innovation nu = z - z_ap
nuM = zeros(n_meas,n_steps);
P_nuM = zeros(n_meas,n_meas,n_steps);

P_xzM = zeros(n_state_vect,n_meas,n_steps); % cross corr
KM = zeros(n_state_vect,n_meas,n_steps); % kalman gain

%X = zeros(n_state,n_sigma_points);%sigma points for x_hat
Y = zeros(n_state,n_sigma_points);%sigma points for x_ap
Z = zeros(n_meas,n_sigma_points);%sigma points for z_ap

if nargin < 4
    %noise covariances. assumed diagonal
    %orientation, process noise will be in rot vel perturbations converted to quats
    q = 1e-8;
    r = 1e0;
    Q = q*eye(n_state_vect);
    R = r*eye(n_meas);
end

%weights for averaging
alpha_mu = 0; %or 0
alpha_cov = 2; % or 2

for itr = 1: n_steps-1
    dt = t(itr+1) - t(itr);
    %PREDICTION
    X = gen_sigma_points4(x_hatM(:,itr),P_hatM(:,:,itr) + Q);
    %     figure(1)
    %     surf(X); xlabel('x');ylabel('y');title('X');
    for i_sp=1:n_sigma_points
        Y(:,i_sp) = quatproduct(X(:,i_sp), aa2quat(u(:,itr)*dt));
    end
    %     figure(2)
    %     surf(Y); xlabel('x');ylabel('y');title('Y');
    [x_ap, P_ap, W_prime] = Y_stats4(Y,alpha_mu,alpha_cov,x_hatM(:,itr));% stats from Y. W_prime: Y with x_ap subtracted from each. W_prime in vector space
    
    %UPDATE
    for i_sp = 1:n_sigma_points
        tempg = quatproduct(g_quat,Y(:,i_sp));
        temp = quatproduct([Y(1,i_sp);-Y(2:4,i_sp)],tempg);
        Z(:,i_sp) = temp(2:4);
    end
    
    [z_ap, P_zz] = Z_stats4(Z,alpha_mu,alpha_cov);
    
    nu = z(:,itr+1) - z_ap;
    P_nu = P_zz + R;
    P_xz = cross_stats(W_prime,Z,alpha_mu, alpha_cov);
    K = P_xz*P_nu^-1;
    
    % x_k|k = x_ap + K*nu
    
    x_hat = quatproduct(x_ap, aa2quat(K*nu));
    P_hat = P_ap - K*P_nu'*K';
    
    if min(eig(P_hat)) < 0
        P_hat = nearestSPD(P_hat);
        fprintf('non PSD P_hat\n');
    end
    %STORE MEMORY
    x_hatM(:,itr+1) = x_hat;
    P_hatM(:,:,itr+1) = P_hat;
    x_apM(:,itr+1) = x_ap;
    P_apM(:,:,itr+1) = P_ap;
    z_apM(:,itr+1) = z_ap;
    P_zzM(:,:,itr+1) = P_zz;
    nuM(:,itr+1) = nu;
    P_nuM(:,:,itr+1) = P_nu;
    P_xzM(:,:,itr+1) = P_xz;
    KM(:,:,itr+1) = K;
end


%% put x_hat to csv for python to read
%csvwrite('x_hat_from_UKFmatlab.csv',x_hatM);

%% plot results

%to use python results:
%x_hatM = csvread('x_hat_from_UKFpython.csv');

% figure
% surf(x_hatM,'edgecolor', 'None');
% plot(t,x_hatM);

% eulers = 180/pi*quatern2euler(x_hatM');
%
% fig = figure;
% subplot(3,1,1)
% plot(t,eulers(:,1));
% subplot(3,1,2)
% plot(t,eulers(:,2));
% subplot(3,1,3)
% plot(t,eulers(:,3));

% x_hat_python = csvread('x_hat_from_UKFpython.csv');
% x_hat_err = x_hat_python - x_hatM;
% figure; surf(x_hat_err)

end


