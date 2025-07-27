
%%
syms s0 w0 s1 w1 s2 w2 N;
M=8; N = 50; p = 3;
s = [s0;s1;s2];
A = exp(1j*[w0,w1,w2].*(0:M-1).');
x = A*s;

%%
load '../pilot.mat'
load '../example_64Tc.mat'

xf = pilot;
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
close all;
clc;
clear;
load pilot.mat
load ant1_data1.mat;
load example_64Tc.mat
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
%% model of my own
noiser = 1*randn([1,Nu]); noisei = 1*randn([1,Nu]);
ratio = 2^-16;
noise = ratio*0*(noiser+1j*noisei);

tn = (1:Nu);
d_omg = 2*pi./[144.3524, 72.1762, 36.88, 99, 87, 62].';
amp = [1, 0.3, 0.17, 0.07, 0.32, 0.23, 0.11].';
Msig1 = 3;
s = exp(-1*1j*d_omg(1:Msig1).*tn);
x = amp(1:Msig1)' * s  +  noise;
scatterplot(x)
%%
yf2 = x;
% yf2 = yf222;
scatterplot(yf2(:));
%% fbss  L-sub_sensor_array
Msig = Msig1;
% Msig = 6;
M0 = 816;
L = Msig+1;
% L = 400;
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
[Vb, Db] = eig(cov3);

Mnoise = Mb - Msig;
G = Vb(:, 1:Mnoise );  % noise subspace. Linear Algebra;

%%
r500 = 130/4096;  %  130: 0~500
angle_sa0 = 4096*2^2;
resolution_omg = 2*pi/angle_sa0;
angle_sa = floor(angle_sa0*r500);
p2 = zeros(angle_sa, 1);
pm = zeros(angle_sa, 1);
%%
awb =   @(omg) (exp(1j* omg .* (0:(Mb-1)) )).';
pmusic = @(omg) 1 / (awb(omg)' *(G*G')     * awb(omg)) ;
pcapon = @(omg) 1 / (awb(omg)' * cov1^(-1) * awb(omg));
for id = 0:(-1+angle_sa)
    dphase = id * resolution_omg;
    pm(id+1) = pmusic(dphase);
end
pm = abs(pm);
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

