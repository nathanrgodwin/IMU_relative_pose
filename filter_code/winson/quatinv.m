function [ output_args ] = quatinv( q )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    output_args = [q(:,1) -q(:,2) -q(:,3) -q(:,4)];
end

