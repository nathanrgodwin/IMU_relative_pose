tstick_path = '../../../TStick/';
tstick_struct = dir(strcat(tstick_path, '/*.csv'));
num_data = size(tstick_struct);

names = {};
datas = {};
times = {};
truths = {};
data_idxs = 1:num_data;

data_idxs = [2,7,10,15,18,27];
for data_idx = data_idxs
    names{data_idx} = tstick_struct(data_idx).name;
    temp = csvread(strcat(tstick_struct(data_idx).folder, '/', tstick_struct(data_idx).name), 2, 0);
    times{data_idx} = temp(:,1)';
    truths{data_idx} = temp(:,2:5)';
    datas{data_idx} = temp(:,6:14)';
end

meths = {@Integration_hard_bias,@MADG_hard_bias,@EKF4_hard_bias,@UKF4_hard_bias,@UKF7_hard_bias,@UKF4mag_hard_bias};
meths = {@Integration,@MADG,@EKF4,@UKF4,@UKF7,@UKF4mag};
meth_args = {};
meth_args{length(meths)} = [];

meth_args{1} = [];
meth_args{2} = [];
meth_args{3} = [];
meth_args{4} = [];
meth_args{5} = [];
meth_args{5} = [];

states = {};
covars = {};
mse = {};
total_mse = {};

for data_idx = data_idxs
    for meth_idx = 1:length(meths)
        fprintf(sprintf('%s \twith %s',func2str(meths{meth_idx}),names{data_idx}));
        fprintf(sprintf('\ttime:%g ... ',cputime));
        data = datas{data_idx};
        time = times{data_idx};
        meth = meths{meth_idx};
        if strcmp(class(meth_args{meth_idx}),'cell')
            [states{data_idx, meth_idx}, covars{data_idx, meth_idx}] = meth(data, time, meth_args{meth_idx}{1}, meth_args{meth_idx}{2});
        else
            [states{data_idx, meth_idx}, covars{data_idx, meth_idx}] = meth(data, time);
        end
        
        fprintf(sprintf('%g\n',cputime));
    end    
end

for data_idx = data_idxs
    temp_truths = truths{data_idx};
    temp_truths = quat2aa(temp_truths(1:4,:));
    for meth_idx = 1:length(meths)
        temp_state = states{data_idx, meth_idx};
        temp_state = quat2aa(temp_state(1:4,:));
        mse{data_idx, meth_idx} = sum((temp_truths-temp_state).^2, 2) ./ size(temp_state,2);
        total_mse{data_idx, meth_idx} = sum(mse{data_idx, meth_idx})/3;
    end
end
resultpath = './result/';
timestamp = datestr(datetime, 'mmddHHMM');
fileID = fopen(strcat(resultpath,timestamp,'.txt'),'w');
save(strcat(resultpath,timestamp));

func_mse = sum(cell2mat(total_mse),1)/size(cell2mat(total_mse),2);
for meth_idx = 1:length(meths)
    fprintf(fileID, sprintf('method:%s\ttotalmse:%d\n', func2str(meths{meth_idx}), func_mse(meth_idx)));
end
data_mse = sum(cell2mat(total_mse),2)/size(cell2mat(total_mse),1);
for i = 1:length(data_idxs)
    data_idx = data_idxs(i);
    fprintf(fileID, sprintf('dataset %g: %s\tavg_mse:%d\n',data_idx,names{data_idx},data_mse(i)));
end

for data_idx = data_idxs
    fprintf(fileID, sprintf('dataset %g: %s\n',data_idx,names{data_idx}));
    for meth_idx = 1:length(meths)
        fprintf(fileID, sprintf('method:%s\ttotalmse:%d\n', func2str(meths{meth_idx}), total_mse{data_idx, meth_idx}));
    end
end
fclose all
result_accuracy
