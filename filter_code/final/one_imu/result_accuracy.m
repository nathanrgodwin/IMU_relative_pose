fc = 0;

style = {'--',':','-.','-'};
style = [style style style style];
for data_idx = data_idxs
    fc=fc+1;    figure();
    temp_state = truths{data_idx};
    temp_state = quat2aa(temp_state(1:4,:));
    for idx = 1:3             
        subplot(3,1,idx);  hold on;
        plot(times{data_idx},temp_state(idx,:),'k','LineWidth',1.5);
        if idx==1
            title(sprintf('set %g: %s',data_idx,names{data_idx}(1:end-4)), 'Interpreter', 'none');
%             fprintf('sdfsdf\n');
        end
    end
    for meth_idx = 1:length(meths)
        temp_state = states{data_idx, meth_idx};
        temp_state = quat2aa(temp_state(1:4,:));
        for idx = 1:3
            subplot(3,1,idx);  hold on;
            plot(times{data_idx},temp_state(idx,:),style{meth_idx},'LineWidth',1.1);
        end
    end   
    temp_names = {'truth'};
    for i = 1:length(meths)
        temp_names{i+1} = func2str(meths{i});
    end
    legend(temp_names)
end