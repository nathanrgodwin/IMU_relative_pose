function [ v ] = unquat( q )
%unquat Converts a quaternion to a euclidian point-vector by omitting the
%scalar
%   
    v = q(2:4, :);

end

