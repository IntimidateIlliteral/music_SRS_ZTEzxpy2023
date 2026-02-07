function wave_t = ofdmWave(...
    anySa,...
    T_ofdmSymbol,...
    nfft,...
    xAscoeff)

%%
%
delta_f        = 1 / T_ofdmSymbol;
ofdmSymbolRate = 1 / T_ofdmSymbol;

%
T_subSymbol =   1 / nfft * T_ofdmSymbol;
subSymbolRate = 1 / T_subSymbol;
subSymbolRate = nfft * 1 / T_ofdmSymbol;
subSymbolRate = nfft * ofdmSymbolRate;

%
BW = subSymbolRate;

BW = nfft * delta_f;
BW = nfft * ofdmSymbolRate;


%% [0, T_ofdmSymbol]
HowManyTimeSamplePoints = floor(anySa*T_ofdmSymbol);
%
timeInterval = linspace(0, T_ofdmSymbol, 1+ HowManyTimeSamplePoints);
timeInterval = timeInterval(1:HowManyTimeSamplePoints).';

%%
carrierId  = (0: -1+nfft).';
subcarrier  = exp(1j* 2*pi* carrierId  * delta_f * timeInterval.').';
%%
xishu = xAscoeff;

% 0号子载波，的系数
xishu(1) = 0;

% coordinates == linear combination
coordinates = xishu;
basisAsColumn = subcarrier;
wave_t = basisAsColumn * coordinates;

%%
carrierId2 = (-nfft/2 : -1+nfft/2).';
subcarrier2 = exp(1j* 2*pi* carrierId2 * delta_f * timeInterval.').';
xishu2 = xAscoeff;
xishu2(1+nfft/2) = 0;
end