file1 = 'Initial_DC.s2p';
file2 = 'Initial.s2p';
fname = file1;

[data, freq] = s2p2data (fname);
s11 = squeeze(data(1, 1, :));

if strcmp(fname,file2)
  disp('calculate DC')
  ##calculate s11 in 0 and put it in S11 vector
  p112xDC = DC (s11,freq);
  s11 = [p112xDC; s11];
endif

##makes s11 vector symmetrical
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

