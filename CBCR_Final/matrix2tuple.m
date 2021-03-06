%% Convert matrix to tuple format.
len = length(cont);
idx_vec = [1:1:len];

row_mat = triu(repmat(idx_vec',1,len));
col_mat = triu(repmat(idx_vec,len,1)); 

row_vec = reshape(row_mat',[len^2,1]);
col_vec = reshape(col_mat',[len^2,1]); 
val_vec = reshape(cont, [len^2,1]); 

new_cont = zeros(len^2,3);
new_cont2 = zeros(len^2,3);

new_cont(:,1) = row_vec;
new_cont(:,2) = col_vec;
new_cont(:,3) = val_vec; 

new_cont2(:,2) = row_vec;
new_cont2(:,1) = col_vec;
new_cont2(:,3) = val_vec; 

equal = new_cont2 ~= new_cont;
cont = new_cont(equal(:,1),:);





