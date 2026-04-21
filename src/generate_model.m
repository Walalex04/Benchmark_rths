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
    W_in = zeros(dim, n_input);  

    %W(:, :) = sprandsym(dim, dim, sparse);
    W(:) = sprand(dim, dim, sparse);
    
    %W_in(:, :) = sprandn(dim, n_input, sparse);
    W_in(:) = rand(dim, n_input)*0.1;
    W_out = zeros(n_output, dim + n_input - 1);

    W(:, :) = W/(abs(eigs(W, 1)) * sp_r); %change the spectral r

end

