function [convdata, freq] = s2p2data (fname)
[header, freq, data] = read_s2p (fname);
a = size(data, 1);
convdata = zeros (2, 2, a);
switch lower(header.units)
  case 'hz'
    ## ignore
  case 'khz'
    freq(:,1) *= 10^3;
  case 'mhz'
    freq(:,1) *= 10^6;
  case 'ghz'
    freq(:,1) *= 10^9;
  case 'thz'
    freq(:,1) *= 10^12;
  otherwise  # добавить проверку на правильность формата единиц частоты
    error ("Wrong frequency units: %s", header.units)
endswitch

switch lower(header.format)
  case 'ri'
    for q = 1:a
      for u = 1:2
        for v = 1:2
          k = u + 2*(v-1);# index of complex value (S11 = Suv)
          ir = 2*k - 1; # index of column containing real part
          ii = 2*k; # index of column containing imag part
          convdata(u, v, q) = data(q, ir) + data(q, ii)*j; 
        endfor
      endfor
    endfor  
  case 'ma'
    for q = 1:a
      for v = 1:2         
        for u = 1:2
          k = u + 2*(v-1); # index of complex value (S11 = Suv)
          ir = 2*k - 1; # index of column containing magnitude
          ia = 2*k; # index of column containing angle
          ang = deg2rad(data(q,ia));
          convdata(u, v, q) = data(q,ir).*(cos(ang)+sin(ang)*j);
        endfor
      endfor
    endfor    
##      for n = 2:2:8
##        convdata(:,(1+(n/2))) = d(:,n).*(cos(deg2rad(d(:,(n+1))))+sin(deg2rad(d(:,(n+1))))*j);
endswitch
endfunction






