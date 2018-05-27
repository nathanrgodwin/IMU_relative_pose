% -read_data_2 to get all meas
% -go to different folder, run baselineUKF
% -preprocess_medUKF to get G_w, G_a
% -mediumUKF

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
% figure
% title('B_w');
% plot(t,B_w);
% 
% subplot(3,1,1);
% plot(t,B_w(1,:));
% subplot(3,1,2);
% plot(t,B_w(2,:));
% subplot(3,1,3);
% plot(t,B_w(3,:));
% 
% figure
% title('B_a');
% plot(t(2:end),B_a);
% 
% subplot(3,1,1);
% plot(t(2:end),B_a(1,:));
% subplot(3,1,2);
% plot(t(2:end),B_a(2,:));
% subplot(3,1,3);
% plot(t(2:end),B_a(3,:));
% 
% figure
% title('both');
% subplot(2,1,1);
% plot(t,B_w(1,:));
% subplot(2,1,2);
% plot(t(2:end),B_a(1,:));

%% transform to global



