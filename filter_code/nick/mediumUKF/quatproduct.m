function [ q ] = quatproduct( n1, n2 )
%UNTITLED6 Summary of this function goes here
%   each row is a quaternion
n1 = n1';
n2 = n2';

a1 = n1(:,1);
b1 = n1(:,2);
c1 = n1(:,3);
d1 = n1(:,4);

a2 = n2(:,1);
b2 = n2(:,2);
c2 = n2(:,3);
d2 = n2(:,4);

o = (a1.*a2 - b1.*b2 - c1.*c2 - d1.*d2);
i = (a1.*b2 + b1.*a2 + c1.*d2 - d1.*c2);
j = (a1.*c2 - b1.*d2 + c1.*a2 + d1.*b2);
k = (a1.*d2 + b1.*c2 - c1.*b2 + d1.*a2);

q = [o, i, j, k];
q = q';
end

