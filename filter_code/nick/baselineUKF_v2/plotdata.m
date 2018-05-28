function [fig1,fig2] = plotdata(t,data) %time goes horiz

fig1 = figure;
subplot(3,1,1);
plot(t,data(1,:))
title('accel');
subplot(3,1,2);
plot(t,data(2,:))
subplot(3,1,3);
plot(t,data(3,:))

fig2 = figure;
subplot(3,1,1);
plot(t,data(4,:))
title('ang vel');
subplot(3,1,2);
plot(t,data(5,:))
subplot(3,1,3);
plot(t,data(6,:))

end 