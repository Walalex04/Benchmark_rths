%% procesing all signal

%this script will show all signal that are used in train-stage
load Plant.mat 
sampling_time = 1/4096;
t_duraction = 40; %seconds
time_function = 0:sampling_time:40;




% % 
% load data_input.mat  %signal case 1
% input_case1 = desp(1:40*4096 + 1);
% % resp_case1 = lsim(G_plant, input_case1, time_function); %response c1
% 
% load signal_case_3.mat %load case 3 
% input_case3 = signal_3(1:40*4096 + 1);
% % 
% % input_case_sum = (input_case1) + (input_case3);
% % input_case_sum = (input_case_sum) * 0.5;
% input_case_sum = (input_case1) + (input_case3);
% input_case_sum = (input_case_sum)*0.5;
% % 
% resp_case_sum = lsim(G_plant, input_case_sum, time_function);

%show and save signals
% 
% signal_1_case_1 = [input_case1'; resp_case1'];
% save('signal_1_case_1.mat', 'signal_1_case_1');
% figure(1)
% 
% plot(time_function, input_case1, 'black', 'LineWidth', 1.5);
% hold on
% plot(time_function, resp_case1, 'c--', 'LineWidth', 1.5);
% hold off
% set(gca, 'FontSize', 18);       % Cambia el tamaño de los números de ambos ejes
% xlabel('Time [s]', 'Interpreter','latex', FontSize=24);
% ylabel('Displacement [m]', 'Interpreter','latex', FontSize=24);
% %title('Case 1 training signal', 'Interpreter','latex', FontSize=24)
% legend('Tracking Signal', "Plant's Response", 'Interpreter','latex',  FontSize=24)
% yticks(-0.005:0.001:0.005);
% ylim([-5e-3 5e-3])

%subplot(3, 1, 2);
% signal_sum_cases = [input_case_sum'; resp_case_sum'];
% save('signal_sum_cases.mat', 'signal_sum_cases');
% figure(1)
% plot(time_function, input_case_sum, 'black', 'LineWidth', 1.5);
% hold on
% plot(time_function, resp_case_sum, 'c--', 'LineWidth', 1.5);
% hold off
% set(gca, 'FontSize', 18); 
% xlabel('Time [s]', 'Interpreter','latex', FontSize=20);
% ylabel('Displacement [m]', 'Interpreter','latex', FontSize=20);
% yticks(-0.005:0.001:0.005);
% ylim([-5e-3 5e-3])

% load('signal_khja.mat')
% 
% 
% subplot(3, 1,3);
% plot(time_function, signal_khja(1,1:163841), 'black', 'LineWidth', 1.5);
% hold on
% plot(time_function, signal_khja(2,1:163841), 'c--', 'LineWidth', 1.5);
% hold off
% xlabel('Time', 'Interpreter','latex', FontSize=20);
% ylabel('Displacement', 'Interpreter','latex', FontSize=20);
% title('Training signal KANAI-TAJIMI', 'Interpreter','latex', FontSize=20)
% ylim([-5e-3 5e-3])



%% kanai-tajimi
% 
% %load senal_sismica_filtrada.mat
load signal_1.mat
signal = data(1:length(time_function)-1)/max(data);
signal = signal * 5e-3;
%relative_displacement = relative_displacement .* ( exp(-0.02*time_function(1:end-1)) .* cos(0.15*time_function(1:end-1)));
%relative_displacement = relative_displacement .* exp(0.05*time_function(1:end-1));
%signal = (relative_displacement / max(relative_displacement))*4e-3;
resp_case_kanai = lsim(G_plant, signal, time_function(1:end-1));


signal_1_case_kanai = [signal'; resp_case_kanai'];
save('signal_1_case_kanai.mat', 'signal_1_case_kanai');


hold on
% plot(time_function, input_case_sum, 'black', 'LineWidth', 1.5);
plot(time_function(1:end-1), signal, 'black', 'LineWidth', 1.5);
plot(time_function(1:end-1), resp_case_kanai, 'c--',  'LineWidth', 1.5);
hold off
set(gca, 'FontSize', 18);       % Cambia el tamaño de los números de ambos ejes
xlabel('Time [s]', 'Interpreter','latex', FontSize=24);
ylabel('Displacement [m]', 'Interpreter','latex', FontSize=24);

%legend('Tracking Signal', "Plant's Response", 'Interpreter','latex',  FontSize=24)
yticks(-0.005:0.001:0.005);
ylim([-5e-3 5e-3])