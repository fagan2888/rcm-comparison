....
%   Path size logit optimization
%   Optmization algorithm
%   MAI ANH TIEN - DIRO
%   29 - July - 2013
%   MAIN PROGRAM
%   ---------------------------------------------------
%%
function ok = bootstrapping(Start, End)
    global nbobs;       % Number of observation
    global Op;
    global Gradient;
    global idxObs;
    fileOutput = 'resultsBootstrap.txt';
    SamplesBt = load('samples');
    iStart = str2num(Start);
    iEnd = str2num(End);
    results = zeros(iEnd - iStart + 1, 7);
    for idx = iStart:1:iEnd
        idxObs = SamplesBt(:,idx);
        Op = Op_structure;
        initialize_optimization_structure();
        Op.x = [ -2.696;-0.821;-0.420; -3.547;  8.854];
        Op.Optim_Method = OptimizeConstant.LINE_SEARCH_METHOD;
        Op.Hessian_approx = OptimizeConstant.SSA_BFGS;
        Gradient = zeros(nbobs,Op.n);        
        %---------------------------
        %Starting optimization
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
              fprintf('The algorithm stops, due to %s \n', Stoppingtype);
              break;
          end
        end
        results(idx - iStart +1,:) = [idx, Op.value, Op.x'];       
    end
    dlmwrite(fileOutput,results,'-append', 'precision','%13.10f');
end
