
function CBCR(input, learning_rate, conversion, max_iter_0, max_iter_1, verbose)
disp ('============================================');
disp ('Data = Hi-C data  ');
disp ('===========================================');
path = 'Scores/';
%==========================================================================
% Make directory if it doesn't exist
%--------------------------------------------------------------------------
if ~exist(path, 'dir')
    % Folder does not exist so create it.
    mkdir(path);
end


smooth_factor = 1e-4; % for numerical stability

alpha = .5;
beta = 1-alpha;
 
gamma_1 = .9; % Decay rate for first moment estimate in adam. 
gamma_2 = .999; % Decay rate for second moment estimate in adam.
LEARNING_RATE = learning_rate; % Specify the learning rate.

CONVG_0 =.0001; % used to signify a boundary of convergence
CONVG_1 = .0001; 
 
INPUT_FILE = input;

VERBOSE = verbose;

CONVERT_FACTOR = conversion;

MAX_ITER_0 = max_iter_0;
MAX_ITER_1 = max_iter_1;
 
EVAL_RATE = 20; 
%==========================================================================

[filepath, name, ext] = fileparts(INPUT_FILE);

S  = [];
time = [];
TS = [];
Corr = [];
P_CORR = [];
RMSD = [];
new_name = name;
converge = 0;
count = 0;
lump = [];


%=========================================================================
ReadInput; % Load the contact file


NUMBER_OF_CURRICULA = ceil(n/5);

fprintf('Number of curricula: %d\n', NUMBER_OF_CURRICULA);
eval_rate = floor(NUMBER_OF_CURRICULA/20);
div = MAX_ITER_0/ NUMBER_OF_CURRICULA;
iteration_scheme = zeros(1,NUMBER_OF_CURRICULA);
select = mod(MAX_ITER_0,NUMBER_OF_CURRICULA);
[random, idx] = datasample(iteration_scheme, select, 'Replace', false);
for i = 1:NUMBER_OF_CURRICULA
    if ismember(i, idx)
        iteration_scheme(i) = ceil(div);
    else
        iteration_scheme(i) = floor(div);
    end
end
iteration_scheme(NUMBER_OF_CURRICULA+1) = MAX_ITER_1; 

ITERATION_SCHEME = iteration_scheme;
%=========================================================================


% specify the alpha


for CONVERT_FACTOR = conversion
        old_curric = Inf; 
        curric_diff = Inf;
        lump = [];
 
        %-------------------------
        Convert2Distance;
        %-------------------------

        %-------------------------
        Divide_Curricula; % Divide into curricula
        %-------------------------

        % For each CONVERT_FACTOR generate N structures
        s= [];
        ts=[];
        cor=[]; 
        P_corr = [];
        rmsd = [];
        totalIF = 0; 
        prev_str = [];
        


        prev_trained_data = []; % Matrix all trained curricula 
        prev_str = []; % Vector of xyz data for all trained structures from each previous curriculum. 

        for l = 1:(1+NUMBER_OF_CURRICULA)
            
         
                
                
            fprintf('Number: %f\n', l);
            fprintf('Conversion: %f\n',CONVERT_FACTOR); 
            
            %disp ('=============================================================================');
            %fprintf('Creating structure at CONVERT_FACTOR = %f and structure = %d\n', CONVERT_FACTOR,l);
            %disp ('=============================================================================');
            data = [C{l}; prev_trained_data];
            %-------------------------
            Optimization;
            
            %-------------------------

            prev_trained_data = data;
            convert2xyz;
            
            if rem(l,eval_rate) == 0 && l>(NUMBER_OF_CURRICULA/2);
                Evaluation;
            end
            
            if curric_diff < CONVG_1
                for k = l+1:1+NUMBER_OF_CURRICULA
                    lump = [lump; C{k}];
                end
                
                data = [lump; prev_trained_data];
                
                l = 1+NUMBER_OF_CURRICULA;
                fprintf('Convergence met. Iterating through remaining data.\n')
                Optimization;
                break 
            end 
                
            
       
        end
            %========================================================================
            % scoring using spearman correlation, pearson correlation and  RMSD     
            %------------------------------------------------------------------------
             str_name =[ path,num2str(name),'_CONVERT_FACTOR=',num2str(CONVERT_FACTOR),num2str(NUMBER_OF_CURRICULA)];
             %----------------------
             Evaluation;
             convert2xyz;
             %-----------------------             
             %output scores ::: S shows the scores for different CONVERT_FACTOR            
             ts = [ts;CONVERT_FACTOR,l,SpearmanRHO];                        
             cor = [cor;SpearmanRHO];  %output the correlation         
            %----------------------
            %pearson correlation           
            P_corr = [P_corr;PearsonRHO];
            %----------------------
            % perform root mean square error
            rmsd = [rmsd;rmse];
            %------------------------------------------------------------------------     
            %output pdb and image
            %------------------------------------------------------------------------
            out; % default run

         %------------------------------------------------------------------------     
         %Select the representative model for the CONVERT_FACTOR value
         %------------------------------------------------------------------------
           [v,index]= max(ts(:,3));
           TS = [TS;ts(index,:)];      
           Corr = [Corr;max(cor)];
           P_CORR = [P_CORR ;max(P_corr)];
           RMSD = [RMSD;min(rmsd)];
end

% ========================================================================
% Select the representative model for the chromosome
%---=--========------------------------------------------------------------
[first, name, ext] = fileparts(INPUT_FILE);
input = strcat(name,ext);
[val,index]= max(TS(:,3));
CONVERT_FACTOR = TS(index,1);

l = TS(index,2);
pl =  P_CORR(index);
rep_rms = RMSD(index);
rep_spear = Corr(index);


%save scores to file
f_scores =strcat(path,num2str(new_name),'_Finalscores.txt');
dlmwrite(f_scores,sprintf('CONVERT_FACTOR\tStructure Number\tSpearman Correlation'));
dlmwrite(f_scores,TS);
%save pearson correlation
scores =strcat(path,num2str(new_name),'_pearsoncorr.txt');
%dlmwrite(scores, P_CORR );
%save spearman correlation
scores =strcat(path,num2str(new_name),'_spearmancorr.txt');
%dlmwrite(scores,Corr);
%save RMSD
scores =strcat(path,num2str(new_name),'_rmsd.txt');
%dlmwrite(scores,RMSD);

final_name =[ num2str(new_name),'_CONVERT_FACTOR=',num2str(CONVERT_FACTOR),'N=', num2str(NUMBER_OF_CURRICULA), '.pdb']; 
readme =strcat(path,num2str(new_name),'_readme.txt');
fprintf('\n===============================================\n');
fprintf('Input file: %s\n', input)
fprintf('Convert factor: %f\n', CONVERT_FACTOR);  
fprintf('RMSE: %f\n', rep_rms)
fprintf('Spearman correlation Dist vs. Reconstructed Dist: %f\n', rep_spear);  
fprintf('Pearson correlation Dist vs. Reconstructed Dist: %f\n', pl);  
fid = fopen(readme,'wt');
msg = ['The Representative structure is ',final_name]; 
fprintf(fid,msg);
fclose(fid);
% 
averages = strcat(path, num2str(new_name),'_averages.log');
log = fopen(averages,'wt');
fprintf(log,'Input file: %s\n', input);
fprintf(log, 'The optimal structure is: %s\n', final_name);
fprintf(log,'Convert factor: %f\n', CONVERT_FACTOR);  
fprintf(log,'RMSE: %f\n', rep_rms);
fprintf(log,'Spearman correlation Dist vs. Reconstructed Dist: %f\n', rep_spear);  
fprintf(log,'Pearson correlation Dist vs. Reconstructed Dist: %f\n', pl); 
fclose(log);

beep



