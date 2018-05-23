function [ new_s ] = process( s )
%process The process model that produces the (t+1) state esitmate from the
%(t) state.
%   input--     s       =   (t) state
%   output--    new_s   =   (t+1) state
dt = 1;

new_s.GRI   = quatproduct(euler2quatern(dt*s.GW), s.GRI);
new_s.IRJ   = s.IRJ;
new_s.IPJ   = s.IPJ;
new_s.GW    = s.GW;

%GVI_0
new_s.GVI_0 = s.GVI_0 + (s.GVI_0 - s.GVI_1)/dt;

new_s.GVI_1 = s.GVI_0;
end

