%% Given estimated angular body accel in the global frame, 2 IMU meas, orientation, estimates 
% - relative pose
%angular body accel in global frame assumes baselineUKF already used to
%transform angular velocity measurements
close all

% %measurements AxAyAz from I IMU
% z_AIM = data(1:3,:); %measurements
% z_AJM
% z_Jw


% %x: extra information from preprocessing
% x_I_w_I = data(4:6,:);%data from 276a. measurement but used as input to
% x_G_w_I =
% x_G_alpha_I = G_alpha%check that this is time-aligned
% x_GRI = GRI;

%% states
% 1: G_R_I = 4x1 quat

n_state = 7;
n_state_vect = n_state - 1; %since 2 quats --> vect
n_sigma_points = n_state_vect*2+1;
n_meas = 12; %ai,aj,wi,wj
n_steps= size(x_G_alpha,2);

g_quat = [0;0;0;1];%gravity vector, units of g

%M indicates storage variable
%hat indicates estimate
x_hatM = zeros(n_state,n_steps);
%x_hatM(:,1) = [1 0 0 0,1 0 0 0,0 0 0,0 0 0, 0 0 0, 0 0 0]';
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

X = zeros(n_state,n_sigma_points);%sigma points for x_hat
Y = zeros(n_state,n_sigma_points);%sigma points for x_ap
Z = zeros(n_meas,n_sigma_points);%sigma points for z_ap

%noise covariances. assumed diagonal
%orientation, process noise will be in rot vel perturbations converted to quats
q = .001;
r = .01;
Q = q*eye(n_state_vect);
R = r*eye(n_meas);
%weights for averaging 
alpha_mu = 0; %or 0
alpha_cov = 2; % or 2 

for itr = 1: n_steps-1
    dt = t(itr+1) - t(itr);
    %PREDICTION
    X = gen_sigma_points(x_hatM(:,itr),P_hatM(:,:,itr) + Q); 
%     figure(1)
%     surf(X); xlabel('x');ylabel('y');title('X');
    Y = process_a(X,x_I_w_I(:,itr),dt);
%     figure(2)
%     surf(Y); xlabel('x');ylabel('y');title('Y');
    [x_ap, P_ap, W_prime] = Y_stats(Y,alpha_mu,alpha_cov,x_hatM(:,itr));% stats from Y. W_prime: Y with x_ap subtracted from each. W_prime in vector space
    
    %UPDATE
    Z = measurement_h(Y, x_G_w_I(:,itr+1),x_G_alpha_I(itr+1), x_GRI(:,itr+1));% measurement model h to get sigma points from Y
    
    [z_ap, P_zz] = Z_stats(Z,alpha_mu,alpha_cov);%, z_apM(:,itr));
    
    nu = z_a_IM(:,itr) - z_ap;
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
csvwrite('x_hat_from_mediumUKFmatlab.csv',x_hatM);


%% plot results IRJ and IPJ
eulers = 180/pi*quatern2euler(x_hatM(1:4)');

figure
subplot(3,1,1)
title('I R J');
plot(t,eulers(:,1));
subplot(3,1,2)
plot(t,eulers(:,2));
subplot(3,1,3)
plot(t,eulers(:,3));

figure
subplot(3,1,1)
title('I P J');
plot(t,x_hat(4,:));
subplot(3,1,2)
plot(t,x_hat(5,:));
subplot(3,1,3)
plot(t,x_hat(6,:));

%% plot results for x_hat (from baseline, don't use for medium UKF)

% %to use python results:
% %x_hatM = csvread('x_hat_from_UKFpython.csv');
% 
% % figure
% % surf(x_hatM,'edgecolor', 'None');
% % plot(t,x_hatM);
% 
% eulers = 180/pi*quatern2euler(x_hatM');
% 
% figure
% subplot(3,1,1)
% plot(t,eulers(:,1));
% subplot(3,1,2)
% plot(t,eulers(:,2));
% subplot(3,1,3)
% plot(t,eulers(:,3));
% 
% x_hat_python = csvread('x_hat_from_UKFpython.csv');
% x_hat_err = x_hat_python - x_hatM;
% figure; surf(x_hat_err)
% 
