clear all
close all

data = load('stationary_data.mat');

data = data.data;
t = data(:,1); 
acc = data(:,6:8);
gyro = data(:,9:11);
mag = data(:,12:14);

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
norms_acc =(gyro(:,1).^2 + gyro(:,2).^2 +gyro(:,3).^2).^.5;
norms_mag =(mag(:,1).^2 + mag(:,2).^2 +mag(:,3).^2).^.5;


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

norms_acc = (acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2).^.5;
norms_mag = (mag(:,1).^2 + mag(:,2).^2 + mag(:,3).^2).^.5;


figure 
subplot(2,1,1);
plot(norms_acc);
subplot(2,1,2);
plot(norms_mag);



