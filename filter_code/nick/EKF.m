
ident_quat = [1 0 0 0]'
om = omega([0.1 0 0]')

result = 1/2 * om * ident_quat








function [om] = omega(w)
    om = zeros(3);
    wx = w(1);
    wy = w(2);
    wz = w(3);

    om = ...
    [   0   -wx -wy -wz ;
        wx  0   wz  -wy ;
        wy  -wz 0   wx  ;
        wz  wy  -wx 0   ];

end
