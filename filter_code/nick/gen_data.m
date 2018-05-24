n_steps = 100;
init_state = new_state();
init_state.GW = [0;0;0.01];
sv = state2vector(init_state);

data = zeros(18,n_steps);

for i = 1:100
    data(:,i) = measurement_model(sv);
    sv = process(sv);
end
