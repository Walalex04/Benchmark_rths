%% Memory Capacity experiment (Jaeger-style)
clear; clc; close all;

%% Parameters
N   = 100;        % reservoir size
T   = 10000;       % total time
washout = 1000;   % discard initial transient
K   = 100;        % max delay to test (choose <= washout/5 typically)

rho   = 0.99;      % spectral radius
sparsity = 0.9;   % fraction of zeros in W (0.9 -> 10% density)
inputScale = 0.5; % scaling of input weights
leak = 0.8;       % 1.0 = standard ESN (no leaky integration)
lambda = 1e-5;    % ridge regularization for readout

%% Generate input (zero-mean i.i.d.)
u = 2*rand(T,1) - 1;   % uniform in [-1,1], mean ~ 0

%% Build sparse reservoir W with desired spectral radius
density = 1 - sparsity;
W = sprandn(N, N, density);   % sparse random normal

% Scale W to have spectral radius = rho
opts.tol = 1e-3;
sr = abs(eigs(W, 1, 'lm', opts));     % largest magnitude eigenvalue (sparse)
W = (rho / sr) * W;

%% Input weights
Win = (2*rand(N,1) - 1) * inputScale;

%% Run reservoir and collect states
X = zeros(N, T);
x = zeros(N,1);

for t = 1:T-1
    preact = W*x + Win*u(t);
    x_new = tanh(preact);

    % Leaky update (optional)
    x = (1 - leak)*x + leak*x_new;

    X(:,t+1) = x;
end

%% Prepare training data after washout
t0 = washout + K + 1;          % ensure u(t-k) exists
idx = t0:T;                    % usable time indices

Xtr = X(:, idx)';              % [numSamples x N]
% Add bias
Xtr = [Xtr, ones(size(Xtr,1),1)];   % [numSamples x (N+1)]

%% Compute MC_k for k = 1..K
MCk = zeros(K,1);

% Precompute ridge matrix
R = (Xtr' * Xtr + lambda * speye(size(Xtr,2)));

for k = 1:K
    y = u(idx - k);  % target is delayed input u(t-k)

    % Train readout (ridge regression): Wout = (X'X + λI)^(-1) X'y
    Wout = R \ (Xtr' * y);

    yhat = Xtr * Wout;

    % Memory coefficient = corr^2(y, yhat) (R^2 for zero-mean signals)
    c = corr(y, yhat);
    MCk(k) = c^2;
end

MC = sum(MCk);

%% Print results
fprintf('Reservoir size N = %d\n', N);
fprintf('Spectral radius rho = %.3f\n', rho);
fprintf('Sparsity = %.2f (density = %.2f)\n', sparsity, 1-sparsity);
fprintf('Max delay K = %d\n', K);
fprintf('Total Memory Capacity MC = %.3f\n', MC);
fprintf('Theoretical upper bound MC <= N = %d\n', N);

%% Plot MC_k
figure('Color','w');
plot(1:K, MCk, 'LineWidth', 1.5);
xlabel('Delay k');
ylabel('MC_k = corr^2(u(t-k), \hat{u}(t))');
title(sprintf('Memory Capacity curve (MC = %.2f)', MC));
grid on;
