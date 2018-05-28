clear all
%close all


%% 276a
%as ax ay az wx wy wz as a wide matrix

data = csvread('data_imu_276a_dset1.csv');
t = csvread('t_imu_276a_dataset1.csv');
data = [data;zeros(3,size(data,2))];
data(1:3,:) = data(1:3,:)*9.8; %

plotdata(t,data);
title('4D 276a data')

[xhat_1,f_1] = baselineUKF(data,t);
title('4D 276a data')
csvwrite('out_UKF_4D_276a_data.csv',xhat_1);
save('out_UKF_4D_276a_data.mat','xhat_1');

[xhat_2,f_2] = baseline7UKF(data,t);
title('7D 276a data')
csvwrite('out_UKF_7D_276a_data.csv',xhat_2);
save('out_UKF_7D_276a_data.mat','xhat_2');

[xhat_3,f_3] = EKF(data,t);
title('EKF 276a data')
csvwrite('out_EKF_276a_data.csv',xhat_3);
save('out_EKF_276a_data.mat','xhat_3');

[xhat_4] = Madgwick(data',t);
title('Madgwick 276a data')
csvwrite('out_Madg_276a_data.csv',xhat_4);
save('out_Madg_276a_data.mat','xhat_4');

%% 1602 updown
%check units, bias
dt = 1/75;
data = csvread('unit_imu2_data27_16_02_updown.csv')';
t = 0:(size(data,2)-1);
t = t*dt;

plotdata(t,data);
title('4D 1602 updown');

[xhat_1,f] = baselineUKF(data,t);
title('4D 1602 updown');
csvwrite('out_UKF_4D_1602_updown.csv',xhat_1);
save('out_UKF_4D_1602_updown.mat','xhat_1');

[xhat_2,f_2] = baseline7UKF(data,t);
title('7D 1602 updown')
csvwrite('out_UKF_7D_1602_updown.csv',xhat_2);
save('out_UKF_7D_1602_updown.mat','xhat_2');

[xhat_3,f_3] = EKF(data,t);
title('EKF 1602 updown')
csvwrite('out_EKF_1602_updown.csv',xhat_3);
save('out_EKF_1602_updown.mat','xhat_3');

[xhat_4] = Madgwick(data',t);
title('Madgwick 1602 updown')
csvwrite('out_Madg_1602_updown.csv',xhat_4);
save('out_Madg_1602_updown.mat','xhat_4');


%% 1608 updown
%check units, bias
dt = 1/75;
data = csvread('unit_imu2_data27_16_08_updown.csv')';
t = 0:(size(data,2)-1);
t = t*dt;

plotdata(t,data);
title('4D 1608 updown');
[xhat_1,f] = baselineUKF(data,t);
title('4D 1608 updown');
csvwrite('out_UKF_4D_1608_updown.csv',xhat_1);
save('out_UKF_4D_1608_updown.mat','xhat_1');

[xhat_2,f_2] = baseline7UKF(data,t);
title('7D 1608 updown')
csvwrite('out_UKF_7D_1608_updown.csv',xhat_2);
save('out_UKF_7D_1608_updown.mat','xhat_2');

[xhat_3,f_3] = EKF(data,t);
title('EKF 1608 updown')
csvwrite('out_EKF_1608_updown.csv',xhat_3);
save('out_EKF_1608_updown.mat','xhat_3');

[xhat_4] = Madgwick(data',t);
title('Madgwick 1608 updown')
csvwrite('out_Madg_1608_updown.csv',xhat_4);
save('out_Madg_1608_updown.mat','xhat_4');

%% 1640 updown
%check units, bias
dt = 1/75;
data = csvread('unit_imu2_data27_16_40_updown.csv')';
t = 0:(size(data,2)-1);
t = t*dt;

plotdata(t,data);
title('4D 1640 updown');
[xhat_1,f] = baselineUKF(data,t);
title('4D 1640 updown');
csvwrite('out_UKF_4D_1640_updown.csv',xhat_1);
save('out_UKF_4D_1640_updown.mat','xhat_1');

[xhat_2,f_2] = baseline7UKF(data,t);
title('7D 1640 updown')
csvwrite('out_UKF_7D_1640_updown.csv',xhat_2);
save('out_UKF_7D_1640_updown.mat','xhat_2');

[xhat_3,f_3] = EKF(data,t);
title('EKF 1640 updown')
csvwrite('out_EKF_1640_updown.csv',xhat_3);
save('out_EKF_1640_updown.mat','xhat_3');

[xhat_4] = Madgwick(data',t);
title('Madgwick 1640 updown')
csvwrite('out_Madg_1640_updown.csv',xhat_4);
save('out_Madg_1640_updown.mat','xhat_4');

%% 1651 circle
%check units, bias
dt = 1/75;
data = csvread('unit_imu2_data27_16_51_circle.csv')';
t = 0:(size(data,2)-1);
t = t*dt;

plotdata(t,data);
title('4D 1651 circle');
[xhat_1,f] = baselineUKF(data,t);
title('4D 1651 circle');
csvwrite('out_UKF_4D_1651_circle.csv',xhat_1);
save('out_UKF_4D_1651_circle.mat','xhat_1');

[xhat_2,f_2] = baseline7UKF(data,t);
title('7D 1651 circle')
csvwrite('out_UKF_7D_1651_circle.csv',xhat_2);
save('out_UKF_7D_1651_circle.mat','xhat_2');

[xhat_3,f_3] = EKF(data,t);
title('EKF 1651 circle')
csvwrite('out_EKF_1651_circle.csv',xhat_3);
save('out_EKF_1651_circle.mat','xhat_3');

[xhat_4] = Madgwick(data',t);
title('Madgwick 1651 circle')
csvwrite('out_Madg_1651_circle.csv',xhat_4);
save('out_Madg_1651_circle.mat','xhat_4');
