function [ s ] = new_state()
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
s = struct();

s.GRI   = zeros(4,1);
s.IRJ   = zeros(4,1);
s.IPJ   = zeros(3,1);
s.GW    = zeros(3,1);
s.GVI_0 = zeros(3,1);
s.GVI_1 = zeros(3,1);

end

