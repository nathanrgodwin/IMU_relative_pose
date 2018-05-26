function [ v ] = state2vector( s )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%v = [s.GRI; s.IRJ; s.IPJ; s.GW ; s.GVI_0; s.GVI_1];
v = [s.GRI; s.IRJ; s.IPJ; s.GW ; s.GPCI];
end

