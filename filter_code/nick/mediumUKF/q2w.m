function [w] = q2w(q)
wbig = 2*qlog(q);

w = wbig(2:end);

end

