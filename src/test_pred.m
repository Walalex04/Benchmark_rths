%% PREDICTION OF SIGNAL USING THE OUTPUT

function [signal, error, MC_t] = test_pred(target_signal, ...
    W_in, W, W_out, leak, delay)

    %test_pred: This function make prediction using the output as input
    %target_signal: the reference signal
    %W: Reservoir
    %W_in: input layer
    %W_out: Output later
    %leak: leaking_rate
    %delay: delay
    
    len = length(target_signal);
    y_predict = zeros(size(target_signal));
    last_state = zeros(length(W_in), 1);
    for t_i = 1:len
        node_updates = tanh( W_in * target_signal(t_i) + W * last_state);
        last_state = (1 - leak) * last_state + ...
                                    leak .* node_updates;
    
        y_predict(t_i) = W_out * last_state;
    end

    signal = y_predict(:);
    error = sum((y_predict(:) - target_signal(:)).^2);
    error = error / length(y_predict(:));
    error = sqrt(error);
    error = error/(max(y_predict(:) - min(y_predict(:))));
    error = error * 100;

    %implementation the capacity memory
    
    coef = cov(target_signal(10:end-delay)', y_predict(10+delay:end)');
    MC_t = coef(1,2)^2/ (coef(1,1)^2 * coef(2,2)^2);
end