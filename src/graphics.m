clc; clear; close all;

% ------------------------------------------------------------------------
%                           GRAPHICS
% ------------------------------------------------------------------------

%% CONFIGURACION TYPOGRAFY

set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');
set(groot, 'defaultTextInterpreter', 'latex');

font_size = 24;
line_width = 1.5;
font_size_legent = 20;
%% DEFINING PARAMETERS
dim = 64;
n_input = 1;
n_output = 1;
leanking_rate = 0.8; 
sparse = 0.9;
spectal_radius = 0.95;
regu = 1e-5;


%% PREPROCESING DATA AND PLOTING

load('signal_1_case_kanai.mat'); 
load('signal_2_case_kanai.mat');


f = 4096;

t = 0:1/f:39;

y = signal_1_case_kanai(2, :); %output plant, input to train
func = signal_1_case_kanai(1,:); %input plant, target to train
y_test = signal_2_case_kanai(2, :); %output plant, input to test
func_test = signal_2_case_kanai(1,:); %input plant, target to test

input_training = y(1:length(t));
target_training = func(1:length(t));

input_testing = y_test(1:length(t));
target_testing = func_test(1:length(t));


% ------------------ SIGNAL FOR TRAINING STAGE -------------------------
figure(1)
title("Signal for training stage");

g1 = plot(t, input_training, 'black', 'LineWidth',line_width);
hold on;
g2 = plot(t, target_training,'r--', 'LineWidth',line_width);
hold off;

xlabel('Time [s]', "FontSize", font_size);
ylabel('Displacement [m]', "FontSize", font_size);

legend({"Reservoir input (measured response)", "Readout target (command)"}, ...
    'Location', 'best', 'Fontsize', font_size_legent, 'Box', 'off');


grid on;
grid minor;

ax = gca;
ax.FontSize = font_size;
ax.Box = 'on';
ax.LineWidth = 1;

% --------- SIGNAL FOR TESTING STAGE ------------------------------------
figure(2)

g1 = plot(t(29*f:35*f), input_training(29*f:35*f), ...
    'black', 'LineWidth',line_width);
hold on;
g2 = plot(t(29*f:35*f), target_training(29*f:35*f), ...
    'r--', 'LineWidth',line_width);
hold off;

xlim([29, 35]);

xlabel('Time [s]', "FontSize", font_size);
ylabel('Displacement [m]', "FontSize", font_size);
legend({"Reservoir input (measured response)", "Readout target (command)"}, ...
    'Location', 'best', 'Fontsize', font_size_legent, 'Box', 'off');


grid on;
grid minor;

ax = gca;
ax.FontSize = font_size;
ax.Box = 'on';
ax.LineWidth = 1;

%% TEST ERROR FOR DIFFERENT CONFIGURATION


dimension = [16, 32, 64, 100, 128, 160, 200, 250, 512, 1024];
sp_r = [0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.85 0.9 0.95 0.99];

response = zeros(length(dimension), length(sp_r));
% for i=1:length(dimension)
%     for j=1:length(sp_r)
%         disp(['dimension: ', num2str(dimension(i)), ...
%             ' -- sp_r:', num2str(sp_r(j))])
%         [W, W_in, W_out] = generate_model(dimension(i), ...
%             n_input, n_output, sparse, sp_r(j));
% 
%         W_out(:) = training_model(input_training, target_training, ...
%             W_in, W, leanking_rate, regu);
% 
%         error = test_model(input_testing, target_testing, ...
%             W_in, W_out, W, leanking_rate);
% 
%         response(i, j) = error;
% 
%     end
% end
% 
% save("response_gra.m", "response");

load("response_gra.mat")

function cmap = blueOrangeRedMap(n)
    if nargin < 1, n = 256; end

    % Definir tres puntos: azul (pequeño), naranja (medio), rojo (grande)
    blue    = [0.10 0.30 0.95];   % azul frío para valores pequeños
    orange  = [1.00 0.60 0.20];   % naranja medio
    red     = [0.95 0.10 0.10];   % rojo intenso para valores grandes
    
    % Crear transición en tres segmentos
    t = linspace(0, 1, n)';
    cmap = zeros(n, 3);
    
    % Primera mitad: azul → naranja
    idx1 = t <= 0.5;
    if any(idx1)
        t1 = t(idx1) * 2;  % Escalar a [0,1]
        for i = 1:3
            cmap(idx1, i) = (1-t1)*blue(i) + t1*orange(i);
        end
    end
    
    % Segunda mitad: naranja → rojo
    idx2 = t > 0.5;
    if any(idx2)
        t2 = (t(idx2) - 0.5) * 2;  % Escalar a [0,1]
        for i = 1:3
            cmap(idx2, i) = (1-t2)*orange(i) + t2*red(i);
        end
    end
    
    % Asegurar que esté en rango [0,1]
    cmap = max(min(cmap, 1), 0);
end


figure('Color','w');
response_fliped = flipud(response(1:end-1, 2:end));

imagesc(response_fliped);
% Softer colormap (less contrast than jet/turbo)
colormap(blueOrangeRedMap(256));
cb = colorbar;
cb.Label.String = 'Error value (%)';   % rename if needed

% Equal spacing for both axes
axis tight;
axis ij;  % puts first row at the top (matches your table order)

% X axis labels = spectral radius
xticks(1:numel(sp_r(2:end)));
xticklabels(string(sp_r(2:end)));
xlabel('Spectral Radius $\rho$', 'FontSize', font_size);

% Y axis labels = RC dimension (nodes)
yticks(1:numel(dimension(1:end-1)));
yticklabels(string(flip(dimension(1:end-1))));
ylabel('RC Dimension (Nodes)', 'FontSize', font_size);



% Optional: improve readability
ax = gca;
ax.FontSize = font_size;
ax.TickDir  = 'out';
ax.Box = 'on';
ax.LineWidth = 1;


%% CAPACITY MEMORY

delays =1:100;
rng(42);
T = 100 * 200; %amount of data;
input_signal = 2*rand(T,1) - 1;
test_signal =  2*rand(T,1) - 1;
treshold = 300;
    
dim = [64]; % only the selected
sp_r = [0.95];
MC_k = zeros(size(delays));
for d = dim
    for sp = sp_r
        disp(['dimension: ', num2str(d), ...
                ' -- sp_r:', num2str(sp)]);
        
        for i=delays
            [W, W_in, ~] = generate_model(d, ...
                n_input, n_output, sparse, sp);

            training_signal = input_signal( ...
                treshold+i:end-treshold);


            target_signal = input_signal( ...
                treshold:end-treshold-i);
            
            W_out = training_model(training_signal', target_signal', ...
                W_in, W, leanking_rate, regu);

            [signal, error, MC_t] = test_pred( ...
                test_signal(treshold:end-treshold), ...
                W_in, W, W_out, leanking_rate, i);
            
            MC_k(i+1) = MC_t;
            % figure(4);
            % plot(test_signal(treshold:end-treshold-i), 'black');
            % hold on;
            % plot(signal, 'r--');
            % hold off;


        end
    end
end
plot(MC_k);
%% p

[MC_total, MC_tau] = prueba_jaeger(200, 0.99, 100000)