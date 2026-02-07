clc; clear; close all;
s = rng(1);
%%
nfft = 4096;

I = randi([0,1], nfft, 1);
I = 1 - I * 2;
Q = randi([0,1], nfft, 1);
Q = 1 - Q * 2;

serial_beforeOFDM = I + 1j * Q;


%%
scs = 30e3;  % Hz
T_ofdmSymbol = 1 / scs;  % one ofdm symbol

BW = scs * nfft;
%
k = 4;
anySa = k * BW;

%%
ofdmMy = ofdmWave(anySa, T_ofdmSymbol, nfft, serial_beforeOFDM);

ofdmIFFT = nfft * ifft(serial_beforeOFDM, nfft);
ofdmIFFTResample = resample(ofdmIFFT, anySa, BW);

