function [ X ] = sigma_points(mu,covar)
%store each point as a column in X

[~,n] = size(covar);

S = chol(covar,'lower')';

W_plus = zeros(n);
W_minus = zeros(n);

for i = 1:n
    W_plus(:,i) = sqrt(n)*S(:,i);
    W_minus(:,i) = sqrt(n)*S(:,i);
end 

W = [W_plus, W_minus];

X = zeros(n+1, 2*n+1);
X(:,1) = mu;

for i=1:(2*n)
    X(:,i+1) = w2q_exp(W(:,i));
    X(:,i+1) = q_mult(mu,X(:,i+1));
end 

end

