function [ Z ] = measurement_h(Y, G_w,G_alpha,GRI)
%Points are in columns of Y and Z
temp = meas2vector(new_meas());

Z = zeros(length(temp), size(Y,2));
for i = 1:size(Y,2)
    Z(:,i) = measurement_model(Y(:,i),G_w,G_alpha,GRI);
end

end

