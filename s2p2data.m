[h,d] = read_s2p_old('Initial.s2p');
disp(h)
a = size(d, 1);
convdata = zeros(a,5);

switch lower(h.units)
  case 'hz'
    convdata(:,1) = d(:,1);
  case 'khz'
    convdata(:,1) = d(:,1)*10^3;
  case 'mhz'
    convdata(:,1) = d(:,1)*10^6;
  case 'ghz'
    convdata(:,1) = d(:,1)*10^9;
  case 'thz'
    convdata(:,1) = d(:,1)*10^12;
##  otherwise  # добавить проверку на правильность формата единиц частоты
endswitch
switch lower(h.format)
  case 'ri'
    for n = 2:2:8
      convdata(:,(1+(n/2))) = d(:,n) + d(:,(n+1))*j;
    endfor
  case 'ma'  
    for n = 2:2:8
      convdata(:,(1+(n/2))) = d(:,n).*(cos(deg2rad(d(:,(n+1))))+sin(deg2rad(d(:,(n+1))))*j);
    endfor
endswitch
##print_column(convdata, 'ss');
disp(convdata(300,2));
fk = real(convdata(:,1));
xk = real(convdata(:,2));
##subplot(2,1,1)
plot(fk,xk)
##fkstep = convdata(2,1) - convdata(1,1);
##n = (0:a-1)';
##tn = (a-1)*n/fkstep;
##xn = ifft(convdata(:,2));
##xnabs = abs(xn)
##xnarg = arg(xn)
##subplot(2,1,2)
##plot(tn,xnabs)





