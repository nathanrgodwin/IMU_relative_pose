function [ Q ] = EKF_Q( state, omega )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
Q = zeros(4,3);
w1 = omega(1);
w2 = omega(2);
w3 = omega(3);
wn = norm(omega);

Q(1,1) = -w1*sin(wn/2)/(2*wn);
Q(1,2) = -w2*sin(wn/2)/(2*wn);
Q(1,3) = -w3*sin(wn/2)/(2*wn);

Q(2,1) = sin(wn/2) + w1*w1*cos(wn/2)/(2*wn);
Q(2,2) = w1*w2*cos(wn/2)/(2*wn);
Q(2,3) = w1*w3*cos(wn/2)/(2*wn);

Q(3,1) = w2*w1*cos(wn/2)/(2*wn);
Q(3,2) = sin(wn/2) + w2*w2*cos(wn/2)/(2*wn);
Q(3,3) = w2*w3*cos(wn/2)/(2*wn);

Q(4,1) = w3*w1*cos(wn/2)/(2*wn);
Q(4,2) = w3*w2*cos(wn/2)/(2*wn);
Q(4,3) = sin(wn/2) + w3*w3*cos(wn/2)/(2*wn);



end

