clear all
close all

%as ax ay az wx wy wz as a wide matrix

data = csvread('data_imu_276a_dset1.csv');
t = csvread('t_imu_276a_dataset1.csv');
data(1:3,:) = data(1:3,:)*9.8; %

plotdata(t,data);
title('4D 276a data')

[xhat_1,f_1] = baselineUKF(data,t);
title('4D 276a data')
csvwrite('out_UKF_4D_276a_data.csv',xhat_1);
save('out_UKF_4D_276a_data.mat','xhat_1');

%% 
%check units, bias
dt = 1/75;
data = csvread('unit_imu2_data27_16_02_updown.csv')';
t = 0:(size(data,2)-1);
t = t*dt;

plotdata(t,data);
title('4D 1602 updown');

[xhat,f] = baselineUKF(data,t);
title('4D 1602 updown');
csvwrite('out_UKF_4D_1602_updown.csv',xhat_1);
save('out_UKF_4D_1602_updown.mat','xhat_1');



%% 
%check units, bias
dt = 1/75;
data = csvread('unit_imu2_data27_16_08_updown.csv')';
t = 0:(size(data,2)-1);
t = t*dt;

plotdata(t,data);
title('4D 1608 updown');
[xhat,f] = baselineUKF(data,t);
title('4D 1608 updown');
csvwrite('out_UKF_4D_1608_updown.csv',xhat_1);
save('out_UKF_4D_1608_updown.mat','xhat_1');

%% 
%check units, bias
dt = 1/75;
data = csvread('unit_imu2_data27_16_40_updown.csv')';
t = 0:(size(data,2)-1);
t = t*dt;

plotdata(t,data);
title('4D 1640 updown');
[xhat,f] = baselineUKF(data,t);
title('4D 1640 updown');
csvwrite('out_UKF_4D_1640_updown.csv',xhat_1);
save('out_UKF_4D_1640_updown.mat','xhat_1');


%% 
%check units, bias
dt = 1/75;
data = csvread('unit_imu2_data27_16_51_circle.csv')';
t = 0:(size(data,2)-1);
t = t*dt;

plotdata(t,data);
title('4D 1651 circle');
[xhat,f] = baselineUKF(data,t);
title('4D 1651 circle');
csvwrite('out_UKF_4D_1651_circle.csv',xhat_1);
save('out_UKF_4D_1651_circle.mat','xhat_1');





