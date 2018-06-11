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
        %temp_names{i+1} = temp_names{i+1}(1:end-10);
    end
    legend(temp_names)
end

%% 
% %adds labels to plot afterward

subplot(3,1,1)
ylabel('x (rad)');
%title('Set 1: Stationary, after removing bias');
%title('set27: TStick_Test11_Trial1');
%title('Fast Rotation around X');
%title('Translation along X');
%title('Slow free rotation, after removing bias');
title('Fast Rotation around Z');

subplot(3,1,2)
ylabel('y (rad)');
subplot(3,1,3)

ylabel('z (rad)');
xlabel('time(sec)');
