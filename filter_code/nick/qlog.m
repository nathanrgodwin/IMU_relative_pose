function [q_out] = qlog(q_in)

s_in = q_in(1);
v_in = q_in(2:4);

s_out = log(qnorm(q_in));
v_out = v_in/norm(v_in)*acos(s_in/qnorm(q_in));  

q_out = [s_out;v_out];
end 
