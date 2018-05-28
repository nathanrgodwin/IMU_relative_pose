start_point = [0 0 1]';

eul_rot = [pi/4 pi/4 0]'

quat_rot = euler2quatern(eul_rot);

final_pos = quatproduct(quatproduct(quat_rot, [0;start_point]),quatinv(quat_rot))

