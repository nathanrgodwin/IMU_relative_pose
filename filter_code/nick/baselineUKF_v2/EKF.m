function [x_hatM,fig] = EKF(data,t)


EKF_read_baseline_data;

init_state = [1 0 0 0]';
init_Sigma = eye(4)';

z = data(1:3,:);
gyro = data(4:6,:);
[~, len] = size(z);

x_hatM = zeros(4,len);
x_hatM(:,1) = init_state;

SigmaM = zeros(4,4,len);
SigmaM(:,:,1) = init_Sigma;

x_apM = zeros(4,len);

W = eye(3) * 0.001;
V = eye(3) * 0.01;

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
   z = EKF_h(x_t);

   x_hat = x_ap + K * (z - EKF_hh(x_ap));
   Sigma_hat = (eye(4) - K*H)*Sigma_ap;
   
   x_hatM(:,i+1) = x_hat;
   SigmaM(:,:,i+1) = Sigma_hat;
end

eulers = 180/pi*quatern2euler(x_hatM');

fig = figure;
subplot(3,1,1)
plot(t,eulers(:,1));
subplot(3,1,2)
plot(t,eulers(:,2));
subplot(3,1,3)
plot(t,eulers(:,3));

end
