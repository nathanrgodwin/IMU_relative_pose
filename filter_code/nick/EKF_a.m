function [ A ] = EKF_A( state )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

q1 = state(1);
q2 = state(2);
q3  = state(3);
q4 = state(4);

A = ...
    [   q1  -q2 -q3 -q4;
        q2  q1  q4  -q3;
        q3  -q4 q1  q2;
        q4  q3  -q2 q1;];

end

