clear all
close all

q = [0 0.0871557 0 .99619]';

w = q2w(q);
R = w2R(w);

%R = eye(3);

p = [2 1 1]';
G = [R, p; 0 0 0 1];

axis_len = 1;
q0 = axis_len*eye(3);
p0 = zeros(3);

%initialize
q1 = zeros(3);
p1 = zeros(3);

for i= 1:3
    q1_temp = G*[q0(:,i);1];
    q1(:,i) = q1_temp(1:3);
    p1_temp = G*[p0(:,i);1];
    p1(:,i) = p1_temp(1:3);
end 

figure
%plot old axis
plot3([p0(1,1) q0(1,1)],[p0(2,1) q0(2,1)],[p0(3,1) q0(3,1)],'-r');
hold on 
plot3([p0(1,2) q0(1,2)],[p0(2,2) q0(2,2)],[p0(3,2) q0(3,2)],'-g'); 
plot3([p0(1,3) q0(1,3)],[p0(2,3) q0(2,3)],[p0(3,3) q0(3,3)],'-b');

%plot new axis
plot3([p1(1,1) q1(1,1)],[p1(2,1) q1(2,1)],[p1(3,1) q1(3,1)],':r');
hold on 
plot3([p1(1,2) q1(1,2)],[p1(2,2) q1(2,2)],[p1(3,2) q1(3,2)],':g'); 
plot3([p1(1,3) q1(1,3)],[p1(2,3) q1(2,3)],[p1(3,3) q1(3,3)],':b');


