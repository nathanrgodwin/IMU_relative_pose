figure(58);
%EKF circle
n_start = 1869;
n_end = 2319;
t_start = n_start/75;
t_end = n_end/75;

subplot(3,1,1);
ylabel('x (roll) ');
title('EKF: circles: Euler angles (degrees) vs time')
xlim([t_start t_end]);
ylim([-280 280]);
subplot(3,1,2);
ylabel('y (pitch)');
xlim([t_start t_end]);
subplot(3,1,3);
title('');
ylabel('z (yaw)');
xlim([t_start t_end]);
xlabel('time(sec)');

print('EKF circle','-dpng')

figure(57);
%ukf 7 circle
n_start = 1869;
n_end = 2319;
t_start = n_start/75;
t_end = n_end/75;

subplot(3,1,1);
ylabel('x (roll) ');
title('UKF 7D: circles: Euler angles (degrees) vs time')
xlim([t_start t_end]);
subplot(3,1,2);
ylabel('y (pitch)');
xlim([t_start t_end]);
subplot(3,1,3);
title('');
ylabel('z (yaw)');
xlim([t_start t_end]);
xlabel('time(sec)');

print('UKF circle','-dpng')

%% back to full size 

figure(58);
%EKF circle

subplot(3,1,1);
ylabel('x (roll) ');
title('EKF: circles: Euler angles (degrees) vs time')
xlim auto
ylim auto
%ylim([-280 280]);
subplot(3,1,2);
ylabel('y (pitch)');
xlim auto
ylim auto
subplot(3,1,3);
title('');
ylabel('z (yaw)');
xlim auto
ylim auto
xlabel('time(sec)');

print('EKF circle big','-dpng')

figure(57);
%ukf 7 circle
n_start = 1869;
n_end = 2319;
t_start = n_start/75;
t_end = n_end/75;

subplot(3,1,1);
ylabel('x (roll) ');
title('UKF 7D: circles: Euler angles (degrees) vs time')
xlim auto
ylim auto
subplot(3,1,2);
ylabel('y (pitch)');
xlim auto
ylim auto
subplot(3,1,3);
title('');
ylabel('z (yaw)');
xlim auto
ylim auto
xlabel('time(sec)');

print('UKF circle big ','-dpng')