clc; clear; close all;
s = rng(1);
%%
nfft = 4096;

I = randi([0,1], nfft);
I = 1 - I * 2;
Q = randi([0,1], nfft);
Q = 1 - Q * 2;

serial_beforeOFDM = I + 1j * Q;

ofdmIFFT = nfft * ifft(serial_beforeOFDM, nfft);

%%
scs = 30e3;  % Hz
T_ofdmSymbol = 1 / scs;  % one ofdm symbol

BW = scs * nfft;
%
k = 1.7;
anySa = k * BW;

%%
ofdmMy = ofdmWave(anySa, T_ofdmSymbol, nfft, serial_beforeOFDM);

ofdmIFFTResample = resample(ofdmIFFT, anySa, BW);

