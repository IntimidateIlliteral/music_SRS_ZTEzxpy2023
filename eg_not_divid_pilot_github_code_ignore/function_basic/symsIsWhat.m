
%%
syms s0 w0 s1 w1 s2 w2 N;
M=8; N = 50; p = 3;
s = [s0;s1;s2];
A = exp(1j*[w0,w1,w2].*(0:M-1).');
x = A*s;
