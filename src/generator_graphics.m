%IN THIS SCRPT I WILL GENERATE ALL GRAPHICS FOR THE PAPER

%% COMPARATION BEWTEEN ADAPTAIVE AND NOT ADAPTATIVE METHOD

% %without adaptation stage
% results_case1_case1 = [0 3.73 4.17 4.28 3.76 3.6 3.58 2.19 2.27];
% results_case1_case2 = [0 3.88 4.16 4.91 3.98 4.59 4.56 2.77 2.93];
% results_case1_case3 = [0 3.76 5.31 9.53 7.83 10.22 10.2 7.03 7.22];
% results_case1_case4 = [0 3.3 4.1 6.15 5.1 5.93 5.93 3.39 3.37];
% 
% 
% results_casesum_case1 = [0 3.81 15.2 3.84 14.86 2.47 2.46 1.53 1.56];
% results_casesum_case2 = [0 3.86 14.54 4.24 14.33 3.38 3.35 2.03 2.16];
% results_casesum_case3 = [0 3.59 10.54 7.9 10.53 8.37 8.35 5.85 6];
% results_casesum_case4 = [0 3.26 13.55 4.46 13.22 3.83 3.83 2.3 2.29];
% 
% %wit adaptation stage
% results_case1ad_case1 = [0.2 3.2 3.33 4.52 3.92 3.59 3.59 2.04 1.96];
% results_case1ad_case2 = [0.5 3.23 3.65 5.1 4.11 4.46 4.45 2.96 2.99];
% results_case1ad_case3 = [0.5 2.64 3.86 7.84 7.19 7.84 7.84 6.35 6.19];
% results_case1ad_case4 = [0.2 2.74 3.07 6.14 5.28 5.64 5.65 3.92 3.88];
% 
% 
% results_casesumad_case1 = [0.2 3.49 15.09 4.68 14.86 3.31 3.31 1.76 1.82];
% results_casesumad_case2 = [0.2 3.44 14.45 5.07 14.33 4.04 4.03 2.66 2.67];
% results_casesumad_case3 = [0.2 2.67 10.45 6.69 10.53 6.46 6.46 5.2 5.1];
% results_casesumad_case4 = [0.2 2.93 13.46 5.92 13.22 5.13 5.15 3.53 3.46];

results_case1ad_case1 = [0.2 3.2 3.33 4.52 3.92 3.59 3.59 2.04 1.96];
results_case1ad_case2 = [0.5 3.23 3.65 5.1 4.11 4.46 4.45 2.96 2.99];
results_case1ad_case3 = [0.5 2.64 3.86 7.84 7.19 7.84 7.84 6.35 6.19];
results_case1ad_case4 = [0.2 2.74 3.07 6.14 5.28 5.64 5.65 3.92 3.88];


results_casesumad_case1 = [0.2 3 3.7 4.04 3.66 2.89 2.89 1.68 1.7];
results_casesumad_case2 = [0.2 2.96 3.54 4.36 3.79 3.48 3.48 2.33 2.36];
results_casesumad_case3 = [0.2 2.37 3.51 6.35 5.99 6.21 6.21 5.01 4.9];
results_casesumad_case4 = [0.2 2.49 3.3 5.25 4.24 4.63 4.64 3.05 3.06];

secciones = {'J1','J2','J3','J4', 'J5','J6','J7','J8', 'J9'};

figure;

ymin = 0;
ymax = 8;

% subplot(4,1,1);
hold on;

% plot(results_case1_case1, '-o', 'DisplayName', 'Método A', 'LineWidth',1.5);
% plot(results_casesum_case1, '-s', 'DisplayName', 'Método B', 'LineWidth',1.5);
% plot(results_case1ad_case1, '-^', 'DisplayName', 'Using First Signal', 'LineWidth',1.5);
% plot(results_casesumad_case1, '-d', 'DisplayName', 'Using Second Signal', 'LineWidth',1.5);
% set(gca, 'FontSize', 18); 
% xticks(1:9);
% xticklabels(secciones);
% xlabel('Indicators','Interpreter','latex', FontSize=20);
% ylabel('Measured','Interpreter','latex', FontSize=20);
% ylim([ymin ymax]);
% legend('Location', 'best');
% grid on;
% hold off;

% 
% subplot(4,1,2);
% 
hold on;

% plot(results_case1_case2, '-o', 'DisplayName', 'Método A', 'LineWidth',1.5);
% plot(results_casesum_case2, '-s', 'DisplayName', 'Método B', 'LineWidth',1.5);
% plot(results_case1ad_case2, '-^', 'DisplayName', 'Método C', 'LineWidth',1.5);
% plot(results_casesumad_case2, '-d', 'DisplayName', 'Método D', 'LineWidth',1.5);
% set(gca, 'FontSize', 18); 
% xticks(1:9);
% xticklabels(secciones);
% xlabel('Indicators','Interpreter','latex', FontSize=20);
% ylabel('Measured','Interpreter','latex', FontSize=20);
% ylim([ymin ymax]);
% 
% grid on;
% hold off;

% 
% subplot(4,1,3);

hold on;
set(gca, 'FontSize', 18); 
% 
% plot(results_case1_case3, '-o', 'DisplayName', 'Método A', 'LineWidth',1.5);
% plot(results_casesum_case3, '-s', 'DisplayName', 'Método B', 'LineWidth',1.5);
% plot(results_case1ad_case3, '-^', 'DisplayName', 'Método C', 'LineWidth',1.5);
% plot(results_casesumad_case3, '-d', 'DisplayName', 'Método D', 'LineWidth',1.5);
% 
% xticks(1:9);
% xticklabels(secciones);
% xlabel('Indicators','Interpreter','latex', FontSize=20);
% ylabel('Measured','Interpreter','latex', FontSize=20);
% ylim([ymin ymax]);
% 
% grid on;
% hold off;
% 
% 
% 
% subplot(4,1,4);

hold on;
set(gca, 'FontSize', 18); 
% plot(results_case1_case4, '-o', 'DisplayName', 'Método A', 'LineWidth',1.5);
% plot(results_casesum_case4, '-s', 'DisplayName', 'Método B', 'LineWidth',1.5);
plot(results_case1ad_case4, '-^', 'DisplayName', 'Método C', 'LineWidth',1.5);
plot(results_casesumad_case4, '-d', 'DisplayName', 'Método D', 'LineWidth',1.5);

xticks(1:9);
xticklabels(secciones);
xlabel('Secciones');
xlabel('Indicators','Interpreter','latex', FontSize=20);
ylabel('Measured','Interpreter','latex', FontSize=20);

grid on;
hold off;