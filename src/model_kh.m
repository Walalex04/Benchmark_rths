function [T,GA,window] = ca6eq(wg,zg)
% CA6EQ Generate random earthquake given local ground parameters.
%
% [T,GA] = ca6eq(wg,zg) generates a time vector T and a ground acceleration
% vector GA for a random earthquake given the local
% ground conditions (wg is the ground natural frequency
% and zg is the ground damping ratio).
%
% This function assumes an earthquake duration of 30 secs, with a quadratic
% ramp-up over the first 3 seconds and an exponential decay over the last
% 21 seconds. The frequency content is based on a Kanai-Tajimi model with
% the given (wg,zg) values.
%
% This program is part of CA6 for CE331.
%
% See also: ca6bldg
% Copyright (c)1998, Erik A. Johnson <johnsone@nd.edu>, 11/30/98
% CHECK SANITY OF INPUTS
if nargin<2,
error('Need both wg (ground nat. freq.) and zg (ground damping ratio)');
elseif prod(size(wg))~=1 | prod(size(zg))~=1,
error('Both wg and zg must be scalars');
end;
% INPUTS
Tmax = 45; % duration of earthquake
T1 = 20; % duration of quadratic ramp-up
T2 = 20; % end of constant
a = 1/7; % decay rate
dt = 2.4716e-04; % time step
n = round(Tmax/dt); % number of points in acceleration record
% MAKE TIME VECTOR
T = Tmax * (0:n)'/n;
% GENERATE NORMALLY DISTRIBUTED RANDOM DATA
RanAcc = randn(n+1,1); % random data
% FORM KANAI-TAJIMI EARTHQUAKE SPECTRUM
numeq = [2*zg*wg wg^2];
deneq = [1 2*zg*wg wg^2];
[Aeq,Beq,Ceq,Deq] = tf2ss(numeq,deneq);
[GA] = lsim(Aeq,Beq,Ceq,Deq,RanAcc,T);
% COMPUTE WINDOWING FUNCTION
window = ones(size(T)); % constant part, T1<=t<=T2
window(T<T1) = T(T<T1).^2/T1^2; % ramp-up part, t<T1
window(T>T2) = exp(-a*(T(T>T2)-T2)); % exponential decay part, t>T2
% APPLY WINDOWING FUNCTIONS TO SIGNAL
GA = GA .* window;
end



omega_g = (2) * 2*pi; % local ground natural frequency
zeta_g = 0.5; % local ground damping ratio
[time, ground_accel] = ca6eq(omega_g, zeta_g);

ground_accel = ground_accel / max(ground_accel);
ground_accel = ground_accel * 4.5e-3;




load Plant.mat 
sampling_time = 1/4096;
t_duraction = 40; %seconds
time_function = 0:sampling_time:40;
resp_kh = lsim(G_plant, ground_accel, time); %response c1

plot( time, ground_accel, 'b--', 'LineWidth',1.5);
hold on
plot( time, resp_kh, 'LineWidth',1.5);
hold off
xlabel('Time'); ylabel('ground acceleration');


signal_khja = [ground_accel'; resp_kh'];
save('signal_khja.mat', 'signal_khja');