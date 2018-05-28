data_temp = csvread('data_imu_276a_dset1.csv');

accel = data_temp(1:3,:);
gyro = data_temp(4:6,:);