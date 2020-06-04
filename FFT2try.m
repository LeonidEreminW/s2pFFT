N = 11
Xk = zeros(N,1);
m = 2;
Xk(m+1) = 2;
##Xk(N-m+1) = 1;
xn = zeros(N,1);

for n = 0:N-1
  for k = 0:N-1
    c = cos(2*pi*n*k/N);
 # s = sin(2*pi*n*k/N) ;
    s = 0;
    xn(n+1) += Xk(k+1)*(c + j*s);
  endfor
endfor
xn /= N;
disp('xn')
disp(xn)
disp('fft')
Xkk = fft(xn);
disp(Xkk)
plot(xn)
print_column(Xk, 'Xk')