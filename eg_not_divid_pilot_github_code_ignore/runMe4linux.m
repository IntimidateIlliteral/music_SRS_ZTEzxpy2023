

%%
close all;
clc;
% clear;
addpath(genpath('../'))

%% 右边变量，在sh脚本中赋值.
data_id_you_want = linux_input_column;
toggle_yf_use_model_of_your_own = linux_input_toggle;

%%
[pmusic_est, group_delay_Tc, mpm_LOS] = main(data_id_you_want, toggle_yf_use_model_of_your_own);


%%
p1save = strcat('pmusic_est', string(data_id_you_want));
g1save = strcat('group_delay_Tc', string(data_id_you_want));
save(p1save, 'pmusic_est');
save(g1save, 'group_delay_Tc');
disp(group_delay_Tc);
