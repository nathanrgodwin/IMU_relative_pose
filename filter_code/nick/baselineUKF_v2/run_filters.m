clear all
close all

%reads data from 276a dataset as ax ay az wx wy wz as a wide matrix
data = csvread('data_imu_276a_dset1.csv');
t = csvread('t_imu_276a_dataset1.csv');
data(1:3,:) = data(1:3,:)*9.8; %

[xhat_1,f_1] = baselineUKF(data,t);

