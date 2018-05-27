function [out] = qnorm(q_in)

s_in = q_in(1);
v_in = q_in(2:4);

out = (s_in^2 + v_in'*v_in)^.5;

end