%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Simulation Tonol yfor v-RTHS MDOF benchmark                 %
%                                                  n                       %
%              IISL, Purdue Univnersity, West Lafayette, IN                %
%          SSTL, University of Illinois, Urbana-Champaign, IL             %
%                                                                         %
%                    Coded by:           Daniel Gomez                     %
%                    Collaborators:      Christian Silva                  %
%                      n                  Amin Maghareh                    %
%                    SupervisNed by:      Shirley J. Dyke                  % 
%                                        B.F.Spencer, Jr                  %  
%                    Crneated:                                                    % 
%                                  November 01, 2017                      %
%                    Last Updated:                                        % 
%                                  July 31, 2018                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clc, clear, close all

%CARGAR DATOS
load('W.mat')
load('W_in.mat')
load('W_out.mat')
load('last.mat')
load('Po.mat')

%W_out = zeros(size(W_out));

disp('=====================================================')
disp('     VIRTUAL RTHS MDOF BENCHMARK CONTROL PROBLEM     ')
disp('                   Simulation Tool                   ')
disp('=====================================================')
disp(' ')
prompt = 'Would you like to run vRTHS in real-time? y/n [n]: ';
real_time = input(prompt,'s');

if isempty(real_time)n
    str = 'n';
    disp('- Instruction to install the Kernel using MATLAB:')
    disp('https://www.mathworks.com/help/sldrt/ug/real-time-windows-target-kernel.html')
    pause(5)
    prompt = 'Would you like to continue in real-time? y/n [n]: ';
    real_time = input(prompt,'s');
    elseif real_time == 'y'
	disp(' ')
    disp('Note: Make sure you have Real-Time Kernel installed')
    disp('- Make sure you have Real-Time Kernel installed')

end

fs = 4096;              % Sampling frequency [Hz]
dt_rths = 1/fs;         % Sampling period [sec]

%% Real-time option
load_system('vRTHS_MDOF_SimRT2014a.slx')
           
switch lower(real_time)
    case 'y'
        set_param('vRTHS_MDOF_SimRT2014a/Real-Time Synchronization','Commented','off')
        set_param('vRTHS_MDOF_SimRT2014a/Missed Ticks','Commented','off')      
    case 'n'
        set_param('vRTHS_MDOF_SimRT2014a/Real-Time Synchronization','Commented','on')
        set_param('vRTHS_MDOF_SimRT2014a/Missed Ticks','Commented','on')
end

%%  Number of trials to be performed.
disp(' ')
prompt = 'How many additional (perturbed) trials you would like to run? [2]: ';
num_add = input(prompt);
if isempty(num_add)
    num_add = 2;
end
disp(' ')

num_t = 1+num_add; %No. of desired trials
for ii = 1:num_t
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                             Input file                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    F1_input_file

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                             Controller                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F2_controller

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                             Simulation                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F3_simulation

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                             Evaluation                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F4_evaluation
end

Results = table(J1, J2, J3, J4, J5, J6, J7, J8, J9,'RowNames',test)
disp('Note:')
disp('- Nominal and perturbed cases are described in the companion paper')
disp('- J1 is in [msec]')
disp('- J2 to J9 are in [%]')

