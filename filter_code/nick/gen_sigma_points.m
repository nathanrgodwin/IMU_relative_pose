function [ X ] = gen_sigma_points(mu,covar)
%store each point as a column in X
%state is 23, including 2 quats. but their covar expressed in 3 each
%instead of 4 

[~,n_dim] = size(covar); % 18 
S = chol(covar,'lower')';

W_plus = zeros(n_dim);
W_minus = zeros(n_dim);

for i = 1:n_dim
    W_plus(:,i) = sqrt(n_dim)*S(:,i);
    W_minus(:,i) = sqrt(n_dim)*S(:,i);
end 

%W contains 2n zero-centered sigma points
W = [W_plus, W_minus];

X = zeros(20, 2*n_dim+1);
X(:,1) = mu;

for i=1:(2*n_dim)
    %convert first 3 els to quat, add mean to each point
    X(1:4,i+1) = aa2quat(W(1:3,i));
    X(1:4,i+1) = quatproduct(mu(1:4),X(1:4,i+1));
    %same for next quat
    X(5:8,i+1) = aa2quat(W(4:6,i));
    X(5:8,i+1) = quatproduct(mu(5:8),X(5:8,i+1));
    %add mean to other elements normally
    X(9:end,i+1) = mu(9:end) + W(7:end,i);
end 

end

