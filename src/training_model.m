
%% TRAINING THE MODEL

function [W_out] = training_model(input, target, W_in, W,leak, regu)
    %training_model: method used for training
    %input: input signal
    %target: target signal
    %W_in: input layer
    %W: Reservoir
    %leak: leaking rate, relationship of past 
    %regu: regularization 

    len = length(input);
    
    
    nodes_states = zeros(length(W_in), len);

    for t_i = 1:len - 1
        node_updates = tanh( W_in * input(t_i) + W * nodes_states(:, t_i));
        nodes_states(:, t_i + 1) = (1 - leak) * ... 
            nodes_states(:, t_i) + leak .* node_updates;   
    end
    
    %calculate the correct weigths
    W_out(:, :) = target * nodes_states' * ...
        (nodes_states * nodes_states' + regu*eye(length(W_in)))^(-1);

end
