function [ q ] = aa2quat( aa )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
aa = aa';
x = aa(:,1);
y = aa(:,2);
z = aa(:,3);
if size(aa,2) == 3
    n = sqrt(x.^2 + y.^2 + z.^2);
    t = n;
    x = x./n;
    y = y./n;
    z = z./n;
else
    t = aa(:,4);
end

o = cos(t/2);
n = sqrt(x.^2 + y.^2 + z.^2);   %should be 1
i = x./n .* sin(t/2);
j = y./n .* sin(t/2);
k = z./n .* sin(t/2);
q = [o, i, j, k];
q = q';
end

