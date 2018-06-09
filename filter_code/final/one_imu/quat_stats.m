function [ mu, cov, W_prime ] = quat_stats( X, alpha_mu, alpha_cov, mu_quats)
%mu_quats is an initial guess
%check weights later: 1/2n_quats or 1/2n, n = 3

[~,n_quats] = size(X);
% n = 3; %dimension

quat_err = ones(4,n_quats);
w_err = ones(3,n_quats);

err_norm_min = .0001;
maxT = 10000;

for t = 1:maxT
    for i = 1:n_quats
        quat_err(:,i) = quatproduct(quatinv(mu_quats),X(:,i));
        w_err(:,i) = quat2aa(quat_err(:,i));
        %restrict -pi to pi
        if isnan(norm(w_err(:,i)))
%             fprintf('norm is nan\n');
            w_err(:,i) = zeros(3,1);
        elseif norm(w_err(:,i)) == 0
%             fprintf('norm is zero\n');
%             w_err(:,i) = zeros(3,1);            
        else
            %restrict from -pi to pi
            old_w_err = w_err(:,i);
            w_err(:,i) = (-pi + mod(norm(w_err(:,i)) + pi,2*pi))*w_err(:,i)/norm(w_err(:,i));
        end     
    end 
    w_err_mean = sum(w_err(:,2:end),2)/(n_quats-1) + alpha_mu*w_err(:,1);
    mu_quats = quatproduct(mu_quats,aa2quat(w_err_mean));
    
    if norm(w_err_mean) < err_norm_min 
        break 
    end 
    
end 

%compute covariance
covar = zeros(3,3);
for i=2:n_quats
    A = w_err(:,i);%changed transpose --wq
    covar = covar + A*A';
end
covar = covar/(n_quats-1);
A = w_err(:,1);    %change transpose --wq
covar = covar + alpha_cov*(A*A');
mu = mu_quats;
cov = covar;
W_prime = w_err;

if t == maxT
    fprintf('WARNING: quaternion avg not converged\n');
end
end
