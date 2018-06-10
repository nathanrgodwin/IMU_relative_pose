%clear all
%close all


%% stationary

[t,GT,data,data_centered_1,data_centered_2,mean_a,mean_w,mean_b,var_a,var_w,var_b, cov_a,cov_w,cov_b, cov_ab] = inspect_stationary();
%b_vect is the same as mean_b
%% 
fig = figure;
[x_hat_i]=simple_integration(data,t,fig);
[x_hat] = UKF_4(data,t,fig);
[x_hat_mag] = UKF_4_mag(data,t,b_vect,fig);
title('raw')

fig_1 = figure;
[x_hat_i_1]=simple_integration(data_centered_1,t,fig_1);
[x_hat_1] = UKF_4(data_centered_1,t,fig_1);
[x_hat_mag_1] = UKF_4_mag(data_centered_1,t,b_vect,fig_1);
title('centered gyro');

fig_2 = figure;
[x_hat_i_2]=simple_integration(data_centered_2,t,fig_2);
[x_hat_2] = UKF_4(data_centered_2,t,fig_2);
[x_hat_mag_2] = UKF_4_mag(data_centered_2,t,b_vect,fig_2);

title('centered gyro and accel')


