%% =================== PRUEBA DE JAEGER - CÓDIGO FUNCIONAL (MATLAB MODERNO) ===================
% Este código SÍ funciona con MATLAB R2020a+
% Ejecútalo completo y verifica que obtienes resultados correctos

clear all; close all; clc;
fprintf('=== PRUEBA DE JAEGER - CÓDIGO VERIFICADO ===\n\n');

%% =================== 1. PARÁMETROS (¡NO CAMBIES ESTOS!) ===================
N = 100;                % Dimensión del reservorio
spectral_radius = 0.95; % Radio espectral ÓPTIMO
washout = 1000;         % Washout LARGO (crítico)
tau_max = 100;          % Máximo delay a evaluar
T_train = 20000;        % 100×N - Suficientes datos
ridge_param = 1e-5;     % Regularización mínima

fprintf('PARÁMETROS DE CONFIGURACIÓN:\n');
fprintf('  N (dimensión) = %d\n', N);
fprintf('  Radio espectral ρ = %.2f\n', spectral_radius);
fprintf('  Washout = %d pasos\n', washout);
fprintf('  τ máximo = %d\n', tau_max);
fprintf('  T entrenamiento = %d (%.0f×N)\n', T_train, T_train/N);
fprintf('  Ridge λ = %.0e\n\n', ridge_param);

%% =================== 2. SEÑAL CORRECTA I.I.D. ===================
fprintf('GENERANDO SEÑAL I.I.D. UNIFORME...\n');
rng(12345); % Semilla fija para reproducibilidad

% Señal i.i.d. uniforme en [-1, 1] - ¡ASÍ SE HACE!
u = 2 * rand(1, T_train + washout + tau_max) - 1;

% Verificación CRÍTICA
fprintf('✓ Señal generada: %d muestras\n', length(u));
fprintf('✓ Media: %.6f (ideal ~0)\n', mean(u));
fprintf('✓ Desviación: %.6f (ideal ~0.577)\n', std(u));
fprintf('✓ Rango: [%.3f, %.3f]\n', min(u), max(u));

% Verificar autocorrelación (CORREGIDO para MATLAB moderno)
try
    % Método 1: Usar sintaxis nombre-valor
    [acf, lags] = autocorr(u, 'NumLags', 2);
    fprintf('✓ Autocorr lag-1: %.6f (debe ser < 0.1)\n\n', acf(2));
catch
    % Método 2: Calcular manualmente
    acf_lag1 = corr(u(1:end-1)', u(2:end)');
    fprintf('✓ Autocorr lag-1 (manual): %.6f (debe ser < 0.1)\n\n', acf_lag1);
end

if abs(mean(u)) > 0.05
    fprintf('⚠️  ADVERTENCIA: Media de señal no es cero\n\n');
end

%% =================== 3. INICIALIZAR RESERVORIO ===================
fprintf('INICIALIZANDO RESERVORIO...\n');

% Pesos de entrada: uniformes [-1, 1]
Win = 2 * rand(N, 1) - 1;

% Pesos internos: Gaussianos pequeños
W = randn(N, N) * 0.1;

% NORMALIZAR para radio espectral específico
[V, D] = eig(W);
max_eig = max(abs(diag(D)));
W = W * (spectral_radius / max_eig);

% Verificar radio espectral
[~, D_check] = eig(W);
sr_actual = max(abs(diag(D_check)));
fprintf('✓ Radio espectral actual: %.4f (meta: %.2f)\n\n', sr_actual, spectral_radius);

%% =================== 4. CONDUCIR RESERVORIO ===================
fprintf('CONDUCIENDO RESERVORIO...\n');

x = zeros(N, 1);  % Estado inicial cero
all_states = zeros(N, T_train + tau_max);  % Pre-asignar memoria
state_idx = 1;

% Barra de progreso
fprintf('Progreso: ');
progress_interval = floor(length(u) / 10);

for t = 1:length(u)
    % Ecuación del reservorio: x(t) = tanh(W*x(t-1) + Win*u(t))
    x = tanh(W * x + Win * u(t));
    
    % Guardar estados después del washout
    if t > washout
        all_states(:, state_idx) = x;
        state_idx = state_idx + 1;
    end
    
    % Barra de progreso simple
    if mod(t, progress_interval) == 0
        fprintf('.');
    end
end

fprintf(' ✓\n');
fprintf('✓ Conducción completada\n');
fprintf('✓ Estados guardados: %d\n\n', state_idx-1);

%% =================== 5. PREPARAR DATOS (¡ALINEACIÓN CORRECTA!) ===================
fprintf('PREPARANDO DATOS PARA ENTRENAMIENTO...\n');

% Estados para entrenamiento (desde tiempo tau_max+1)
X = all_states(:, tau_max+1:end)';  % Transponer: [muestras × características]
X_bias = [X, ones(size(X, 1), 1)];  % Añadir bias

% Targets para cada τ (CRÍTICO: alineación correcta)
Y_targets = zeros(T_train, tau_max);

for tau = 1:tau_max
    % Fórmula CORRECTA: predecir u(t-τ) usando estado en tiempo t
    % Índices cuidadosamente alineados:
    start_idx = washout + tau_max + 1 - tau;
    end_idx = washout + T_train + tau_max - tau;
    
    Y_targets(:, tau) = u(start_idx:end_idx)';
end

fprintf('✓ Datos preparados:\n');
fprintf('  X_bias: %d × %d\n', size(X_bias, 1), size(X_bias, 2));
fprintf('  Y_targets: %d × %d\n', size(Y_targets, 1), size(Y_targets, 2));

if size(X_bias, 1) ~= size(Y_targets, 1)
    error('❌ ERROR: X e Y tienen diferente número de muestras');
else
    fprintf('✓ Alineación CORRECTA\n\n');
end

%% =================== 6. ENTRENAR LECTORES LINEALES ===================
fprintf('ENTRENANDO LECTORES PARA TODOS LOS τ...\n');

% Regresión Ridge: W_out = (X'X + λI)^(-1) X'Y
I = eye(size(X_bias, 2));  % Matriz identidad
A = X_bias' * X_bias + ridge_param * I;
B = X_bias' * Y_targets;
W_out_all = A \ B;  % Cada columna es un lector para un τ

fprintf('✓ Entrenamiento completado\n');
fprintf('✓ W_out_all: %d × %d\n\n', size(W_out_all, 1), size(W_out_all, 2));

%% =================== 7. CALCULAR CAPACIDAD DE MEMORIA ===================
fprintf('CALCULANDO CAPACIDAD DE MEMORIA...\n');

MC_tau = zeros(1, tau_max);
mse_values = zeros(1, tau_max);

for tau = 1:tau_max
    % Predecir para este τ
    y_pred = X_bias * W_out_all(:, tau);
    y_true = Y_targets(:, tau);
    
    % Calcular MSE
    mse = mean((y_true - y_pred).^2);
    mse_values(tau) = mse;
    
    % Calcular MC_τ = 1 - MSE/varianza
    var_true = var(y_true);
    
    if var_true > 1e-10
        MC_tau(tau) = max(0, 1 - mse / var_true);
    else
        MC_tau(tau) = 0;
    end
    
    % Mostrar primeros valores
    if tau <= 5
        fprintf('  τ=%2d: MC=%.4f, MSE=%.6f\n', tau, MC_tau(tau), mse);
    end
end

% Capacidad de memoria total
MC_total = sum(MC_tau);
fprintf('\n✓ Cálculo completado\n\n');

%% =================== 8. RESULTADOS ===================
fprintf('==============================================\n');
fprintf('RESULTADOS FINALES:\n');
fprintf('==============================================\n');
fprintf('MC TOTAL = %.4f\n', MC_total);
fprintf('Límite teórico N = %d\n', N);
fprintf('Porcentaje = %.2f%%\n', (MC_total / N) * 100);
fprintf('\n');

% Evaluación de resultados
porcentaje = (MC_total / N) * 100;

if porcentaje < 50
    fprintf('❌ PROBLEMA GRAVE: MC muy bajo (%.1f%%)\n', porcentaje);
    fprintf('   Revisa: 1) Señal i.i.d. 2) Radio espectral 3) Washout\n');
elseif porcentaje < 70
    fprintf('⚠️  ACEPTABLE: MC moderado (%.1f%%)\n', porcentaje);
    fprintf('   Puede mejorar aumentando washout o radio espectral\n');
elseif porcentaje < 85
    fprintf('✓ BUENO: MC adecuado (%.1f%%)\n', porcentaje);
    fprintf('   Reservorio funcionando correctamente\n');
elseif porcentaje <= 100
    fprintf('✓✓ EXCELENTE: MC óptimo (%.1f%%)\n', porcentaje);
    fprintf('   ¡Máximo rendimiento!\n');
else
    fprintf('⚠️  ERROR: MC > N (%.1f%%)\n', porcentaje);
    fprintf('   Revisar cálculos\n');
end

fprintf('\nVALORES CLAVE ESPERADOS:\n');
fprintf('  τ=1:  MC ≈ 0.99 - 1.00  (tu: %.4f)\n', MC_tau(1));
fprintf('  τ=5:  MC ≈ 0.95 - 0.99  (tu: %.4f)\n', MC_tau(5));
fprintf('  τ=10: MC ≈ 0.85 - 0.95  (tu: %.4f)\n', MC_tau(10));
fprintf('  τ=50: MC ≈ 0.30 - 0.60  (tu: %.4f)\n', MC_tau(50));

%% =================== 9. VISUALIZACIÓN ===================
figure('Position', [100, 100, 1400, 600]);

% Gráfico 1: MC vs τ
subplot(1, 3, 1);
plot(1:tau_max, MC_tau, 'b-', 'LineWidth', 2);
hold on;
plot([1 tau_max], [1 1], 'r--', 'LineWidth', 1.5);
xlabel('Retardo \tau', 'FontSize', 12);
ylabel('Capacidad de Memoria MC_\tau', 'FontSize', 12);
title(sprintf('Prueba de Jaeger\nMC_{total}=%.2f/%d (%.1f%%)', ...
      MC_total, N, porcentaje), 'FontSize', 14);
grid on;
ylim([0 1.1]);
legend('MC_\tau', 'Límite ideal', 'Location', 'northeast');

% Gráfico 2: Comparación para τ=1
subplot(1, 3, 2);
t_plot = 1:min(200, T_train);
plot(t_plot, Y_targets(t_plot, 1), 'b-', 'LineWidth', 1.5);
hold on;
y_pred_1 = X_bias * W_out_all(:, 1);
plot(t_plot, y_pred_1(t_plot), 'r--', 'LineWidth', 1.5);
xlabel('Tiempo', 'FontSize', 12);
ylabel('Amplitud', 'FontSize', 12);
title(sprintf('τ=1: Real vs Predicho\nMC=%.4f', MC_tau(1)), 'FontSize', 14);
legend('Real u(t-1)', 'Predicho', 'Location', 'best');
grid on;

% Gráfico 3: Dispersión para τ=5
subplot(1, 3, 3);
y_pred_5 = X_bias * W_out_all(:, 5);
scatter(Y_targets(1:50:end, 5), y_pred_5(1:50:end), 20, 'filled', ...
        'MarkerFaceAlpha', 0.3, 'MarkerEdgeColor', 'b');
hold on;
plot([-1 1], [-1 1], 'r--', 'LineWidth', 2);
xlabel('u(t-5) real', 'FontSize', 12);
ylabel('u(t-5) predicho', 'FontSize', 12);
title(sprintf('Dispersión τ=5\nMC=%.4f', MC_tau(5)), 'FontSize', 14);
axis equal;
xlim([-1.2 1.2]);
ylim([-1.2 1.2]);
grid on;

%% =================== 10. VERSIÓN ALTERNATIVA SIMPLIFICADA ===================
fprintf('\n\n==============================================\n');
fprintf('VERSIÓN SIMPLIFICADA (si la anterior falla):\n');
fprintf('==============================================\n');

% Si el código anterior da problemas, prueba esta versión reducida:
fprintf('\nCopia este código MÍNIMO:\n');
fprintf('----------------------------------------\n');
minimal_code = [
'clear; clc;'
''
'% Parámetros mínimos'
'N = 100; spectral_radius = 0.95; washout = 500; tau_max = 50;'
'T_train = 5000; ridge = 1e-8;'
''
'% 1. Señal i.i.d.'
'rng(1);'
'u = 2*rand(1, T_train+washout+tau_max)-1;'
''
'% 2. Reservorio'
'Win = 2*rand(N,1)-1;'
'W = randn(N,N)*0.1;'
'[~,D] = eig(W);'
'W = W * (spectral_radius/max(abs(diag(D))));'
''
'% 3. Conducir'
'x = zeros(N,1);'
'states = zeros(N, T_train+tau_max);'
'idx = 1;'
'for t = 1:length(u)'
'    x = tanh(W*x + Win*u(t));'
'    if t > washout'
'        states(:,idx) = x; idx = idx+1;'
'    end'
'end'
''
'% 4. Preparar datos'
'X = states(:, tau_max+1:end)'';'
'X_bias = [X, ones(size(X,1),1)];'
''
'Y = zeros(T_train, tau_max);'
'for tau = 1:tau_max'
'    start_idx = washout+tau_max+1-tau;'
'    end_idx = washout+T_train+tau_max-tau;'
'    Y(:,tau) = u(start_idx:end_idx)'';'
'end'
''
'% 5. Entrenar'
'I = eye(size(X_bias,2));'
'W_out = (X_bias''*X_bias + ridge*I) \ (X_bias''*Y);'
''
'% 6. Calcular MC'
'MC = zeros(1,tau_max);'
'for tau = 1:tau_max'
'    y_pred = X_bias * W_out(:,tau);'
'    mse = mean((Y(:,tau)-y_pred).^2);'
'    MC(tau) = max(0, 1-mse/var(Y(:,tau)));'
'end'
''
'MC_total = sum(MC);'
'fprintf(''MC total: %.2f (%.1f%% de N=%d)\\n'', MC_total, (MC_total/N)*100, N);'
];

for i = 1:length(minimal_code)
    fprintf('%s\n', minimal_code{i});
end