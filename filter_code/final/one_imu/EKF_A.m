function [ A ] = EKF_A( omega )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

q = aa2quat(omega);

q1 = q(1);
q2 = q(2);
q3  = q(3);
q4 = q(4);

A = ...
    [   q1  -q2 -q3 -q4;
        q2  q1  q4  -q3;
        q3  -q4 q1  q2;
        q4  q3  -q2 q1;];

    
end

