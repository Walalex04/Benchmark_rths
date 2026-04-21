clc; clear;

%% LOAD DATA
% 
% 
%load('signal_1_case_1.mat'); %load the case 1, first signal to train model
% 
%y = signal_1_case_1(2, :); %output plant, input to train
%func = signal_1_case_1(1,:); %input plant, target to train

%load('signal_2_case_1_modified.mat'); %load the case 1 with modification, first signal to train model

% load("signal_sum_cases.mat") %load the sum of cases
% 
% y = signal_sum_cases(2, :); %output plant, input to train
% func = signal_sum_cases(1,:); %input plant, target to train

% 
load('signal_1_case_kanai.mat'); %load the case 1, first signal to train model
% % 
y = signal_1_case_kanai(2, :); %output plant, input to train
func = signal_1_case_kanai(1,:); %input plant, target to train


load('signal_2_case_kanai.mat');
y_test = signal_2_case_kanai(2, :); %output plant, input to train
func_test = signal_2_case_kanai(1,:); %input plant, target to train



dt_rths = 4096;
t = 20; %20 %we change this - 15 for sum
point_mu = t * dt_rths;
initial_point = 3*dt_rths;

input_signal = y(initial_point:initial_point+round(point_mu));
output_signal =  func(initial_point:initial_point + round(point_mu));

input_signal_test = y_test(initial_point:initial_point+round(point_mu));
output_signal_test =  func_test(initial_point:initial_point + round(point_mu));

figure(1)
plot(input_signal);
hold on
plot(output_signal);
hold off

%% CONFIG
n_nodes = 64; %numero de neuronas
n_input = 1; %numeros de entradas que tendra el algoritmo
n_output = 1;
learning_rate = 0.80; 
sparse = 0.9; %0.75
spectal_radius = 0.95;
B = 1e-5; %regular   izacion


%% GENERATE A LARGE RANDOM RESERVOIR

W = zeros(n_nodes); %matrix n_nodes x n_nodes
W_in = zeros(n_nodes, n_input); %matrix n_nodes x n_input       

rng(25); %seed

%genera una matriz random y simetrica
%observacion: se puede utilizar una distribuccion gaussianda con randn pero
%se necesita volverla simetrica
W(:, :) = sprandsym(n_nodes, n_nodes, sparse);
W_in(:, :) = sprandn(n_nodes, n_input, sparse);
W_out = zeros(n_output, n_nodes + n_input - 1);
%disminuyendo el radio espectral del W

W(:, :) = W/(abs(eigs(W, 1)) * spectal_radius);

%% data generate table

sizes = [8 16 64 128 512 1048];
spectal_radius = [0.5 0.6 0.75 0.8 0.85 0.9 0.95 0.99];

%% ENTRENAMIENTO

tic;
length_total = length(input_signal);
length_training = int64(length_total * 1);

%datos
u = input_signal(:);
output = output_signal(:); 


for index = 1:length(sizes)
    for index_2 = 1:length(spectal_radius)
        
    end

end

nodes_states = zeros(n_nodes, length_training);

%se calcula los estados de la red neuronal recurrente

for t_i = 1:length_training - 1
    node_updates = tanh( W_in * u(t_i) + W * nodes_states(:, t_i));
    nodes_states(:, t_i + 1) = (1 - learning_rate) * nodes_states (:, t_i) + ...
                                learning_rate .* node_updates;
    
end

%se calcula la matriz de peso final

W_out(:, :) = output' * nodes_states' * (nodes_states * nodes_states' + ...
            B*eye(n_nodes))^(-1);
Po = (nodes_states * nodes_states' + B*eye(n_nodes))^(-1);

t_train = toc;
disp(['El tiempo de entrenamiento es de: ', num2str(t_train)]);

%% TESTING
init_point_train = 1; %start from 3 init seconds
u_pre = y_test(init_point_train: end);

last_state = nodes_states(:, end);
save('last.mat', 'last_state');
length_prediction = length(u_pre); %tamanio de prediccion que se hara


y_predict = zeros(1, length_prediction);
%y_real = func_test(initial_point+round(point_mu) +1: length_prediction + initial_point+round(point_mu));
y_real = func_test(init_point_train: end);


for t_i = 1:length_prediction
    node_updates = tanh( W_in * u_pre(t_i) + W * last_state);
    last_state = (1 - learning_rate) * last_state + ...
                                learning_rate .* node_updates;

    y_predict(1, t_i) = W_out * last_state;
    

end

error = sum((y_predict(1, 1:end) - y_real(1,  1:end)).^2);
error = error / length(y_predict(1, 1:end));
error = sqrt(error);

error = error/(max(y_predict(1,1:end) - min(y_predict(1, 1:end))));



disp(["El error rms es: ", num2str(error)]);


% Guardar los datos de los pesos
save('w_in.mat', "W_in");
save('W.mat', "W");
save('W_out', 'W_out');

%mostrar los resultados
figure()
subplot(3, 1, 1);
plot(u_pre);


subplot(3, 1, 2);
plot(y_real, 'w', 'LineWidth', 1.5);
hold on;
plot(y_predict, 'r--', 'LineWidth', 1.5);
hold off;
legend('salida deseada', 'respuesta predictiva'); % Agrega una leyenda


%% computing Po that is similar to cross correlation 

num_data = length(input_signal);
auto_corr_mue = zeros(n_nodes, n_nodes);
for i = 1:num_data
    auto_corr_mue = auto_corr_mue + nodes_states(:, i)*nodes_states(:, i)';
end

auto_corr_mue = (1/num_data) * auto_corr_mue;

Po = inv(auto_corr_mue + 1e-3*eye(n_nodes, n_nodes));

save('Po.mat', 'Po');

e = eig(Po);  % autovalores

if all(e >= -1e-12)   % tolerancia numérica por redondeo
    disp('La matriz es semidefinida positiva.');
else
    disp('La matriz NO es semidefinida positiva.');
end