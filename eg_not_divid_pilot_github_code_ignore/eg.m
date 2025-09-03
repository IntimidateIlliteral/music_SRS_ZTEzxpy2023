close all;
clc;
clear;
%%
syms s0 w0 s1 w1 s2 w2 N;
M=8; N = 50; p = 3;
s = [s0;s1;s2];
A = exp(1j*[w0,w1,w2].*(0:M-1).');
x = A*s;

%%
load '../data1/pilot.mat'
load '../data1/example_64Tc.mat'

data_id_you_want = 334;  % dataSet 1~400
% a = ['../data1/ant1_data', '333', '.mat'];
a = strcat('../data1/ant1_data', string(data_id_you_want), '.mat');
load(a);

xf = pilot;
%%
yf = example_64Tc;

n=4096;n1=816;
Tc = 1/(480 * 1000 * 4096);  % second

srs_spacing = 30e+3;         % subcarrier_spacing 30KHz

delta_phase = angle(yf ./ xf);     
delta_phase = unwrap(delta_phase);  

group_delay = -1 * diff(delta_phase) / (2*pi * 4 * srs_spacing);
group_delay_Tc = group_delay / Tc ;
group_delay_Tc = mean(group_delay_Tc) ;

%% output_

% fid = fopen('delay_test.txt','w');
% fprintf(fid,'%.2f,\n', group_delay);
% fclose(fid);

%%
Nu = 816;

Fc = 480 * 1000 * 4096;
Tc = 1/Fc;  % second

srs_spacing = 30e+3;         % subcarrier_spacing 30KHz

F = 122.88e6; % Hz

%%
xf = pilot;
yf = ant1_data;
% yf = example_64Tc;
yf222 = yf .* conj(xf);
%%
toggle_use_your_own_model = 0;
%% x: model of my own
Msig1 = 2;
tn = (1:Nu);
d_omg = 2*pi ./ [144.3524, 72.1762, 36.88, 99, 87, 62].';
% mildly alter the d_omg of LOS, i.e. d_omg(1), by 1e-3 or so.
% to verify remaining issue 1
mild = 516*2^8*1e-7;  % 416~516~616
d_omg(1) = d_omg(1)*(1 + mild);
amp = [1, 0.17, 0.11, 0.07, 0.32, 0.23, 0.11].';
Msig2 = min(Msig1,length(d_omg));
s = exp(-1*1j*d_omg(1:Msig2).*tn);
ssum = amp(1:Msig2)' * s;

noiser = 1*randn([1,Nu]); noisei = 1*randn([1,Nu]);
ratio = 2^-8;
noise = ratio*1*(noiser+1j*noisei);

x = ssum +  noise;
scatterplot(x)

%% yf2 as input for covariance matrix
if toggle_use_your_own_model == 1
    yf2 = x;
else
    yf2 = yf222;
end

scatterplot(yf2(:));
%% fbss  L-sub_sensor_array
L = 400;
% Msig = 6;
% L = Msig+1;
M0 = 816;
Mb = M0 - L + 1;
idc = (0:(L-1)).';
idr = 1:Mb;
id = idc+idr;
yf21 = yf2(id);
% cov1 = yf21*yf21';
% y1 = zeros(L,Mb);
% co = zeros(Mb,Mb,L);
% for idc = 0:(-1+L)
%     y1(idc+1,:) = yf2(idc+idr);
%     t = y1(idc+1,:).';
%     co(:,:,idc+1) = t*t';
% end
% cov2 = sum(co, 3);
cov3 = cov(yf21);

%%
[Vb, Db] = eig(cov3);
los1 = Vb(:,end);
scatterplot(los1); grid on;
los1omgd = mean(diff(unwrap(angle(los1))));

zuiduo = 20;  % paths. highly unlikely more than 20 paths, zuiduo20.
Msig = how_many_sigs(cov3, Mb, L, zuiduo);

Mnoise = Mb - Msig;
G = Vb(:, 1:Mnoise );  % noise subspace. Linear Algebra;

%%
r600 = 160/4096;  % 160: 0~600 Tc
angle_sa0 = 4096*2^4;
resolution_omg = 2*pi/angle_sa0;
angle_sa = floor(angle_sa0*r600);
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
dpm = diff(pm);
l = length(dpm);
dpm = (dpm(1:(l-1))>0) .* (dpm(2:l))<0;
jidazhidian = 1+find(dpm==1);
[b, i] = sort(pm(jidazhidian), 'descend');
jidazhidian = jidazhidian(i(1:Msig));
mpm = min(jidazhidian);
Tcnm = resolution_omg*(mpm-1)/(2*pi * 4 * srs_spacing)/Tc;

figure; plot(pm);     hold on; plot([113+1, mpm+1],pm([113+1, mpm+1]),'x')
figure; semilogy(pm); hold on; plot([113+1, mpm+1],pm([113+1, mpm+1]),'x')
