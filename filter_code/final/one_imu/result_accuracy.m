fc = 0;

for data_idx = [data_idxs(1), data_idxs]
    fc=fc+1;    figure();
    temp_state = truths{data_idx};
    temp_state = quat2aa(temp_state(1:4,:));
    for idx = 1:3             
        subplot(3,1,idx);  hold on;
        plot(times{data_idx},temp_state(idx,:),'k');
        if idx==1
            title(sprintf('set %g: %s',data_idx,names{data_idx}), 'Interpreter', 'none');
            fprintf('sdfsdf\n');
        end
    end
    for meth_idx = 1:length(meths)
        temp_state = states{data_idx, meth_idx};
        temp_state = quat2aa(temp_state(1:4,:));
        for idx = 1:3
            subplot(3,1,idx);  hold on;
            plot(times{data_idx},temp_state(idx,:));
        end
    end
    
    if fc==1
        temp_names = 1:length(meths);
        for i = 1:length(meths)
            temp_names(i) = func
            legend()
        end
    end
end