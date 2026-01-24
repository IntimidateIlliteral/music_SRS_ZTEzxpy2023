function x = my_own_model4MUSICinput(Msig1, d_omg, amp, NSRScomb4)

tn = (1:NSRScomb4);
Msig2 = min(Msig1,length(d_omg));
s = exp(-1*1j*d_omg(1:Msig2).*tn);
ssum = amp(1:Msig2)' * s;

noiser = 1*randn([1,NSRScomb4]); noisei = 1*randn([1,NSRScomb4]);
ratio = 2^-8;
noise = ratio*1*(noiser+1j*noisei);

x = ssum +  noise;  % todo: awgnMy
end