function [x_hatM, SigmaM] = EKF4_hard_bias(data,t,Win,Vin)
% EKF_read_baseline_data;

mean_a = [-0.0119; 0.1941; 9.7937];
mean_w = [0.0037; -0.0023; 0.0010];

%before (saturday)
% if nargin<4
%     W = eye(3) * 1e-4;
%     V = eye(3) * 1e0;
% else
%     W = Win;
%     V = Vin;
% end

if nargin<4
    %W = eye(3) * 1e-4; V = eye(3) * 1e0;
    W = eye(3) * 1e-8; 
    V = eye(3) * 1e3;
else
    W = Win;
    V = Vin;
end


if size(data,1) > 8
    data = data(1:6,:);
end

init_state = [1 0 0 0]';
init_Sigma = eye(4)';

meas = data(1:3,:) - mean_a;
meas(3,:)= meas(3,:) + 9.81;
gyro = data(4:6,:)- mean_w;
[~, len] = size(meas);

x_hatM = zeros(4,len);
x_hatM(:,1) = init_state;

SigmaM = zeros(4,4,len);
SigmaM(:,:,1) = init_Sigma;


for i = 1:len-1
    dt = t(i+1) - t(i);
    x_t = x_hatM(:,i);
    Sigma_tt = SigmaM(:,:,i);
    
    A = EKF_A(x_t);
    Q = EKF_Q(x_t, gyro(:,i)*dt);
    
    x_ap = EKF_aa(x_t, gyro(:,i)*dt);
    Sigma_ap = A * Sigma_tt * A' + Q*W*Q';
    
    H = EKF_H(x_ap);
    R = EKF_R;
    K = (Sigma_ap * H') / (H*Sigma_ap*H' + R*V*R');
    z = meas(:,i);
    
    x_hat = x_ap + K * (z - EKF_hh(x_ap));
    x_hat = x_hat./ norm(x_hat);
    Sigma_hat = (eye(4) - K*H)*Sigma_ap;
    
    x_hatM(:,i+1) = x_hat;
    SigmaM(:,:,i+1) = Sigma_hat;
end

% eulers = 180/pi*quatern2euler(x_hatM');
%
% fig = figure;
% subplot(3,1,1)
% plot(t,eulers(:,1));
% subplot(3,1,2)
% plot(t,eulers(:,2));
% subplot(3,1,3)
% plot(t,eulers(:,3));

end
