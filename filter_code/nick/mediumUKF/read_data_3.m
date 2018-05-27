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
data = csvread(); %ax,ay,az,wx,wy,wz, a in gs 
t = 0:(len(data)-1);
dt = .01;
t = dt*t;

%for mediumUKF to use
z_AIM = data(1:3,:);
z_AJM = data(7:9,:);
z_Jw = data(10:12,:);
x_Iw = data(4:6,:);