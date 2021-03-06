%% Gradient Calculator
% Initialize
cost = 0;
structure = variables;
change = zeros(1,len);
untrained_val = 0;
trained_val = 0;

% Calculate the chain rule derivative for the gradient calculation
gradient_chain_calc;

% Derive wrt alpha and beta

change_alpha = - log(((alpha*sum_trained*prop_vec(l) + sum_untrained*(prop_vec(l) - 1)*(alpha - 1))/(r + s))^(1/2))*(r - s) - ((sum_untrained*(prop_vec(l) - 1) + sum_trained*prop_vec(l))*(alpha*r - s*(alpha - 1)))/(2*(alpha*sum_trained*prop_vec(l) + sum_untrained*(prop_vec(l) - 1)*(alpha - 1)));
%% Derive wrt x,y,z coordinates
% Loop through new curriculum. 
 for k= 1:length(C{l})
      i = data(k,1);    j = data(k,2);    IF = data(k,3);  dist = data(k,4);
       if (IF <= 0)
           continue;
       end
       
       if (abs(i - j) == 1 )
			IF = 1.0 * maxIF;
       end
      
      
       
       x1=structure(i*3-2);  x2=structure(j*3-2);
       y1=structure(i*3-1);  y2=structure(j*3-1);
       z1 =structure(i*3);   z2=structure(j*3);
       str_dist = calEuclidianDist(x1,y1,z1,x2,y2,z2 );     
       
       z = str_dist - dist;
       
       % the remaining part of dv_d(x,y,z)
       
       tmp =   dl_dw * dw_dv * 2 * beta * (1-prop_vec(l)) * (z/str_dist);
       
               
       change(i*3-2) = change(i*3-2) + (tmp * (structure(i*3-2) - structure(j*3-2)));
       change(i*3-1) = change(i*3-1) + (tmp * (structure(i*3-1) - structure(j*3-1)));
       change(i*3) = change(i*3) + (tmp * (structure(i*3) - structure(j*3)));
       
       change(j*3-2) = change(j*3-2) + (tmp * (structure(j*3-2) - structure(i*3-2)));
       change(j*3-1) = change(j*3-1) + (tmp * (structure(j*3-1) - structure(i*3-1)));
       change(j*3) = change(j*3) + (tmp * (structure(j*3) - structure(i*3)));
       
        % objective function       
        untrained_val = untrained_val  + (z^2);
       
 end
 
 
 % Loop through previously trained data 
 for k= (length(C{l})+1):length(data)
      i = data(k,1);    j = data(k,2);    IF = data(k,3);  dist = data(k,4);
       if (IF <= 0)
           continue;
       end
       
       if (abs(i - j) == 1 )
			IF = 1.0 * maxIF;
       end
       
      
       
       x1=structure(i*3-2);  x2=structure(j*3-2);
       y1=structure(i*3-1);  y2=structure(j*3-1);
       z1 =structure(i*3);   z2=structure(j*3);
       str_dist = calEuclidianDist(x1,y1,z1,x2,y2,z2 );     
       
       z = str_dist - dist;
       
       % the remaining part of dv_d(x,y,z)
       
       tmp =   dl_dw * dw_dv * 2 * alpha * prop_vec(l) * (z/str_dist);
       
               
       change(i*3-2) = change(i*3-2) + (tmp * (structure(i*3-2) - structure(j*3-2)));
       change(i*3-1) = change(i*3-1) + (tmp * (structure(i*3-1) - structure(j*3-1)));
       change(i*3) = change(i*3) + (tmp * (structure(i*3) - structure(j*3)));
       
       change(j*3-2) = change(j*3-2) + (tmp * (structure(j*3-2) - structure(i*3-2)));
       change(j*3-1) = change(j*3-1) + (tmp * (structure(j*3-1) - structure(i*3-1)));
       change(j*3) = change(j*3) + (tmp * (structure(j*3) - structure(i*3)));
       
        % objective function       
        trained_val = trained_val  + (z^2);
       
 end
 
 val = alpha * prop_vec(l) * trained_val + beta * (1-prop_vec(l)) * untrained_val;
 
 % cost
 cost = -(r+s/2) - ((alpha * r + beta * s)*log(sqrt(val/(r+s))));