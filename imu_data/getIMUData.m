delete(instrfindall)
%addpath('quaternion_library');
clear variables
readMag = 1;
motion = 'updown'

s = serial('COM4');
set(s, 'BaudRate', 115200)
fopen(s);

NUM_IMU = 2

for i = 1:NUM_IMU
    disp(fscanf(s,'%s'))
    disp(fscanf(s,'%s'))
    pause(19)
    disp(fscanf(s,'%s'))
end
scanString = '%f, %f, %f, %f, %f, %f, %f, %f, %f\n';
%startTime = datetime;
minutes = input('Get sensing time: ');
Fs = 100;
imu1 = [];
imu2 = [];
starttime = datetime;
while(datetime < starttime+(minutes/(24*60)))
    imu1 = [imu1;fscanf(s,scanString)'];
    if (NUM_IMU == 2)
        imu2 = [imu2;fscanf(s,scanString)'];
    end
end
csvwrite(['imu1_data', datestr(now, 'DD_HH_MM') '_' motion '.csv'], imu1);
if (NUM_IMU == 2)
    csvwrite(['imu2_data', datestr(now, 'DD_HH_MM') '_' motion '.csv'], imu2);
end

fclose(s);

