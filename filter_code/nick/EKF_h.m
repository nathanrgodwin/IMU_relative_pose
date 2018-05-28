function [ z ] = EKF_h( state )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

g = 9.8;

% z = zeros(3,1);
% 
% q1 = state(1);
% q2 = state(2);
% q3 = state(3);
% q4 = state(4);
% 
% z(1) = -2*q4*q2*g -2*q3*q1*g;
% z(2) = -2*q4*q3*g +2*q2*q1*g;
% z(3) = g * (-q4^2 + q3^2 + q2^2 - q1^2);

z = quatproduct(quatproduct(quatinv(state), [0 0 0 -g]'), state);
z = z(2:4);
end

