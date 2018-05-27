function [ Y ] = process_a(X,B_w)
%sigma_points X
%output sigma points Y
% 
% Y = zeros(size(X));
% for i = 1:size(X,2)
%     Y(:,i) = process(X(:,i));
% end
Y = zeros(size(X));
for i_sp=1:n_sigma_points
    Y(1:4,i_sp) = quatproduct(X(1:4,i_sp), aa2quat(B_w*dt));
    Y(5:7,i_sp) = X(5:7,i_sp);
end 

end

