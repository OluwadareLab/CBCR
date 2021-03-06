%% Timer  
clc
j = 1;
for cur = 307
    
    fprintf('Number of curricula: %d\n', cur);
    eval_rate = floor(cur/20);
    line = num2str(j);
    div = 9500/cur;
    iteration_scheme = zeros(1,cur);
    select = mod(9500,cur);
    [rand, idx] = datasample(iteration_scheme, select, 'Replace', false);
    for i = 1:cur
        if ismember(i, idx)
            iteration_scheme(i) = ceil(div);
        else
            iteration_scheme(i) = floor(div);
        end
    end
    iteration_scheme(cur+1) = 1000; 
    
    CBCR("C:\Users\hoven\OneDrive\Desktop\BioAlgos\mES\nij\nij.chr19",false,cur,.2,eval_rate,iteration_scheme,line);
    j = j+1;
end
    