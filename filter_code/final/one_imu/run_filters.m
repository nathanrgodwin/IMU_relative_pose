tstick_path = '../../../TStick/';
tstick_struct = dir(strcat(tstick_path, '/*.csv'));
num_data = size(tstick_struct);

names = {};
datas = {};
times = {};
truths = {};
data_idxs = 1:num_data;
data_idxs = [1,2,3,9,11,12,13,14,15];

for data_idx = data_idxs
    names{data_idx} = tstick_struct(data_idx).name;
    temp = csvread(strcat(tstick_struct(data_idx).folder, '/', tstick_struct(data_idx).name), 2, 0);
    times{data_idx} = temp(:,1)';
    truths{data_idx} = temp(:,2:5)';
    datas{data_idx} = temp(:,6:14)';
end

% meths = {@UKF4, @UKF7};
meths = {@EKF4,@EKF4,@EKF4,@UKF4,@UKF4,@UKF4};
meth_args = {};
meth_args{length(meths)} = [];
% meth_args{1} = [];
% meth_args{2} = {eye(3)*0.001, eye(3)};
% meth_args{3} = {eye(3), eye(3)*0.001};
% meth_args{4} = [];
% meth_args{5} = {eye(3)*0.001, eye(3)};
% meth_args{6} = {eye(3), eye(3)*0.001};

states = {};
covars = {};

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
save(datestr(datetime, 'mmddHHMM'));
result_accuracy
