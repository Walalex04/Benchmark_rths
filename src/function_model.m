
%-------------------------------------------------------------------------
%                 CONSTRUCTION RESERVOIR COMPUTING MODEL
%-------------------------------------------------------------------------


%% GENERATING MODEL 

function [W, W_in, W_out] = generate_model(dim, n_input, n_output, ...
    sparse, sp_r)
    % generate_model: generate the model including input layer, output and
    % Reservoir 

    % dim: Dimension of the reservoir (size of the matrix)
    % n_input: number of entries
    % n_output: number of outputs
    % sparse: sparse of the reservoir
    % sp_r: spectral radius of the matrix

    W = zeros(dim); %reservoir
    W_in = zeros(n_nodes, n_input);  

    W(:, :) = sprandsym(dim, dim, sparse);
    W_in(:, :) = sprandn(dim, n_input, sparse);
    W_out = zeros(n_output, dim + n_input - 1);

    W(:, :) = W/(abs(eigs(W, 1)) * sp_r); %change the spectral r

end



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
    
    
    nodes_states = zeros(n_nodes, len);

    for t_i = 1:length_training - 1
        node_updates = tanh( W_in * input(t_i) + W * nodes_states(:, t_i));
        nodes_states(:, t_i + 1) = (1 - leak) * ... 
            nodes_states(:, t_i) + leak .* node_updates;   
    end
    
    %calculate the correct weigths
    W_out(:, :) = target' * nodes_states' * ...
        (nodes_states * nodes_states' + regu*eye(n_nodes))^(-1);

end


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


    for t_i = 1:length_prediction
        node_updates = tanh( W_in * u_pre(t_i) + W * last_state);
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