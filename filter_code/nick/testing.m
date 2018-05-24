% r = r0 + i*r + j*r + k*r;

% ident_quat = [1 0 0 0];
% gx_basis_quat = [0 1 0 0];
% gy_basis_quat = [0 0 1 0];
% gz_basis_quat = [0 0 0 1];
% orientation_quat = aa2quat(0,0,1,pi/4);
% 
% small_w = [0, 0, pi/12];    %euler
% dt = 0;
% 
% start_R = quat2rotm(orientation_quat);
% % quat2rotm(ident_quart)
% 
% new_orientation_quat = quatproduct(euler2quatern(dt*small_w(1), dt*small_w(3), dt*small_w(3))', orientation_quat);
% 
% small_R = quat2rotm(euler2quatern(dt*small_w(1), dt*small_w(3), dt*small_w(3))');
% new_R = quat2rotm(new_orientation_quat);
% 
% test_point = [7; 6; 9];
% 
% matrix_result = small_R * (start_R * test_point)
% 
% quat_result = quatproduct(quatproduct(new_orientation_quat, [0; test_point]'), quaternConj(new_orientation_quat))

%testing functions
% aas = [flipud(eye(3)); [pi/3, pi/6, -pi/12]]
% aas = diag([pi/3, pi/6, -pi/12])
% orients_q = aa2quat(aas)
% orients_a = quat2aa(orients_q)
% orients_q = aa2quat(orients_a)
% orients_a = quat2aa(orients_q)
% orients_q = aa2quat(orients_a)
% orients_a = quat2aa(orients_q)
% orients_q = aa2quat(orients_a)

% state = new_state();
% state.GW = [0; 0; 0.2];

% state = vector2state(process(state2vector(state)))
% state2vector(state)

% rng('default');
% q = randn(4,8);
% q(:,2) = [1 0 0 0]';
% q(:,3) = [1 realmin realmin -realmin]';
% q
% a = quat2aa(q)
% q = aa2quat(a)
% a = quat2aa(q)
% q = aa2quat(a)
% a = quat2aa(q)
% q = aa2quat(a)



rng('default');
D = randn(12,20);
vect_stats(D,1,1)