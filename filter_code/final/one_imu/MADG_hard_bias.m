function [ x_hatM, SigmaM ] = MADG_hard_bias( data,t,Win,Vin )

mean_a = [-0.0119; 0.1941; 9.7937];
mean_w = [0.0037; -0.0023; 0.0010];

data_new = data;
data_new(1:3,:) = data(1:3,:) - mean_a;
data_new(3,:) = data_new(3,:) + 9.81;
data_new(4:6,:) = data_new(4:6,:) - mean_w; 

x_hatM = Madgwick(data_new',t);
SigmaM = -eye(3);

end

