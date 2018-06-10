function [ R ] = EKF_R( state, mag )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

R = eye(3);

if nargin >1
R = eye(6);
end
end

