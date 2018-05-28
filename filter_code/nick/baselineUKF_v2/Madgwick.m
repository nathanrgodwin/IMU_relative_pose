function [dout,fig]=Madgwick(din,t)
    addpath('quaternion_library');
    AHRS = MadgwickAHRS('SamplePeriod', 1/75, 'Beta', 0.1);

    quaternion = zeros(length(t), 4);
    for i = 1:length(t)
        AHRS.Update(din(i,4:6), din(i,1:3), din(i,7:9)/1000);
        quaternion(i, :) = AHRS.Quaternion;
    end
    dout = quaternion';
    
    eulers = 180/pi*quatern2euler(dout');

    fig = figure;
    subplot(3,1,1)
    plot(t,eulers(:,1));
    subplot(3,1,2)
    plot(t,eulers(:,2));
    subplot(3,1,3)
    plot(t,eulers(:,3));
end