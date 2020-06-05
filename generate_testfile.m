function generate_testfile(fname, d)
    fid = fopen(fname,'w');
    fprintf(fid,'! Created Mon Jan 20 12:27:34 2020\n');
    fprintf(fid,'# hz S RI R 50\n');
    fprintf(fid,'! 2 Port Network Data from SP1.SP block\n');
    fprintf(fid,'! freq  magS11  angS11  magS21  angS21  magS12  angS12  magS22  angS22  \n');
    fclose(fid);

    N = 1000;
    M = 9; #ךמכטקוסעגמ סעמכבצמג ג s2p פאיכו
    Xk = zeros(N,1);
    Xk(100+1) = 2;
    Xk(150+1) = 2*3;
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

    T = 2*pi*4;
    tn = T/(N-1)*n;
    fk = n/T;
 
    Data = zeros(N, M);
    
  if d == 1 
    
    Data(:, 1) = fk;
    Data(:, 2) = real(Xkk);
    Data(:, 3) = imag(Xkk);
    Data(:, 4) = real(Xkk);
    Data(:, 5) = imag(Xkk);
    Data(:, 6) = real(Xkk);
    Data(:, 7) = imag(Xkk);
    Data(:, 8) = real(Xkk);
    Data(:, 9) = imag(Xkk);
    save ('-ascii', '-append', fname, 'Data')
    
  else if d == 2
    
    Data(:, 1) = fk;
    Data(:, 2) = sqrt(real(Xkk)^2 + imag(Xkk)^2);
    Data(:, 3) = atan(real(Xkk)/imag(Xkk));
    Data(:, 4) = sqrt(real(Xkk)^2 + imag(Xkk)^2);
    Data(:, 5) = atan(real(Xkk)/imag(Xkk));
    Data(:, 6) = sqrt(real(Xkk)^2 + imag(Xkk)^2);
    Data(:, 7) = atan(real(Xkk)/imag(Xkk));
    Data(:, 8) = sqrt(real(Xkk)^2 + imag(Xkk)^2);
    Data(:, 9) = atan(real(Xkk)/imag(Xkk));
    save ('-ascii', '-append', fname, 'Data')
   else
    disp('error in generation of testfile')
endfunction