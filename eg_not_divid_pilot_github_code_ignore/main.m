close all;
clc;
clear;
%%
set_NRparameters
%%
load '../data1/pilot.mat'

data_id_you_want = 1;  % dataSet 1~400
load(strcat('../data1/ant1_data', string(data_id_you_want), '.mat'));

%% output_

% fid = fopen('delay_test.txt','w');
% fprintf(fid,'%.2f,\n', group_delay);
% fclose(fid);

%%
xf = pilot;
%
toggle_yf_use_model_of_your_own = 0;
%% yf2 as input for covariance matrix
if toggle_yf_use_model_of_your_own == 1
    %% x: model of my own
    Msig1 = 2;
    d_omg = 2*pi ./ [144.3524, 72.1762, 36.88, 99, 87, 62].';
    % mildly alter the d_omg of LOS, i.e. d_omg(1), by 1e-3 or so.
    % to verify remaining issue 1
    mild = 516*2^8*1e-7;  % 416~516~616
    d_omg(1) = d_omg(1)*(1 + mild);
    amp = [1, 0.17, 0.11, 0.07, 0.32, 0.23, 0.11].';

    yf2 = my_own_model4MUSICinput(Msig1, d_omg, amp, NSRScomb4);
    scatterplot(yf2)
else
    yf = ant1_data;
    yf222 = yf .* conj(xf);
    yf2 = yf222;
end

scatterplot(yf2(:));
%% fbss  L-sub_sensor_array
L = 400;
% Msig = 6;
% L = Msig+1;
yf2_fbss = fbssMy(yf2, L);
sampleCovarianceMatrix = cov(yf2_fbss);

%%
[Vb, Db] = eig(sampleCovarianceMatrix);
los1 = Vb(:,end);
scatterplot(los1); grid on;
los1omgd = mean(diff(unwrap(angle(los1))));

[L, Mb] = size(yf2_fbss);
zuiduo = 20;  % paths. highly unlikely more than 20 paths, zuiduo20.
Msig = how_many_sigs(sampleCovarianceMatrix, Mb, L, zuiduo);

%%
Mnoise = Mb - Msig;
G = Vb(:, 1:Mnoise );  % Null_space = noise_subspace. Linear Algebra;

%%
up_boundary600 = 160/4096;  % 160: 0~600 Tc
angle_sa0 = 4096*2^2;
resolution_omg = 2*pi/angle_sa0;
angle_sa = floor(angle_sa0*up_boundary600);
p2 = zeros(angle_sa, 1);
pm = zeros(angle_sa, 1);

awb =   @(omg) (exp(1j* omg .* (0:(Mb-1)) )).';
pmusic = @(omg) 1 / (awb(omg)' *(G*G')     * awb(omg)) ;


pcapon = @(omg) 1 / (awb(omg)' * cov1^(-1) * awb(omg));
for id = 0:(-1+angle_sa)
    dphase = id * resolution_omg;
    pm(id+1) = pmusic(dphase);
end
pm = abs(pm);
% todo: use findpeaks() instead
% todo: find first Msig peaks
dpm = diff(pm);
l = length(dpm);
dpm = (dpm(1:(l-1))>0) .* (dpm(2:l))<0;
jidazhidian = 1+find(dpm==1);
[b, i] = sort(pm(jidazhidian), 'descend');
jidazhidian = jidazhidian(i(1:Msig));
mpm = min(jidazhidian);
%%
Tcnm = resolution_omg*(mpm-1)/(2*pi * subcarrier_each_comb * subcarrier_spacing)/Tc;
%%
figure; plot(pm);     hold on; plot([ mpm],pm([ mpm]),'x')
figure; semilogy(pm); hold on; plot([ mpm],pm([ mpm]),'x')
