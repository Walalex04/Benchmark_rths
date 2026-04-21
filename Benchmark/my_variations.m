
%% print all with diferents perturbation of the mass

clc, clear, close all
variation = 0:0.001:0.4;

measures = zeros(length(variation), 9);
index = 1;
for i=variation
   m_e = 29.13 +  i*29.13;
   RUN_vRTHS_demo
    measures(index,:) = eval_crit;
    index = index+1;
    
end

save('values.mat', 'measures');