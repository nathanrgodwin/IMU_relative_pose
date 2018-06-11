tstick_path = '../../../TStick/';
tstick_struct = dir(strcat(tstick_path, '/*.csv'));
num_data = size(tstick_struct);

names = {}; datas = {}; times = {}; truths = {};
data_idxs = 1:num_data;
% data_idxs = [1,2,3,9,11,12,13,14,15];
% data_idxs = [3,9,15,24,27:29];
% data_idxs = [1,2,9,12,27:29];
data_idxs = [3,9,27];

for data_idx = data_idxs
    names{data_idx} = tstick_struct(data_idx).name;
    temp = csvread(strcat(tstick_struct(data_idx).folder, '/', tstick_struct(data_idx).name), 2, 0);
    times{data_idx} = temp(:,1)';
    truths{data_idx} = temp(:,2:5)';
    datas{data_idx} = temp(:,6:14)';
end

% meths = {@UKF4, @EKF4, @UKF7};
meths = {@UKF7bias,@UKF7bias,@UKF7bias,@UKF7bias,@UKF7bias,@UKF7bias,@UKF7bias,@EKF4};
% meths = {@UKF7,@UKF7,@UKF7,@EKF4};
% meths = {@EKF4,@EKF4,@EKF4,@EKF4,@EKF4,@EKF4,@EKF4};
% meths = {@EKF4mag, @EKF4, @EKF4, @EKF4, @EKF4};
% meths = {@EKF4mag,@EKF4mag, @EKF4};
% meths = {@UKF4, @UKF4,@UKF4,@UKF4,@UKF4,@UKF4};

meth_args = {};
meth_args{length(meths)} = [];
for i = 1:7
    k = 1*10^(i-5);
    meth_args{i} = {blkdiag(diag([1 1 0.1]*1e-4), eye(3)*1e-5, eye(3)*k), ...
        blkdiag(eye(3)*1e2,eye(3)*1e2)};
    %meth_args{i} = {k*eye(3)*1e-8, k*eye(3)};
end

%meth_args{2} = {eye(6)*0.0001, blkdiag(eye(3)*10, eye(3)*0.001)};
% meth_args{3} = {eye(3)*0.0001, eye(3)};
%meth_args{3} = {eye(6)*0.001, eye(6)};
% meth_args{5} = {eye(3)*0.01, eye(3)};
%meth_args{4} = {eye(6)*0.1, eye(6)};



states = {}; covars = {}; mse = {}; total_mse = {};

for data_idx = data_idxs
    for meth_idx = 1:length(meths)
        fprintf(sprintf('%s \twith %s',func2str(meths{meth_idx}),names{data_idx}));
        fprintf(sprintf('\ttime:%g ... ',cputime));
        data = datas{data_idx};
        time = times{data_idx};
        meth = meths{meth_idx};
        if iscell(meth_args{meth_idx})
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



result_accuracy
