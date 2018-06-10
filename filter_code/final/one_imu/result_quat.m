fc = 0;

for data_idx = data_idxs
    fc=fc+1;    figure();
    temp_state = truths{data_idx};
%     temp_state = quat2aa(temp_state(1:4,:));
    for idx = 1:4     
        subplot(4,1,idx);  hold on;
        plot(times{data_idx},temp_state(idx,:),'k');
        if idx==1
            title(names{data_idx});
            fprintf('sdfsdf\n');
        end
    end
    for meth_idx = 1:length(meths)
        temp_state = states{data_idx, meth_idx};
%         temp_state = quat2aa(temp_state(1:4,:));
        for idx = 1:4
            subplot(4,1,idx);  hold on;
            plot(times{data_idx},temp_state(idx,:));
        end
    end
end