function [ z ] = EKF_hh( state, mag )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

g = -9.8;

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
if nargin >1
%     b = [...
%         -0.026163936432742;
%         0.400463492343292;
%         -0.901099835848857];
%     b  = -[...
%   -0.335330000000000;
%    0.198560000000000;
%   -0.887080000000000];
b = mag;
    zm = quatproduct(quatproduct(quatinv(state), [0; b]), state);
    z = [z;zm(2:4)];
end
end

