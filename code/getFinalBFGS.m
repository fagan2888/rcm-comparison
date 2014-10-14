% Get BFGS matrix:
%%
global idxObs; 
idxObs = 1:nbobs;
Op = Op_structure;
initialize_optimization_structure();
Op.n = 5;
Op.x = -ones(Op.n,1);
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
Final_BFGS = Op.H;
