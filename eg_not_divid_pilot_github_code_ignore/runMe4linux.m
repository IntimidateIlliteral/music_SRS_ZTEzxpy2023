

%%
close all;
clc;
clear;
addpath(genpath('../'))

%% 右边变量，在sh脚本中赋值.
data_id_you_want = linux_input_column;
toggle_yf_use_model_of_your_own = linux_input_toggle;

%%
[pmusic_est, group_delay_Tc, mpm_LOS] = main(data_id_you_want, toggle_yf_use_model_of_your_own);


%%
figure; plot(pmusic_est);     hold on; plot([ mpm_LOS],pmusic_est([ mpm_LOS]),'x')
figure; semilogy(pmusic_est); hold on; plot([ mpm_LOS],pmusic_est([ mpm_LOS]),'x')