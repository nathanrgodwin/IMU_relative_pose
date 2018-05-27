function [ Y ] = state_quat2aa( X )
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here
Y = [quat2aa(X(1:4,:)); quat2aa(X(5:8,:)); X(9:end,:)];

end

