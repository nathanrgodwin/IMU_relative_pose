%clear all
%close all


%% stationary

%[t,vicon,data,data_centered_1,data_centered_2,b_vect,mean_a,mean_w,mean_b] = inspect_stationary();

%% 
[x_hat,fig] = UKF_4(data,t);
figure(fig)
title('UKF4');
[x_hat_mag,fig] = UKF_4_mag(data,t,b_vect,fig);
title('raw')

[x_hat_1,fig] = UKF_4(data_centered_1,t);
figure(fig)
title('UKF4');
[x_hat_mag_1,fig] = UKF_4_mag(data_centered_1,t,b_vect,fig);
title('centered gyro')

[x_hat_2,fig] = UKF_4(data_centered_2,t);
figure(fig)
title('UKF4 no mag');
[x_hat_mag_1,fig] = UKF_4_mag(data_centered_2,t,b_vect,fig);
title('centered gyro and accel')

%% non-stationary


