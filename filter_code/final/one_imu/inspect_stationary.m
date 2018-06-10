%output [t,vicon,data,data_centered_1,data_centered_2,mean_a,mean_w,mean_b,cov_a,cov_w,cov_b,cov_ab] 

data_all = csvread('../../../TStick/TStick_Test01_Static.csv', 2,0);
t = data_all(:,1); 
vicon = data_all(:,2:5);

%% useful stats 

mean_a = mean(data_all(:,6:8),1)'; cov_a = cov(data_all(:,6:8));
mean_w = mean(data_all(:,9:11),1)'; cov_w = cov(data_all(:,9:11));
mean_b = mean(data_all(:,12:14),1)'; cov_b = cov(data_all(:,12:14));
cov_ab = cov([data_all(:,6:8),data_all(:,12:14)]);

%% subtract biases in gyro
data_centered_1 = data_all;
data_centered_1(:,9:11) = data_all(:,9:11) - mean_w';

%% subtract possible bias in accel
data_centered_2 = data_centered_1;
data_centered_2(:,6:8) = data_all(:,6:8) - mean_a';
data_centered_2(:,8) = data_centered_2(:,8) + 9.81;

%% now ignore the time and quat
data = data_all(:,6:end)';
data_centered_1 = data_centered_1(:,6:end)';
data_centered_2 = data_centered_2(:,6:end)';

