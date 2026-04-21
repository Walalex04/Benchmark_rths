
%% TEST MODEL

function [error] = test_model(input, target, W_in, W_out, W, leak)
    %test_model: evaluation of the model
    %input: input signal
    %target: target signal
    %W_in: input layer
    %W_out: output layer
    %W: Reservoir
    %leak: leaking rate

    len = length(input);
    y_predict = zeros(1, len);

    last_state = zeros(length(W_in), 1);
    for t_i = 1:len
        node_updates = tanh( W_in * input(t_i) + W * last_state);
        last_state = (1 - leak) * last_state + ...
                                    leak .* node_updates;
    
        y_predict(1, t_i) = W_out * last_state;
        
    
    end

    error = sum((y_predict(1, 1:end) - target(1,  1:end)).^2);
    error = error / length(y_predict(1, 1:end));
    error = sqrt(error);
    error = error/(max(y_predict(1,1:end) - min(y_predict(1, 1:end))));
    error = error * 100;


end