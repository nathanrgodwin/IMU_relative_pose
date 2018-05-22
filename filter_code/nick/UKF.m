clear all
close all

n_steps

dt

g_quat %gravity vector

%estimates
x_hat
P_hat

% x t|t-1 . ap = 'a priori'
x_ap
P_ap

%measurements z
z

% expected measurement z at t 
z_ap
P_zz

%innovation nu = z - z_ap
nu
P_nu

P_xz % cross corr 
K % kalman gain

X %sigma points for x_hat
Y %sigma points for x_ap
Z %sigma points for z_ap

%noise covariances
Q 
R 

%weights for averaging 
alpha_mu
alpha_cov

for i = 1: n_steps
    %PREDICTION
    X = %generate sigma points from x_hat,P_hat, Q
    
    Y = %process model a(X)
    
    x_ap, P_ap, W_prime = % stats from Y. W_prime: Y with x_ap subtracted from each. W_prime in vector space
    
    %UPDATE
    Z = % measurement model h to get sigma points from Y
    
    z_ap, P_zz = %stats from Z
    
    nu = z - z_ap
    
    P_nu = P_zz + R
    
    P_xz = % stat from W_prime, Z
    
    K = P_xz*P_nu^-1 
    
    x_hat = 
    P_hat = 
    
end 
