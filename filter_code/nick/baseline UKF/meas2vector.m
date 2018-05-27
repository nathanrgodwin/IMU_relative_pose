function [ mv ] = meas2vector( ms )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
mv = [ms.AIm; ms.AJm; ms.IWI; ms.JWJ; ms.GRI; ms.GRJ];
end

