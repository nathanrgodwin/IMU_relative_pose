function [ q ] = aa2quat(x, y, z, w )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
o = cos(w/2);
n = sqrt(x.^2 + y.^2 + z.^2);
i = x./n * sin(w/2);
j = y./n * sin(w/2);
k = z./n * sin(w/2);
q = [o, i, j, k];
end

