%processIMUData
addpath('quaternion_library'); 
close all

files  = dir('imu*.csv');
n = length(files)/2;
for i = 1:n
    filename1 = files(i).name;
    filename2 = filename1;
    filename2(4) = num2str(2);
    disp(filename1)
    
    imu1 = csvread(filename1);
    imu2 = csvread(filename2);
    
    minSize = min(size(imu1,1),size(imu2,1));
     
    imu1(:,1:3) = imu1(:,1:3)/100;
    imu2(:,1:3) = imu2(:,1:3)/100;
    
    imu1(:,4:6) = deg2rad(imu1(:,4:6));
    imu2(:,4:6) = deg2rad(imu2(:,4:6));
    
     
    AHRS1 = MadgwickAHRS('SamplePeriod', 10e-3, 'Beta', 0.1);
    AHRS2 = MadgwickAHRS('SamplePeriod', 10e-3, 'Beta', 0.1);
    quaternion1 = zeros(minSize, 4);
    quaternion2 = zeros(minSize, 4);
    for t = 1:minSize
        AHRS1.Update(imu1(t,4:6) * (pi/180), imu1(t,1:3)*100, imu1(t,7:9));
        AHRS2.Update(imu2(t,4:6) * (pi/180), imu2(t,1:3)*100, imu2(t,7:9));
        quaternion1(t, :) = AHRS1.Quaternion;
        quaternion2(t, :) = AHRS2.Quaternion;
    end
    imu1(:,7:9) = deg2rad(imu1(:,7:9));
    imu2(:,7:9) = deg2rad(imu2(:,7:9));
    
    euler1 = quatern2euler(quaternConj(quaternion1)) * (180/pi);	% use conjugate for sensor frame relative to Earth and convert to degrees.

    figure('Name', 'Euler Angles');
    hold on;
    plot(1:minSize, euler1(:,1), 'r');
    plot(1:minSize, euler1(:,2), 'g');
    plot(1:minSize, euler1(:,3), 'b');
    title('Euler angles');
    xlabel('Time (s)');
    ylabel('Angle (deg)');
    legend('\phi', '\theta', '\psi');
    hold off;
    
    euler2 = quatern2euler(quaternConj(quaternion2)) * (180/pi);	% use conjugate for sensor frame relative to Earth and convert to degrees.

    figure('Name', 'Euler Angles');
    hold on;
    plot(1:minSize, euler2(:,1), 'r');
    plot(1:minSize, euler2(:,2), 'g');
    plot(1:minSize, euler2(:,3), 'b');
    title('Euler angles');
    xlabel('Time (s)');
    ylabel('Angle (deg)');
    legend('\phi', '\theta', '\psi');
    hold off;
    
    csvwrite(['euler_' filename1], [imu1(1:minSize,:), quaternion1, euler1]);
    csvwrite(['euler_' filename2], [imu2(1:minSize,:), quaternion2, euler2]);
    
    
end