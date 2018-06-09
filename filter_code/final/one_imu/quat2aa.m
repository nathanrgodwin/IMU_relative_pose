function [ aa ] = quat2aa( quat )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
quat = quat';

quat((sqrt(sum(quat.^2,2)))==0,1) = 1;

quat = quat ./ (sqrt(sum(quat.^2,2))*ones(1,4));  %normalize

aa = zeros(size(quat));
aa(:,4) = 2*atan2(sqrt(sum(quat(:,2:4).^2,2)),quat(:,1));
% aa(:,1:3) = quat(:,2:4)./(sin(aa(:,4)/2) * ones(1,3));
% 
% aa(:,1:3) = aa(:,1:3).*(aa(:,4) * ones(1,3));
% 
% aa(isnan(aa)) = 0;
% 
% aa = aa(:,1:3);

s = sqrt(1.-(quat(:,1).*quat(:,1)));
aa(:,1:3) = quat(:,2:4)./ s;

temp1 = aa(:,1:3);
temp2 = quat(:,2:4);

temp1(s<(10*realmin)*ones(1,3)) = temp2(s<(10*realmin)*ones(1,3));

aa(:,1:3) = temp1;
aa(:,1:3) = aa(:,1:3).*(aa(:,4) * ones(1,3));

aa = aa(:,1:3);

aa = aa';
end
