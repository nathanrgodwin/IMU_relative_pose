function [ Y ] = process_a( X )
%sigma_points X
%output sigma points Y
Y = zeros(size(X));
for i = 1:size(X,2)
    Y(:,i) = process(X(:,i));
end

end

