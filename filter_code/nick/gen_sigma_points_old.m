function [ X ] = gen_sigma_points_old(mu,covar)
%store each point as a column in X
%state is 23, including 2 quats. but their covar expressed in 3 each
%instead of 4 

[~,n] = size(covar); % 18 
n_dim = 3;
S = chol(covar,'lower')';

W_plus = zeros(n);
W_minus = zeros(n);

for i = 1:n
    W_plus(:,i) = sqrt(n)*S(:,i);
    W_minus(:,i) = sqrt(n)*S(:,i);
end 

%W contains 2n zero-centered sigma points
W = [W_plus, W_minus];

X = zeros(23, 2*n_dim+1);
X(:,1) = mu;

for i=1:(2*n)
    %convert first 3 els to quat, add mean to each point
    X(1:4,i+1) = w2q_exp(W(1:3,i));
    X(1:4,i+1) = q_mult(mu(1:4),X(1:4,i+1));
    %same for next quat
    X(5:8,i+1) = w2q_exp(W(4:6,i));
    X(5:8,i+1) = q_mult(mu(5:8),X(5:8,i+1));
    %add mean to other elements normally
    X(9:end,i+1) = mu(9:end) + W(9:end,i+1);
end 

end

