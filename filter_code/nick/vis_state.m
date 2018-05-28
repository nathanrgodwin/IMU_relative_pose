function [ ] = vis_state( sv )
%UNTITLED22 Summary of this function goes here
%   Detailed explanation goes here

[~, len] = size(sv);
% 
% start_point = [0 0.9 0 0]';
% end_point = [0 1.1 0 0]';
% 
% GRI = sv(1:4,:);
% 
% trans_start_point = unquat(quatproduct(GRI, quatproduct(start_point * ones(1,len), quatinv(GRI))));
% trans_end_point = unquat(quatproduct(GRI, quatproduct(end_point * ones(1,len), quatinv(GRI))));
% 
% figure(); hold on;
% title('orientation')
% plot3(trans_start_point(1,1),trans_start_point(2,1),trans_start_point(3,1), '*')
% plot3(trans_end_point(1,1),trans_end_point(2,1),trans_end_point(3,1), '*')
% plot3(trans_start_point(1,:),trans_start_point(2,:),trans_start_point(3,:), '-o')
% plot3(trans_end_point(1,:),trans_end_point(2,:),trans_end_point(3,:), '-o')
% xlabel('x');ylabel('y');

vis_quat(sv(1:4,:));
title('orientation');

figure;
plot3(sv(9,:),sv(10,:),sv(11,:), 'o')
title('position')
xlabel('x');ylabel('y');

vis_quat(sv(1:4,:));

plot3([sv(12,1); 0], [sv(13,1); 0], [sv(14,1); 0], 'k');
plot3(sv(12,:), sv(13,:), sv(14,:), 'k-o');
title('angular accel')
xlabel('x');ylabel('y');

end

