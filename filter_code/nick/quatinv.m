function [ output_args ] = quatinv( q )
%columns
    q = q';
    output_args = [q(:,1) -q(:,2) -q(:,3) -q(:,4)];
    output_args = output_args';
end