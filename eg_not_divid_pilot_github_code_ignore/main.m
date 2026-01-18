close all;
clc;
clear;
addpath(genpath('../'))
%% output_
% fid = fopen('delay_test.txt','w');
% fprintf(fid,'%.2f,\n', group_delay);
% fclose(fid);
%%
set_NRparameters
%% load data
load '../data1/pilot.mat'
xf = pilot;  % NR upLink SRS, ZC sequence
%
toggle_yf_use_model_of_your_own = 1;
if toggle_yf_use_model_of_your_own
    %% x: model of my own
    MsigMy = 3;
    d_omg = 2*pi ./ [144.3524, 72.1762, 36.88, 99, 87, 62].';
    % mildly alter the d_omg of LOS, i.e. d_omg(1), by 1e-3 or so.
    % to verify remaining issue 1
    mild = 516*2^8*1e-7;  % 416~516~616
    d_omg(1) = d_omg(1)*(1 + mild);
    amp = [1, 0.17, 0.11, 0.07, 0.32, 0.23, 0.11].';

    yf2 = my_own_model4MUSICinput(MsigMy, d_omg, amp, NSRScomb4);
else
    data_id_you_want = 1;  % dataSet 1~400
    load(strcat('../data1/ant1_data', string(data_id_you_want), '.mat'));
    yf = ant1_data;
    yf2 = yf .* conj(xf);
end
%% yf2 as input for covariance matrix
scatterplot(yf2(:));

%% fbss  L-sub_sensor_array
L = 400;
% Msig = 6;
% L = Msig+1;
yf2_fbss = fbssMy(yf2, L);
[L, Mb] = size(yf2_fbss);

sampleCovarianceMatrix = cov(yf2_fbss);
%%
[Vb, Db] = eig(sampleCovarianceMatrix);
%% todo: check if the 1st eigenvector is the LOS, the relationship
los1 = Vb(:, end);
scatterplot(los1); grid on;
los1omgd = mean(diff(unwrap(angle(los1))));

%%
zuiduo = 20;  % paths. highly unlikely more than 20 paths, zuiduo20.
Msig_est = how_many_sigs(diag(Db), Mb, L, zuiduo);

Mnoise = Mb - Msig_est;
G = Vb(:, 1:Mnoise );  % Null_space = noise_subspace. Linear Algebra;

%%
%
awb =   @(omg) (exp(1j* omg .* (0:(Mb-1)) )).';
pCapon = @(omg) 1 / (awb(omg)' * cov1^(-1) * awb(omg));
pMusic = @(omg) 1 / (awb(omg)' *(G*G')     * awb(omg)) ;

%
num_angle_sa0 = 4096*2^2;
angle_resolution = 2*pi/num_angle_sa0;

up_boundary600 = 160/4096;  % 160: 0~600 Tc

num_angle_sa = floor(num_angle_sa0*up_boundary600);

pmusic_est = zeros(num_angle_sa, 1);

for thisAngleID = 0:(-1+num_angle_sa)
    thisAngle = thisAngleID * angle_resolution;
    pmusic_est(1+thisAngleID) = pMusic(thisAngle);
end
pmusic_est = abs(pmusic_est);

jidazhidian = findJiDaZhiDianMy(pmusic_est);

[b, i] = sort(pmusic_est(jidazhidian), 'descend');
jidazhidian = jidazhidian(i(1:Msig_est));  % highest Msig_est peaks

mpm_LOS = min(jidazhidian);  % first_peak -> first_path -> LOS_path
%% for LOS_path
dPhase = angle_resolution*(mpm_LOS-1);  % todo: why -1? Differs little whether -1 or not, if resolution is so high
dOmega = (2*pi * subcarrier_each_comb * subcarrier_spacing);

group_delay = dPhase/dOmega;

group_delay_Tc = group_delay / Tc;
%%
figure; plot(pmusic_est);     hold on; plot([ mpm_LOS],pmusic_est([ mpm_LOS]),'x')
figure; semilogy(pmusic_est); hold on; plot([ mpm_LOS],pmusic_est([ mpm_LOS]),'x')
