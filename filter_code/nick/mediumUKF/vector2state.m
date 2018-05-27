function [ s ] = vector2state( v )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
s = new_state();
idx = 1;
fields = fieldnames(s);
for f = 1:length(fields)
    field_size = length(getfield(s, fields{f}));
    s = setfield(s, fields{f}, v(idx:idx+field_size-1));
    idx = idx + field_size;
end
end

