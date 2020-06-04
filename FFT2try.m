N = 1000
Xk = zeros(N,1);
Xk(2+1) = 2;
Xk(4+1) = 2*3;
##Xk(N-m+1) = 1;
xn = zeros(N,1);

n = (0:N-1)';
  for k = 0:N-1
    c = cos(2*pi*n*k/N);
##    c = 0;
##    s = sin(2*pi*n*k/N) ;
    s = 0;
    xn += Xk(k+1)*(c + s);
  endfor
  
xn /= N;
##disp('xn')
##disp(xn)
##disp('fft')
Xkk = fft(xn);
##disp(Xkk)
##print_column(Xk, 'Xk')

T = 2*pi*4;
tn = T/(N-1)*n;
subplot(2, 1, 1)
plot(tn,xn)
fk = n/T
subplot(2, 1, 2)
plot(fk,real(Xkk))