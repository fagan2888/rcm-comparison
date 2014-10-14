function betas = PSLoptimizer(observations, nDraws_)
....
%   Path size logit optimization
%   MAI ANH TIEN - DIRO
%   29 - July - 2013
%   MAIN PROGRAM
%   ---------------------------------------------------
%%
Credits;
%------------------------------------------------------
%   Load data
%Import data from workspace
% clear all global;
% clear all;
% importfile('./simulatedData/5.mat');
%importfile('WSPSL_NoPS.mat');
%importfile('WSPSL.mat');
%globalVar;

% Initialize email notification

%   --------------------------------------------------

    globalVar;

    nDraws = nDraws_;
    file_linkIncidence = 'data/linkIncidence.txt';
    file_AttEstimatedtime = 'data/ATTRIBUTEestimatedtime.txt';
    file_turnAngles = 'data/ATTRIBUTEturnangles.txt';
    file_pathSampling = 'output/choice_sets_estimation/choice_sets.txt';
    file_observations = 'data/observationsForEstimBAI.txt';

    tic;

    loadPathSizeData;
    Obs = observations;
    shape = size(Obs);
    nbobs = shape(1);

    % reloadObservations(file_observations);
    idxObs = 1:nbobs;
    Op = Op_structure;
    initialize_optimization_structure();
    %Op.x = [1; -2; -2];
    %Op.x = [ -2.894586e+00;-9.910521e-01;-9.973315e-01; -3.153325e+00;1.171681e+01];
    Op.Optim_Method = OptimizeConstant.TRUST_REGION_METHOD;
    Op.Hessian_approx = OptimizeConstant.SSA_BFGS;
    Gradient = zeros(nbobs,Op.n);

    getPathAttributes;
    getEPS;

    %---------------------------
    %Starting optimization
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
    
    [ll, grad, betas] = getPSLL();
    
    %   Compute variance - Covariance matrix
    %PrintOut(Op);
    %getCov;
    % resultsTXT
    %   Finishing ...
    ElapsedTtime = toc / 60;
    resultsTXT = [resultsTXT sprintf('\n Number of function evaluation %d \n', Op.nFev)];
    resultsTXT = [resultsTXT sprintf('\n Estimated time %d \n', ElapsedTtime)];
    try
       notifyMail('send', resultsTXT);
    catch exection
       fprintf('\n Can not send email notification !!! \n');
    end
    
end
