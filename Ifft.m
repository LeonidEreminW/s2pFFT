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

##applying HF filter
N = length(S11s);

filt = gaus_filter(N,(N/2), 40)

##filt = HF_filter(N, 150) .* LF_filter(N, 200) ;
##filt = LF_filter(N, 200);

S11f = S11s .* filt';
if any(size(S11f) != size(S11s)) 
  error('size mismatch')
endif
xnn = ifft(S11s);
xn = ifft(S11f);
## Mathematically, t_n = n / ((N-1)*f),
## where N is number of records (including 0), f is frequency step (f=1/T). 
## Array freq contains only positive frequency (no zero!), 
## so 2*length(freq) = N-1.
##tn = 1 / (freq * 2*length(freq)); # size is not consistant with xn
f = freq(2) - freq(1);

tn = ((-(N-1)/2):((N-1)/2))/(f*(N-1));

figure 1
plot(tn,fftshift(real(xn)),tn,fftshift(real(xnn)))
axis([-0.2e-9, 0.5e-9])
figure 2
plot(tn,fftshift(real(xnn)))
axis([-0.2e-9, 0.5e-9])
figure 3
plot(tn,fftshift(real(xn)))
axis([-0.2e-9, 0.5e-9])
