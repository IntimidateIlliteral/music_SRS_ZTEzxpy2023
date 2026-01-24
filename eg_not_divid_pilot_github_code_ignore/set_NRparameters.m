

%% NR parameters
%% NR time unit
Fc = 480 * 1000 * 4096;
Tc = 1/Fc;  % second

%%
% subcarrier_spacing, scs
subcarrier_spacing = 30e+3;  % Hz

Nfft      = 4096;     % 122.88MHz
F1        = 122.88e6; % Hz
Nused     = 3264;     % 100MHz

subcarrier_each_comb = 4;
NSRScomb4 = 816;
