
clc; clear; close all;

%%
set_NRparameters
%%
load '../data1/pilot.mat'
load '../data1/example_64Tc.mat'

xf = pilot;
yf = example_64Tc;

angle_f = angle(yf ./ xf);
angle_f_unwrap = unwrap(angle_f);  

angle_f_slope = diff(angle_f_unwrap);

group_delay = -1 * angle_f_slope / (2*pi) / (subcarrier_each_comb * subcarrier_spacing);
group_delay_Tc = group_delay / Tc;
group_delay_Tc = mean(group_delay_Tc);
