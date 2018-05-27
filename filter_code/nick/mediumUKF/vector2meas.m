function [ ms ] = vector2meas( mv )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
ms = new_meas();
idx = 1;
fields = fieldnames(ms);
for f = 1:length(fields)
    field_size = length(getfield(ms, fields{f}));
    ms = setfield(ms, fields{f}, mv(idx:idx+field_size-1));
    idx = idx + field_size;
end
end
