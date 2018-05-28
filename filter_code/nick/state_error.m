function [ err_vec ] = state_error( sv1, sv2 )
%UNTITLED27 Summary of this function goes here
%   Detailed explanation goes here
q1_error = quatproduct(sv1(1:4,:), quatinv(sv2(1:4,:)));
q2_error = quatproduct(sv1(5:8,:), quatinv(sv2(5:8,:)));

err_vec = [q1_error; q2_error; sv2(9:end,:)-sv1(9:end,:)];

end

