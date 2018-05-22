function [ mu, cov, W_prime ] = quat_stats( X, alpha_mu, alpha_cov, mu_quats))
%mu_quats is an initial guess
%check weights later
%change to account for state difference: only 2 quats

[~,n_quats] = size(X);
n = 3; %dimension

quat_err = ones(4,n_quats);
w_err = ones(3,n_quats);
w_err_mean = ones(3,1);
error_norm_min = .0001;
maxT = 1000;

for t = 1:maxT
    for i = 1:n_quats
        quat_err(:,i) = q_mult(q_inv(mu_quats),X(:,i));
        w_err(:,i) = q2w_log(quat_err(:,i));
        %restrict -pi to pi
        if isnan(norm(w_err(:,i)))
            print('norm is nan');
            w_err(:,i) = zeros(3);
        elseif norm(w_err(:,i)) == 0
            print('norm is zero');
            w_err(:,i) = zeros(3);            
        else
            w_err(:,i) = (-pi + mod(norm(w_err(:,i)) + pi,2*pi))*w_err(:,i)/norm(w_err(:,i));
        end     
    end 
    w_err_mean = sum(w_err(:,1),2)/(2.0*n) + alpha_mu*w_err(:,1);
    mu_quats = q_mult(mu_quats,w2q_exp(w_err_mean));
    
    if norm(w_err_mean) < err_norm_min %compute covariance
        covar = zeros(3,3);
        for i=2:n_quats
            A = w_err(:,i)';
            covar = covar + A*A';
        end 
        covar = covar/(2*n);
        A = w_err(:,1)';
        covar = covar + alpha_cov*(A*A');
        mu = mu_quats;
        cov = covar;
        W_prime = w_err;
        break 
    end 
end 

end

