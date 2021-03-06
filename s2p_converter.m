fname = 'testdata.s2p';

##generate_testfile(fname)

[header, data] = read_s2p (fname);
disp(header)
T = 1/(data(2,1) - data(1,1))
N = size(data, 1)
n = 0:(N-1);
tn = T/(N-1)*n;
fk = n/T;
if header.format == 'RI'
Xkk = data(:, 2) + j*data(:,3);
xnn = ifft(Xkk);
subplot(2, 1, 1)
plot(tn, xnn)
fk = n/T;
subplot(2, 1, 2)
plot(fk,real(Xkk))
endif