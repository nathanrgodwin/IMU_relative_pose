rng('default');

n_steps = 500;
init_state = new_state();
init_state.GRI = aa2quat([0; 0; 0]);
init_state.GW = [0;0;1];
init_state.IPJ = [1;0.2;0];
sv = state2vector(init_state);

data = zeros(18,n_steps);
true_state = zeros(length(state2vector(new_state)),n_steps) ;

for i = 1:n_steps
    true_state(:,i) = sv;
    true_state(1:4,i) = aa2quat(quat2aa(sv(1:4)) + 0.0*randn(3,1));
    true_state(5:8,i) = aa2quat(quat2aa(sv(5:8)) + 0.0*randn(3,1));
    true_state(9:end,i) = sv(9:end) + 0.0*randn(9,1);
    data(:,i) = measurement_model(sv) + 0.001*randn(18,1);
    sv = process(sv);
end
