clear all
close all

%as ax ay az wx wy wz as a wide matrix

data = csvread('data_imu_276a_dset1.csv');
t = csvread('t_imu_276a_dataset1.csv');
data(1:3,:) = data(1:3,:)*9.8; %

[xhat_1,f_1] = baselineUKF(data,t);
csvwrite('out_UKF_4D_276a_data.csv',xhat_1);
save('out_UKF_4D_276a_data.mat','xhat_1');

%

[xhat_2,f_2] = baseline7UKF(data,t);

[xhat_3,f_3] = EKF(data,t);