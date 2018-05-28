function [dout]=Madgwick(din,t)
    addpath('quaternion_library');
    AHRS = MadgwickAHRS('SamplePeriod', 1/75, 'Beta', 0.1);

    quaternion = zeros(length(t), 4);
    for i = 1:length(t)
        AHRS1.Update(din(i,4:6) * (pi/180), din(i,1:3)*100, din(i,7:9)/1000);
        quaternion(i, :) = AHRS.Quaternion;
    end
    dout = quaternion';
end