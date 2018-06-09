function [ H ] = EKF_H( state )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

% H = zeros(3,4);
g=-9.8;

q1 = state(1);
q2 = state(2);
q3 = state(3);
q4 = state(4);

H = 2*g* ...
[   q3  -q4 q1  -q2;
    -q2 -q1 -q4 -q3;
    q1  q2  q3  q4];

end

