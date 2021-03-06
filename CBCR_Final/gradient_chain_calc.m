sum_trained = 0;
sum_untrained = 0;

% Looping through new curriculum.

 for k= 1:length(C{l})
       i = data(k,1);    j = data(k,2);    IF = data(k,3);  dist = data(k,4);
       if (IF <= 0)
           continue;
       end
       % structure distance   
       x1=structure(i*3-2);  x2=structure(j*3-2);
       y1=structure(i*3-1);  y2=structure(j*3-1);
       z1 =structure(i*3);   z2=structure(j*3);
       str_dist = calEuclidianDist(x1,y1,z1,x2,y2,z2 );      
       % dist = IF distance 
       z = ((str_dist-dist)^2);
       sum_untrained = sum_untrained + z;
 end

sum_untrained = beta*(1-prop_vec(l))*sum_untrained;

% Looping throug previously trained data

for k = (length(C{l})+1):length(data)
   i = data(k,1);    j = data(k,2);    IF = data(k,3);  dist = data(k,4);
   if (IF <= 0)
       continue;
   end
   % structure distance   
   x1=structure(i*3-2);  x2=structure(j*3-2);
   y1=structure(i*3-1);  y2=structure(j*3-1);
   z1 =structure(i*3);   z2=structure(j*3);
   str_dist = calEuclidianDist(x1,y1,z1,x2,y2,z2 );      
   % dist = IF distance 
   z = ((str_dist-dist)^2);
   sum_trained = sum_trained + z;
end

sum_trained = alpha*(prop_vec(l))*sum_trained;

v = sum_trained + sum_untrained;

 


  %% Calculate w
  r = length(prev_trained_data);
  s = length(C{l});
  %------------------------------------------------------------------------
  w = sqrt(v/(r+s));
  %=========================
  % Find dl_dw
  %=========================
  dl_dw = -(alpha*r+beta*s)/w;
  %=========================
  % Find dw_dv
  %=========================
  dw_dv = 1/(2*sqrt((r+s)*v));
  
 
  
 