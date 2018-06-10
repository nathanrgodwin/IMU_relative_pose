function [ x_hatM, SigmaM ] = MADG( data,t,Win,Vin )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
x_hatM = Madgwick(data',t);
SigmaM = -eye(3);

end

