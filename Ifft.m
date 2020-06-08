[data, freq] = s2p2data ('Initial_DC.s2p');
s11 = squeeze(data(1, 1, :));
##p112xDC = DC(data(1, 1, :),freq);
##s11= [p112xDC; data(1, 1, :)];
S11s = makeSymmetric(s11);
xn = ifft(S11s);
## Mathematically, t_n = n / ((N-1)*f),
## where N is number of records (including 0), f is frequency step (f=1/T). 
## Array freq contains only positive frequency (no zero!), 
## so 2*length(freq) = N-1.
##tn = 1 / (freq * 2*length(freq)); # size is not consistant with xn
f = freq(2) - freq(1);
N = length(S11s);
tn = (0:(N-1))/(f*(N-1));
figure 3
plot(tn,fftshift(real(xn)))
axis([-1e-9, 6e-9])

