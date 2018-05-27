function [ mu,covar,diffs ] = vect_stats( X,alpha_mu,alpha_cov)
% X column of arbitrary data
[n,n_vects] = size(X);
mu = alpha_mu*X(:,1) + sum(X(:,2:end),2)/(n_vects-1);

diffs = zeros(n,n_vects);
covar = zeros(n);
for i=2:n_vects
    diffs(:,i) = X(:,i) - mu;
    A = diffs(:,i); %change from diffs to diffs(:,i)
    covar = covar + A*A';
end 
covar = covar/(n_vects-1);
A = (X(:,1) - mu);
covar = covar + alpha_cov*(A*A');

end

% %version 2 --wq
% function [ mu,covar,diffs ] = vect_stats( X,alpha_mu,alpha_cov)
% % X column of arbitrary data
% [n,n_vects] = size(X);
% mu =  sum(X(:,2:end),2)/(n_vects-1);
% 
% diffs = zeros(n,n_vects);
% covar = zeros(n);
% for i=2:n_vects
%     diffs(:,i) = X(:,i) - mu;
%     A = diffs(:,i); %change from diffs to diffs(:,i)
%     covar = covar + A*A';
% end 
% covar = covar/(n_vects-1);
% 
% % A = (X(:,1) - mu);
% % covar = covar + alpha_cov*(A*A');

%end
