delete(instrfindall)
%addpath('quaternion_library');
close all
clear variablesf
readMag = 1;

s = serial('COM3');
set(s, 'BaudRate', 38400)
fopen(s);

for i = 1:2
    disp(fscanf(s,'%s'))
    disp(fscanf(s,'%s'))
    pause(19)
    disp(fscanf(s,'%s'))
end
scanString = '%f, %f, %f, %f, %f, %f, %f, %f, %f\n';
%startTime = datetime;
min = input('Get sensing time: ');
Fs = 100;
imu1 = [];
imu2 = [];
for i = 1:(Fs*min*60)
    imu1 = [imu1;fscanf(s,scanString)'];
    imu2 = [imu2;fscanf(s,scanString)'];
end
csvwrite(['imu1_data', datestr(now, 'DD_HH_MM') '.csv'], imu1);
csvwrite(['imu2_data', datestr(now, 'DD_HH_MM') '.csv'], imu2);

fclose(s);

