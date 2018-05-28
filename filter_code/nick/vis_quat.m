function [  ] = vis_quat( X )
%UNTITLED25 Summary of this function goes here
%   Detailed explanation goes here

[~, len] = size(X);

start_point = [0 0.9 0 0]';
end_point = [0 1.1 0 0]';

GRI = X;

trans_start_point = unquat(quatproduct(GRI, quatproduct(start_point * ones(1,len), quatinv(GRI))));
trans_end_point = unquat(quatproduct(GRI, quatproduct(end_point * ones(1,len), quatinv(GRI))));

figure(); hold on;
title('quat')
plot3(trans_start_point(1,1),trans_start_point(2,1),trans_start_point(3,1), '*')
plot3(trans_end_point(1,1),trans_end_point(2,1),trans_end_point(3,1), '*')
plot3(trans_start_point(1,:),trans_start_point(2,:),trans_start_point(3,:), '-o')
plot3(trans_end_point(1,:),trans_end_point(2,:),trans_end_point(3,:), '-o')
xlabel('x');ylabel('y');


end

