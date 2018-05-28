% -read_data_2 to get all meas
% -go to different folder, run baselineUKF
% -preprocess_medUKF to get G_w, G_a
% -mediumUKF

close all

%given B_w, x_hatM
GRI = x_hatM; %from baselineUKF
%outputs: G_w, G_alpha
%G_w, G_a time horizontal

B_w = data(4:6,:);
%xhatM has quats
Rots = quatern2rotMat(GRI');

G_w = zeros(size(B_w));
for i=1:size(G_w,2)
    G_w(:,i) = Rots(:,:,i)*B_w(:,i);
end 

%assume const dt ~.01 
dt = .01;
B_alpha = diff(B_w,1,2)/dt;

G_alpha = zeros(size(B_alpha));
for i=1:size(B_alpha,2)
    G_alpha(:,i) = Rots(:,:,i)*B_alpha(:,i);
end 

%% inspection
figure
subplot(3,1,1);
plot(t,G_w(1,:));
title('G_w');
subplot(3,1,2);
plot(t,G_w(2,:));
subplot(3,1,3);
plot(t,G_w(3,:));

figure
subplot(3,1,1);
plot(t(2:end),G_alpha(1,:));
title('G_alpha');
subplot(3,1,2);
plot(t(2:end),G_alpha(2,:));
subplot(3,1,3);
plot(t(2:end),G_alpha(3,:));

figure
subplot(2,1,1);
plot(t,G_w(1,:));
title('both');
subplot(2,1,2);
plot(t(2:end),G_alpha(1,:));

%% transform to global

figure
subplot(3,1,1);
plot(t,B_w(1,:));
title('B_w');
subplot(3,1,2);
plot(t,B_w(2,:));
subplot(3,1,3);
plot(t,B_w(3,:));

figure
subplot(3,1,1);
plot(t(2:end),B_alpha(1,:));
title('B_alpha');
subplot(3,1,2);
plot(t(2:end),B_alpha(2,:));
subplot(3,1,3);
plot(t(2:end),B_alpha(3,:));

figure
subplot(2,1,1);
plot(t,B_w(1,:));
title('both');
subplot(2,1,2);
plot(t(2:end),B_alpha(1,:));

%% LPF 

u = B_w(1,:);
b = firpm(10,[0 .1 .2 .99],[1 1 0 0]);
y = filter(b,1,u);
LPF = tf(b,1,.01);
figure
bode(LPF);

figure
subplot(2,1,1)
plot(u);
title('B_w ');
subplot(2,1,2)
plot(y);
