clear all
close all

%reads data from 276a dataset as axayaz wxwywz as a wide matrix
data = csvread('data_imu_276a_dset1.csv');
t = csvread('t_imu_276a_dataset1.csv');
data(1:3,:) = data(1:3,:);

%reads data from our own dataset

