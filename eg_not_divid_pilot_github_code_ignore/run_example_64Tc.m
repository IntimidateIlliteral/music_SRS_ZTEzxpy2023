
clc; clear; close all;

%%
set_NRparameters
%%
load '../data1/pilot.mat'
load '../data1/example_64Tc.mat'

xf = pilot;
yf = example_64Tc;

delta_phase = angle(yf ./ xf);
delta_phase_unwrap = unwrap(delta_phase);  

slope = diff(delta_phase_unwrap);

group_delay = -1 * slope / (2*pi * subcarrier_each_comb * subcarrier_spacing);
group_delay_Tc = group_delay / Tc;
group_delay_Tc = mean(group_delay_Tc);
