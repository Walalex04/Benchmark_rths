load Plant;
load matlab.mat

tt = 0:dt_rth   s:40*dt_rths;
desp = desplazamiento_input.Data;
tt = desplazamiento_input.Time;


%input signal
amp1 = 1;
amp2 = 10;

frec1 = 15;
frec2 = 2;

signal1 = amp1 * sin(2 * pi * frec1 * tt);
signal2 = amp2 * sin(2*pi*frec2*tt);
ruido = 0.1 * randn(size(tt)); %ruido

input_signal = decay .* (signal1 + signal2 + ruido);


[y_p, y, x] =  lsim(G_plant, desp,tt);
% 
% save('data_input.mat','desp');
% save('response_actuator.mat', 'y_p');

figure(1)
p1 = plot([0 tt(end)],[1 1],'k--','linewidth',1.2); grid on, hold on
p2 = plot(tt,y_p,'color',b_d,'linewidth',2);
p3 = plot(tt,desp,'color',[1,0,0],'linewidth',2);
ylabel('Amplitude ','fontsize',12,'fontweight','bold')
xlabel('Time [sec]','fontsize',12,'fontweight','bold')

%en base a los datos se tiene un error de amplitud de 0.62
%y ademas un delay de 15ms

%se obtendra los valores iniciales medidos

A = 10.09 / 10.74; 
a_0k = 1/A;

delay = 15e-3;
a_1k = delay * a_0k;

disp('los coeficientes son ')
a_0k
a_1k

%se obtendra los coeficientes con el algoritmo de minimos cuadrados
%Obteniendo los incrementos



