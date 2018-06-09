function [x_hatM,P_hatM] = Integration(data,t,Q,R)

w = data(4:6,:);
x_hatM = zeros(4,size(data,2));
x_hatM(:,1) = [1;0;0;0];

for i = 1:(size(data,2)-1)
    dt = t(i+1) - t(i);
    x_hatM(:,i+1) = quatproduct(x_hatM(:,i),aa2quat(w(:,i)*dt));
end 

P_hatM = -eye(3);
%% 
% eulers = 180/pi*quatern2euler(x_hatM');
% 
% figure(fig)
% subplot(3,1,1)
% plot(t,eulers(:,1));
% hold on
% subplot(3,1,2)
% plot(t,eulers(:,2));
% hold on
% subplot(3,1,3)
% plot(t,eulers(:,3));
% hold on

end 