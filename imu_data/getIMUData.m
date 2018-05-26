delete(instrfindall)

readMag = 0;

s = serial('COM3');
set(s, 'BaudRate', 115200)
fopen(s);
if (readMag)
    scanString = '%f, %f, %f, %f, %f, %f, %f, %f, %f,\n';
else
    scanString = '%f, %f, %f, %f, %f, %f,\n';
end
%startTime = datetime;
min = input('Get sensing time: ');
imu1 = [];
imu2 = [];
for i = 1:100
    imu1 = [imu1;fscanf(s,scanString)'];
    imu2 = [imu2;fscanf(s,scanString)'];
end

fclose(s);