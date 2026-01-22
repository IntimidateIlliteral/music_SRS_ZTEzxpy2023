

%%
close all;
clc;
clear;
addpath(genpath('../'))

%%
data_id_you_want = 1;
toggle_yf_use_model_of_your_own = false;

%%
[pmusic_est, group_delay_Tc, mpm_LOS] = main(data_id_you_want, toggle_yf_use_model_of_your_own);


%%
figure; plot(pmusic_est);     hold on; plot([ mpm_LOS],pmusic_est([ mpm_LOS]),'x')
figure; semilogy(pmusic_est); hold on; plot([ mpm_LOS],pmusic_est([ mpm_LOS]),'x')
