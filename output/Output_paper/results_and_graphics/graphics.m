



set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');
set(groot, 'defaultTextInterpreter', 'latex');

font_size = 20;
line_width = 1.5;
font_size_legent = 18;

%% GRAPHICS

load Data_rc_sim_64_0.99_adp4.mat


results = Num_resp.data;
ref_resp = Ref_Resp;

figure(1)
title("Results of the case 1 (X2)");

g1 = plot(t, results(:, 1), 'black', 'LineWidth',line_width);
hold on;
g2 = plot(t, ref_resp(:, 1),'r--', 'LineWidth',line_width);
hold off;

xlabel('Time [s]', "FontSize", font_size);
ylabel('Displacement [m]', "FontSize", font_size);
    
%legend({"Response", "Reference Response"}, ...
%    'Location', 'best', 'Fontsize', font_size_legent, 'Box', 'off');

axis([0 40 -4.6e-3 4.6e-3]);
 
%axis([0 40 -6e-3 6e-3]);
%axis([0 40 -8.5e-3 8.5e-3]);

grid on;
grid minor;

ax = gca;
ax.FontSize = font_size;
ax.Box = 'on';
ax.LineWidth = 1;


%% graphins with perturbation


%printing the mean, std, max, min of the value

num_pert = 10;
indicator = zeros([num_pert, 9]);
full_data = zeros([num_pert, 168674]);
for i = 1:num_pert
    name = 'Data_rc_sim_64_0.99_adp4_Pert_' + string(i);
    load(name);

    indicator(i,:) = eval_crit;
    full_data(i, :) = Num_resp.data(:, 1);
end

disp(["the mean of all results are"]);
disp(mean(indicator))

disp(["the std of all results are"]);
disp(std(indicator))

disp(["the max of all results are"]);
disp(max(indicator))


disp(["the min of all results are"]);
disp(min(indicator))



figure(2)


%g1 = plot(t, results(:, 1), 'black', 'LineWidth',line_width);

hold on;
line_width = 0.6;
for i = 1:num_pert
    g2 = plot(t, full_data(i, :),'Color', [0.45 0.45 0.45], 'LineWidth',line_width+1);
end
g1 = plot(t, Ref_Resp(:, 1),'black', 'LineWidth',line_width);
hold off;

xlabel('Time [s]', "FontSize", font_size);
ylabel('Displacement [m]', "FontSize", font_size);
    
%legend({"Response", "Reference Response"}, ...
%    'Location', 'best', 'Fontsize', font_size_legent, 'Box', 'off');

axis([8 20 -4e-3 4e-3]);
 
%axis([0 40 -6e-3 6e-3]);
%axis([0 40 -8.5e-3 8.5e-3]);

grid on;
grid minor;

ax = gca;
ax.FontSize = font_size;
ax.Box = 'on';
ax.LineWidth = 1;


%% ploting measures 

load measures_woutadp.mat

variation = 0:0.001:0.4;
plot(variation, measures(:, 5));

axis([-0.4 0.4 0 100]);