function [ s ] = new_state()
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
s = struct();

s.GRI = zeros(1,4);
s.IRJ = zeros(1,4);
s.IPJ = zeros(1,3);
s.GW3 = zeros(1,3);
s.GVI_0 = zeros(1,3);
s.GVI_1 = zeros(1,3);

end

