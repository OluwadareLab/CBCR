%%---------------------------------------------------------------------
% Divide data into k curricula
%=======================================================================

%--------------------------
% Sort constraints from lowest distance to highest. 
%---------------------------

[~,idx] = sort(lstCons(:,4)); 
lstCons = lstCons(idx,:);

%--------------------------
% Divide into number of curricula
%---------------------------

m = NUMBER_OF_CURRICULA;
div = floor(size(lstCons,1)/m);
div_vec = repelem(div,m);
rem = mod(size(lstCons,1),m);
div_vec(1:rem) = div_vec(1:rem) + repelem(1, rem);
div_vec(m+1) = size(lstCons,1);

C = {}; % Cell of all cirricula;
k = 0;

prop_vec = [0]; % Vector of proportions of trained data. 

for i = 1:m
    C{i} = lstCons(k+1:k+div_vec(i),:);
    k = k +div_vec(i);
end

for i = 2:m
    prop_vec(i) = sum(div_vec(1:i-1))/sum(div_vec);
end

C{m+1} = [];
prop_vec(m+1) = 1;
div_vec(m+1) = 0;


   


    
    
    


