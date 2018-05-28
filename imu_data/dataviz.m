close all
clear variables
addpath('quaternion_library'); 

file = csvread("C:/Users/Nathan/Documents/IMU_relative_pose/filter_code/nick/baselineUKF_v2/out_UKF_7D_1651_circle.csv");
filename = 'circle_ukf_1651';

n = 2000;
fig = figure;
linestart = [0;0;0];
quat = file(1:4,:)';
lineendx = quaternProd(quat,quaternProd([0,1,0,0],quaternConj(quat)));
lineendy = quaternProd(quat,quaternProd([0,0,1,0],quaternConj(quat)));
lineendz = quaternProd(quat,quaternProd([0,0,0,1],quaternConj(quat)));

frames(n) = struct('cdata',[],'colormap',[]);
v = VideoWriter([filename '.avi']);
v.FrameRate= 75;
open(v);
for i = 1:n
    line = [linestart, lineendz(i, 2:end)'];
    plot3(line(1,1:2), line(2,1:2), line(3,1:2), 'b', 'LineWidth', 3)
    %pos = ['(' num2str(line(1,2), '%0.2f') ', ' num2str(line(2,2), '%0.2f') ', ' num2str(line(3,2), '%0.2f') ')'];
    pos = 'Z';
    text(line(1,2),line(2,2),line(3,2),pos);
    hold on
    
    line = [linestart, lineendx(i, 2:end)'];
    plot3(line(1,1:2), line(2,1:2), line(3,1:2), 'r', 'LineWidth', 3)
    %pos = ['(' num2str(line(1,2), '%0.2f') ', ' num2str(line(2,2), '%0.2f') ', ' num2str(line(3,2), '%0.2f') ')'];
    pos = 'X';
    text(line(1,2),line(2,2),line(3,2),pos);
    
    line = [linestart, lineendy(i, 2:end)'];
    plot3(line(1,1:2), line(2,1:2), line(3,1:2), 'g', 'LineWidth', 3)
    %pos = ['(' num2str(line(1,2), '%0.2f') ', ' num2str(line(2,2), '%0.2f') ', ' num2str(line(3,2), '%0.2f') ')'];
    pos = 'Y';
    text(line(1,2),line(2,2),line(3,2),pos);
    
    grid on
    xlim([-1 1]);
    ylim([-1 1]);
    zlim([-1 1]);
    title('UKF Circle #1651')
    drawnow
    hold off
    frames(i) = getframe(fig);
    writeVideo(v,frames(i));
end
close(v)
movie(fig,frames,1,75);