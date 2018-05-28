EKF_read_baseline_data;

init_state = [1 0 0 0]';
init_Sigma = eye(4)';

dt = 1/100;

gyro = gyro(:,:)*dt;
z = accel(:,:);
[~, len] = size(z);

x_hatM = zeros(4,len+1);
x_hatM(:,1) = init_state;

SigmaM = zeros(4,4,len+1);
SigmaM(:,:,1) = init_Sigma;

x_apM = zeros(4,len+1);

W = eye(3) * 0.001;
V = eye(3) * 0.01;

for i = 1:len
   if i == 1
       x_t = init_state;
       Sigma_tt = init_Sigma;
   else
       x_t = x_hatM(:,i);
       Sigma_tt = SigmaM(:,:,i);
   end
    
   A = EKF_A(x_t);
   Q = EKF_Q(x_t, gyro(:,i));
   
   x_ap = EKF_a(x_t, gyro(:,i));
   Sigma_ap = A * Sigma_tt * A' + Q*W*Q';

   H = EKF_H(x_ap);
   R = EKF_R;
   K = (Sigma_ap * H') / (H*Sigma_ap*H' + R*V*R');
   z = EKF_h(x_t);

   x_hat = x_ap + K * (z - EKF_h(x_ap));
   Sigma_hat = (eye(4) - K*H)*Sigma_ap;
   
   x_hatM(:,i+1) = x_hat;
   SigmaM(:,:,i+1) = Sigma_hat;
end


readable_states = quatern2euler(x_hatM');
figure();
subplot(3,1,1)
plot(readable_states(:,1))
subplot(3,1,2)
plot(readable_states(:,2))
subplot(3,1,3)
plot(readable_states(:,3))