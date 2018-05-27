clear all
close all

sensor1 = csvread('sensor_data1_05_21_2018_16_43_aligned.csv');
sensor2 = csvread('sensor_data2_05_21_2018_16_43_aligned.csv');

%ignore magnet
sensor1(:,7:9) = [];
sensor2(:,7:9) = [];
lendata = min([sensor1(1,:) sensor2(1,:)]);
sensor1 = sensor1(2:lendata+1,:);
sensor2 = sensor2(2:lendata+1,:);

%orig: Ax Ay Az, wx wy wz, anglez angley anglex
dataI = [sensor1(:,1:6) fliplr(sensor1(:,7:9))];
dataJ = [sensor2(:,1:6) fliplr(sensor2(:,7:9))];

dataEuler = [dataI(:,1:3), dataJ(:,1:3),dataI(:,4:6),dataJ(:,4:6),dataI(:,7:9),dataJ(:,7:9)]';

%convert to axis angle
eulers1 = dataEuler(7:9,:);
aas1 = zeros(size(eulers1));
for i = 1:size(eulers1,2)
    aas1(:,i) = quat2aa(euler2quatern(eulers1(:,i)));
end 

eulers2 = dataEuler(10:12,:);
aas2 = zeros(size(eulers2));
for i = 1:size(eulers2,2)
    aas2(:,i) = quat2aa(euler2quatern(eulers2(:,i)));
end 

data = [dataEuler(1:12,:);aas1;aas2];
t = 0:(lendata-1);
dt = .01;
t = dt*t;

%% extract accel

wdata = data(7:12,:);
wdata1 = wdata(1:3,:);

figure;
plot(t,wdata1,'.-');
title('w');
figure;
plot(t(2:end),diff(wdata1,1,2)/dt,'.-');
title('a');

data1 = [data(1:3,:);data(7:9,:)];
