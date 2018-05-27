rng('default');

n_steps = 100;
init_state = new_state();
init_state.GRI = aa2quat([0; 0; 0]);
init_state.GW = [0;0;1];
init_state.IPJ = [0;0;0];
sv = state2vector(init_state);

data = zeros(18,n_steps);
true_state = zeros(length(state2vector(new_state)),n_steps);

for i = 1:100
    true_state(:,i) = sv;
    data(:,i) = measurement_model(sv) + 0.00000001*randn(18,1);
    sv = process(sv);
end
