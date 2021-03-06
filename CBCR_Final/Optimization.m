
maximum = ITERATION_SCHEME(l); 
%% Initialize New Portion of Structure
%=========================================================================
if l == 1
    str =  [];
    R = [-0.5,0.5];
    for i = 1: n
        xyz = rand(1,3)*range(R)+ min(R);   
        str = [str xyz];    
    end
end


%% Variables declaration
%=========================================================================
len = length(str);

Sum_Grad = zeros(1,len);
variables = str;
oldobj = 0;

%% Calculate Objective function [ requires variables and derivatives]
%=========================================================================

Gradient_Calculator; % returns the cost and derivative(change)

%% updateVariables [ use current coordinate and derivatives] 
%=========================================================================
 for i = 1:len
     Sum_Grad(i) =  Sum_Grad(i) + (change(i)^2);
     denum = smooth_factor + Sum_Grad(i);
     adagrad = (LEARNING_RATE * change(i)./sqrt(denum));
     variables(i) = variables(i) +  adagrad;
 end
%=========================================================================

 if VERBOSE == 2
    % visualize structure
    convert2xyz;
    randcolor = rand(1,3);
    plot3(xyz(:,1),xyz(:,2),xyz(:,3),'linewidth',2.5,'color',randcolor);
    axis image;
    xlim([-10 10]);
    ylim([-10 10]);
    zlim([-10 10]);
    grid on;
    pause(0.01);
 end 
 %% loop until convergence
%=========================================================================
count =0;
oldobj = cost;
converge = isconvergence(change, cost, CONVG_0);
m = 0;
v = 0;
ma = 0;
va = 0;
mb = 0;
vb = 0;
while(count < maximum && ~converge)
    count = count + 1;    
    % Objective function % returns cost and derivative
    Gradient_Calculator;
    newobj = cost;
    % update variables with gradient
     for i = 1:len
         
         Sum_Grad(i) =  Sum_Grad(i) + (change(i)^2);
         denum = smooth_factor + Sum_Grad(i);
         adagrad = (LEARNING_RATE * change(i)./sqrt(denum));
         variables(i) = variables(i) +  adagrad;
         
         
         
         ma = gamma_1 * ma + (1 - gamma_1) * change_alpha;
         va = gamma_2 * va + (1 - gamma_2) * change_alpha^2;
         ma_hat = ma / (1 - gamma_1^count);
         va_hat = va / (1 - gamma_2^count);
         adam_alpha = .0001 * ma_hat / (sqrt(va_hat) + smooth_factor);
         alpha = abs(alpha + adam_alpha);
         
         beta = 1 - alpha;  
     end 
     
    
     converge = isconvergence(change, cost, CONVG_0); % Alternative  converge = abs(newobj - oldobj); 
     if VERBOSE == or(1,2)
        fprintf('Iteration %1$d, objective function:%2$.5f, alpha:%3$.5f, beta:%4$.5f\n',count, newobj,alpha,beta)
     end 
     
     if VERBOSE == 2
     % visualize structure
         convert2xyz;
         plot3(xyz(:,1),xyz(:,2),xyz(:,3),'linewidth',2.5,'color',randcolor);
         axis image;
         title([' Curricula',num2str(l)]);
         xlim([-10 10]);
         ylim([-10 10]);
         zlim([-10 10]);
         grid on;
         pause(0.01);
     end
end

str = variables;
    
