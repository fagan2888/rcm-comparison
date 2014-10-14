....
%   Path size logit optimization
%   Optmization algorithm
%   MAI ANH TIEN - DIRO
%   29 - July - 2013
%   MAIN PROGRAM
%   ---------------------------------------------------
%%
Credits;
clear all global;
clear all;
importfile('./simulatedData/WSPSL_NoPS.mat');
globalVar;
%   --------------------------------------------------
Op = Op_structure;
initialize_optimization_structure();
Op.Optim_Method = OptimizeConstant.TRUST_REGION_METHOD;
Op.Hessian_approx = OptimizeConstant.BFGS;
Gradient = zeros(nbobs,Op.n);
%---------------------------
%Starting optimization
tic ;
%progTest
disp('Start Optimizing ....')
[Op.value, Op.grad ] = getPSLL();
PrintOut(Op);
% print result to string text
header = [sprintf('%s \n',file_observations) Op.Optim_Method];
header = [header sprintf('\nNumber of observations = %d \n', nbobs)];
header = [header sprintf('Hessian approx methods = %s \n', OptimizeConstant.getHessianApprox(Op.Hessian_approx))];
resultsTXT = header;
%------------------------------------------------
while (true)    
  Op.k = Op.k + 1;
  if strcmp(Op.Optim_Method,OptimizeConstant.LINE_SEARCH_METHOD);
    ok = line_search_iterate();
    if ok == true
        PrintOut(Op);
    else
        disp(' Unsuccessful process ...')
        break;
    end
  else
    ok = btr_interate();
    PrintOut(Op);
  end
  [isStop, Stoppingtype, isSuccess] = CheckStopping(Op);  
  %----------------------------------------
  % Check stopping criteria
  if(isStop == true)
      isSuccess
      fprintf('The algorithm stops, due to %s', Stoppingtype);
      resultsTXT = [resultsTXT sprintf('The algorithm stops, due to %s \n', Stoppingtype)];
      break;
  end
end
%   Compute variance - Covariance matrix
%PrintOut(Op);
%getCov;
%   Finishing ...
ElapsedTtime = toc
resultsTXT = [resultsTXT sprintf('\n Number of function evaluation %d \n', Op.nFev)];
resultsTXT = [resultsTXT sprintf('\n Estimated time %d \n', ElapsedTtime)];

rsTXT = [Op.Optim_Method,':',OptimizeConstant.getHessianApprox(Op.Hessian_approx),':',sprintf('(%f)', Op.value),sprintf(':(%f):', norm(Op.grad)),sprintf('%d\n', Op.nFev)];
fileID = fopen('nFevs.txt','at+');
fprintf(fileID,rsTXT);


