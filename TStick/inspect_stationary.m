function [t,vicon,data,data_centered_1,data_centered_2,mg_quat] = inspect_stationary() 

set(0,'DefaultFigureWindowStyle','docked')

data_all = csvread('TStick_Test01_Static.csv', 2,0);

t = data_all(:,1); 
vicon = data_all(:,2:5);
acc = data_all(:,6:8);
gyro = data_all(:,9:11);
mag = data_all(:,12:14);

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
data_centered_1(:,9) = data_all(:,6) - mean(data_all(:,6));
data_centered_1(:,10) = data_all(:,6) - mean(data_all(:,6));
data_centered_1(:,11) = data_all(:,6) - mean(data_all(:,6));

%% subtract possible bias in accel
data_centered_2 = data_centered_1;
data_centered_2(:,6) = data_all(:,6) - mean(data_all(:,6));
data_centered_2(:,7) = data_all(:,7) - mean(data_all(:,7));
data_centered_2(:,8) = data_all(:,8) - (mean(data_all(:,8))-9.81);

data = data_all(:,6:end)';
data_centered_1 = data_centered_1(:,6:end)';
data_centered_2 = data_centered_2(:,6:end)';

%% take avg value of mag to be the expected value 
mg_quat = [0, mean(data_all(:,12:14),1)]';
