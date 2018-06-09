function [ new_state_t1 ] = EKF_a( state_t, omega_t1 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

dt = 1;%in seconds
% quat_delta = aa2quat(quat2aa(euler2quatern(omega_t1))*dt);
quat_delta = aa2quat(omega_t1*dt);

new_state_t1 = quatproduct(state_t,quat_delta);
  


end

