% -read_data_3 to get all meas
% -go to different folder, run baselineUKF
% -preprocess_medUKF to get G_w, G_a
% -mediumUKF

clear all
close all

% %reads data from 276a dataset as axayaz wxwywz as a wide matrix
% data = csvread('data_imu_276a_dset1.csv');
% t = csvread('t_imu_276a_dataset1.csv');
% %data(1:3,:) = data(1:3,:); %was used for unit conversion

%reads data from our own dataset

%for baselineUKF to use
dataJ = csvread('unit_imu1_data26_16_12.csv')'; %ax,ay,az,wx,wy,wz,mx my mz 
dataJ(1:3,:) = dataJ(1:3,:)/9.8;
data = csvread('unit_imu2_data26_16_12.csv')';
data(1:3,:) = data(1:3,:)/9.8;
t = 0:(size(data,2)-1);
dt = .01;
t = dt*t;

%remove apparent bias in omega
data(4:6,:)= data(4:6,:) - mean(data(4:6,:),2);
dataJ(4:6,:) = dataJ(4:6,:) - mean(dataJ(4:6,:),2);

%for mediumUKF to use
z_AIM = data(1:3,:);
z_AJM = dataJ(1:3,:);
x_Iw = data(4:6,:);
z_Jw = dataJ(4:6,:);



