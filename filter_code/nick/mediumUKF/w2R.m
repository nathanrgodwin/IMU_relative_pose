function [R]  = w2R(w)

w_hat =  [0 -w(3) w(2);w(3) 0 -w(1); -w(2) w(1) 0]; 
theta = norm(w);

R = eye(3) + sin(theta)/theta*w_hat + (1 - cos(theta))/theta^2*w_hat^2;

end 