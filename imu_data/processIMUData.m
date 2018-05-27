%processIMUData
addpath('quaternion_library'); 

files  = dir('imu_*.csv');
n = length(files)/2;
for i = 1:n
    filename1 = files(i).name;
    filename2 = filename1;
    filename2(4) = num2str(2);
    disp(filename1)
    
    imu1 = csvread(filename1);
    imu2 = csvread(filename2);
    
     minSize = min(size(imu1,1),size(imu2,1));
%     
%     AHRS1 = MadgwickAHRS('SamplePeriod', 10e-3, 'Beta', 0.1);
%     AHRS2 = MadgwickAHRS('SamplePeriod', 10e-3, 'Beta', 0.1);
%     quaternion = zeros(min, 4);
%     for t = 1:min
%         AHRS1.Update(imu1(t,4:6) * (pi/180), Accelerometer(t,1:3), Magnetometer(t,7:9));
%         AHRS1.Update(Gyroscope(t,:) * (pi/180), Accelerometer(t,:), Magnetometer(t,:));	
%         quaternion(t, :) = AHRS.Quaternion;
%     end
    
    imu1(1:minSize,1:3) = imu1(1:minSize,1:3)/100;
    imu2(1:minSize,1:3) = imu2(1:minSize,1:3)/100;
    
    imu1(1:minSize,4:6) = deg2rad(imu1(1:minSize,4:6));
    imu2(1:minSize,4:6) = deg2rad(imu2(1:minSize,4:6));
    
    imu1(1:minSize,7:9) = deg2rad(imu1(1:minSize,7:9));
    imu2(1:minSize,7:9) = deg2rad(imu2(1:minSize,7:9));
    
    figure
    subplot(2,1,1)
    plot(imu1(:,3))
    subplot(2,1,2)
    plot(imu2(:,3))
    
    csvwrite(['unit_' filename1], imu1);
    csvwrite(['unit_' filename2], imu2);
    
    
end