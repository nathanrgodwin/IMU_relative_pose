function [t,vicon,data,data_centered_1,data_centered_2,mean_a,mean_w,b_vect,var_a,var_w,var_b,cov_a,cov_w,cov_b,cov_ab] = inspect_stationary() 

%plots each meas signal

set(0,'DefaultFigureWindowStyle','docked')

data_all = csvread('TStick_Test01_Static.csv', 2,0);

t = data_all(:,1); 
vicon = data_all(:,2:5);

%% plotting 

acc = data_all(:,6:8);
cov_a = cov(acc);
gyro = data_all(:,9:11);
cov_w = cov(gyro);
mag = data_all(:,12:14);
cov_b = cov(mag);
cov_ab = cov([acc,mag]);

figure;
subplot(3,1,1);
plot(acc(:,1));
title(['accel, mean = ' num2str(mean(acc(:,1))) ' std = ' num2str(std(acc(:,1)))]);
subplot(3,1,2)
plot(acc(:,2));
title(['mean = ' num2str(mean(acc(:,2))) ' std = ' num2str(std(acc(:,2)))]);
subplot(3,1,3)
plot(acc(:,3));
title(['mean = ' num2str(mean(acc(:,3))) ' std = ' num2str(std(acc(:,3)))]);

figure;
subplot(3,1,1);
plot(gyro(:,1));
title(['gyro, mean = ' num2str(mean(gyro(:,1))) ' std = ' num2str(std(gyro(:,1)))]);
subplot(3,1,2)
plot(gyro(:,2));
title(['mean = ' num2str(mean(gyro(:,2))) ' std = ' num2str(std(gyro(:,2)))]);
subplot(3,1,3)
plot(gyro(:,3));
title(['mean = ' num2str(mean(gyro(:,3))) ' std = ' num2str(std(gyro(:,3)))]);

figure;
subplot(3,1,1);
plot(mag(:,1));
title(['mag, mean = ' num2str(mean(mag(:,1))) ' std = ' num2str(std(mag(:,1)))]);
subplot(3,1,2)
plot(mag(:,2));
title(['mean = ' num2str(mean(mag(:,2))) ' std = ' num2str(std(mag(:,2)))]);
subplot(3,1,3)
plot(mag(:,3));
title(['mean = ' num2str(mean(mag(:,3))) ' std = ' num2str(std(mag(:,3)))]);

%% norms 
norms_acc = (acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2).^.5;
norms_gyro = (gyro(:,1).^2 + gyro(:,2).^2 + gyro(:,3).^2).^.5;
norms_mag = (mag(:,1).^2 + mag(:,2).^2 + mag(:,3).^2).^.5;

figure 
subplot(3,1,1);
plot(norms_acc);
title('norms, acc')
subplot(3,1,2);
plot(norms_gyro);
title('norms, gyro')
subplot(3,1,3);
plot(norms_mag);
title('norms, mag')

%% subtract biases in gyro
data_centered_1 = data_all;

mean_w = mean(data_all(:,9:11,1))';
data_centered_1(:,9:11) = data_all(:,9:11) - mean_w';
var_w = std(data_centered_1(:,9:11),0,1)';
%% subtract possible bias in accel
data_centered_2 = data_centered_1;

mean_a = mean(data_all(:,6:8),1)';

data_centered_2(:,6:8) = data_all(:,6:8) - mean_a';
data_centered_2(:,8) = data_centered_2(:,8) + 9.81;

var_a = std(data_centered_2(:,6:8),0,1)';

%% now ignore the time and quat
data = data_all(:,6:end)';
data_centered_1 = data_centered_1(:,6:end)';
data_centered_2 = data_centered_2(:,6:end)';

%% take avg value of mag to be the expected value 
b_vect = mean(data_all(:,12:14),1)';
var_b =  std(data_all(:,12:14),0,1)';
