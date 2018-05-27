close all
phone1 = csvread('sensor_data1_05_21_2018_16_07.csv');
phone2 = csvread('sensor_data2_05_21_2018_16_07.csv');

accel1 = phone1(2:phone1(1,3),3);
accel2 = phone2(2:phone2(1,3),3);

angvel1 = phone1(2:phone1(1,6),6);
angvel2 = phone2(2:phone2(1,6),6);

orient1 = phone1(2:phone1(1,12),12);
orient2 = phone2(2:phone2(1,12),12);

[acor_accel, lag_accel] = xcorr(accel2, accel1);
[acor_angvel, lag_angvel] = xcorr(angvel2, angvel1);
[acor_orient, lag_orient] = xcorr(orient2, orient1);

[~,I_accel] = max(abs(acor_accel));
[~,I_angvel] = max(abs(acor_angvel));
[~,I_orient] = max(abs(acor_orient));

lagDiff_accel = lag_accel(I_accel)
lagDiff_angvel = lag_angvel(I_angvel)
lagDiff_orient = lag_orient(I_orient)

phone2(1,1:3) = phone2(1,1:3)-lagDiff_accel;
phone2(2:end,1:3) = [phone2((2+lagDiff_accel):end,1:3); zeros(lagDiff_accel, 3)];
accel2 = phone2(2:phone2(1,3),3);
figure
plot(accel1)
hold on
plot(accel2)

phone1(1,4:6) = phone1(1,4:6)+lagDiff_angvel;
phone1(2:end,4:6) = [phone1((2-lagDiff_angvel):end,4:6); zeros(-lagDiff_angvel, 3)];
angvel1 = phone1(2:phone1(1,3),6);

figure
plot(angvel1)
hold on
plot(angvel2)

figure
plot(orient1)
hold on
plot(orient2)

csvwrite('sensor_data1_05_21_2018_16_43_aligned.csv', phone1)
csvwrite('sensor_data2_05_21_2018_16_43_aligned.csv', phone2)