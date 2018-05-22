function [ new_s ] = process( s )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
dt = 1;
new_s.GRI   = quatproduct(euler2quatern(dt*s.GW), s.GRI);
new_s.IRJ   = s.IRJ;
new_s.GW    = s.GW;
new_s.GVI_0 = s.GW;

end

