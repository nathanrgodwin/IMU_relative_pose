function [ aa ] = quat2aa( quat )
%columns
quat = quat';
aa = zeros(size(quat));
aa(:,4) = 2*atan2(sqrt(sum(quat(:,2:4).^2,2)),quat(:,1));
aa(:,1:3) = quat(:,2:4)./(sin(aa(:,4)/2) * ones(1,3));
aa = aa';
end