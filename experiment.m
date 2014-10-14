RNG_SEED = 4055; % 4055, 2014, 1213

OBS_FILE = 'data/observationsForEstimBAI.txt';
TRAIN_SET_SIZE = 1100; % ~60% (1100) 
VALID_SET_SIZE = 366; % ~20% (366)  
% TEST_SET_SIZE = 1832 - TRAIN_SET_SIZE - VALID_SET_SIZE; % ~20%

% =======================================================================
% Parameters for EPS
% -----------------------------------------------------------------------
N_DRAWS_ESTIMATION = 50;
N_DRAWS_PREDICTION = 5;
N_DRAWS_PER_BETAS = 5;
USE_NOISE = false;
N_SAMPLES = 0; % No prediction will be done if set to zero.
RESULTS_PS_FILE = 'output/results/resultsPS.txt';

BETAS = [-1.8, -0.9, -0.8, -4.0]'; % The betas we use for paths sampling        
                                   % during the PSL estimation. 

% The betas we use for prediction. They will be estimated if empty.
ESTIMATED_BETAS = [];
% ESTIMATED_BETAS = [-2.7814, -1.0224, -0.5453, -4.4426, 1.5654]'; % 4055
% ESTIMATED_BETAS = [-2.7399, -1.0585, -0.5422, -4.2816, 1.4734]'; % 2014
% ESTIMATED_BETAS = [-2.7573, -0.9818, -0.5496, -4.2807, 1.5135]'; % 1213
% =======================================================================

% ===========================================================================
% Parameters for RL
% ---------------------------------------------------------------------------
PREDICTION_RL = false;
RESULTS_RL_FILE = 'output/results/resultsRL.txt';

% ESTIMATED_BETAS_RL = [];
ESTIMATED_BETAS_RL = [-2.4680, -0.9356, -0.4103, -4.5455]';
% ESTIMATED_BETAS_RL = [-2.9806, -1.0744, -0.3580, -4.6282, -0.2361]'; % 4055
% ===========================================================================


addpath('code');
rng(RNG_SEED);

myObs = spconvert(load(OBS_FILE));
myObs = myObs(randperm(size(myObs, 1)), :); % Shuffling the observations.
idxEndTrain = TRAIN_SET_SIZE;
idxEndValid = TRAIN_SET_SIZE + VALID_SET_SIZE;
trainSet = myObs(1:idxEndTrain, :);
validSet = myObs(idxEndTrain+1:idxEndValid, :);
testSet = myObs(idxEndValid+1:end, :);

%{
txtFile = fopen('Input/jpr_experiment/results/4055test_observations.txt', 'w');
for i = 1:size(testSet, 1)
    fprintf(txtFile, '%d ', i);
    fprintf(txtFile, '%s\n', pathToString(testSet(i, 2:end)));
end
fclose(txtFile);
return;
%}

% If necessary, we estimate the model (with expanded PSL) and retrieve the
% estimated betas.
if isempty(ESTIMATED_BETAS)
    pathsSampling(trainSet, N_DRAWS_ESTIMATION, BETAS);
    estimatedBetas = PSLoptimizer(trainSet, N_DRAWS_ESTIMATION);
else
    estimatedBetas = ESTIMATED_BETAS;
end

rng('shuffle');

if N_SAMPLES > 0

    set = validSet;
    setSize = size(set, 1);

    % Using the estimated betas, we repeatedly generate choice sets for the
    % validSet and predict the path probabilities.
    results = {};
    idxStartSample = 1;
    choiceSetSize = setSize * N_DRAWS_PER_BETAS;
    colObsID = linspace(1, choiceSetSize, choiceSetSize)';
    for i = 1:N_SAMPLES
    
        disp(strcat('Sample', num2str(i)));
    
        % We concatenate several choiceSets generated with different betas.
        choiceSet = [];
        b = 1;
        while b <= N_DRAWS_PREDICTION/N_DRAWS_PER_BETAS
            betas = estimatedBetas;
            if USE_NOISE == true
                betas = noisedBetas(estimatedBetas);
            end
            newChoiceSet = pathsSampling(set, N_DRAWS_PER_BETAS, betas, false);
            if isempty(newChoiceSet) == false
                newChoiceSet = [newChoiceSet, colsBetas(choiceSetSize, betas), colObsID];
                choiceSet = cat(1, choiceSet, newChoiceSet);
                b = b + 1;
            end
        end
        shape = size(choiceSet);
        idxLastCol = shape(2);
        choiceSet = sortrows(choiceSet, idxLastCol);
    
        attributes = myGetPathAttributes(choiceSet(:, 1:end-5), N_DRAWS_PREDICTION);
        for j = 1:setSize
            observedPath = pathToString(set(j, 2:end));
            sumExpV = 0.0;
            distinctPaths = {};
            for k = 1:N_DRAWS_PREDICTION
            
                % results_row [sample#, observation#, choice#, path,
                %              beta1, beta2, beta3, beta4,
                %              isObservedPath, probability]
                                  
                results_row{1} = i;
                results_row{2} = j;
                results_row{3} = k;            
            
                idx = (j - 1)*N_DRAWS_PREDICTION + k;
                path = full(choiceSet(idx, :));
                results_row{4} = pathToString(path(3:end-5));
            
                results_row{5} = path(end - 4);
                results_row{6} = path(end - 3);
                results_row{7} = path(end - 2);
                results_row{8} = path(end - 1);
            
                results_row{9} = strcmp(results_row{4}, observedPath);
            
                % TODO: I guess the values could be computed for the whole
                % matrix in the first loop. It might be faster.
                v = attributes(idx, :) * estimatedBetas;
                results_row{10} = exp(v);
                if any(strcmp(distinctPaths, results_row{4})) == false
                    sumExpV = sumExpV + results_row{10};
                    distinctPaths = [distinctPaths, results_row{4}];
                end
            
                idxResult = idxStartSample + idx - 1;
                results{idxResult} = results_row;
            end
            % We compute the path probabilities.
            for k = 1:N_DRAWS_PREDICTION
                idx = (j - 1)*N_DRAWS_PREDICTION + k;
                idxResult = idxStartSample + idx - 1;
                results{idxResult}{10} = results{idxResult}{10} / sumExpV;
            end
        end
        idxStartSample = idxStartSample + setSize*N_DRAWS_PREDICTION;
    end

    % We store results in a text file.
    shape = size(results);
    nRows = shape(2);
    txtFile = fopen(RESULTS_PS_FILE, 'w');
    fprintf(txtFile, '%s\n', 'Sample Observation Choice Path Beta1 Beta2 Beta3 Beta4 IsObservedPath Probability');
    for i = 1:nRows
        row = results{i};
        fprintf(txtFile, ...
                '%d %d %d %s %d %d %d %d %d %d\n', ...
                row{1}, row{2}, row{3}, row{4}, row{5}, row{6}, row{7}, row{8}, row{9}, row{10});
    end
    fclose(txtFile);

end

if isempty(ESTIMATED_BETAS_RL) == true
    estimatedBetasRL = main(trainSet);
else
    estimatedBetasRL = ESTIMATED_BETAS_RL;
end

if PREDICTION_RL == true

    global incidenceFull;
    global Obs;
    global LinkSize;

    global file_linkIncidence;
    global file_AttEstimatedtime;
    global file_turnAngles;
    global LSatt;
    global isLinkSizeInclusive;

    file_linkIncidence = 'data/linkIncidence.txt';
    file_AttEstimatedtime = 'data/ATTRIBUTEestimatedtime.txt';
    file_turnAngles = 'data/ATTRIBUTEturnangles.txt';

    isLinkSizeInclusive = false;

    Obs = testSet;
    loadData;
    lastIndexNetworkState = size(incidenceFull, 1);

    results = [];
    testSetSize = size(Obs, 1);
    for i = 1:testSetSize
        i
        
        if isLinkSizeInclusive
            LinkSize = LSatt(i).value;
        end
        
        Mfull = getM(estimatedBetasRL, isLinkSizeInclusive);    
        M = Mfull(1:lastIndexNetworkState,1:lastIndexNetworkState);
        M(:,lastIndexNetworkState+1) = sparse(zeros(lastIndexNetworkState,1));
        M(lastIndexNetworkState+1,:) = sparse(zeros(1, lastIndexNetworkState + 1));
        
        dest = Obs(i, 1);
        M(1:lastIndexNetworkState ,lastIndexNetworkState + 1) = Mfull(:,dest);
        
        expV = getExpV(M);
        P = getP(expV, M);
        path = Obs(i, 2:end);
        lnP = 0.0;
        p = 1.0;
        j = 1;
        k = path(j);
        while true
            j = j + 1;
            k_ = path(j);
            if k_ ~= dest
                lnP = lnP + log(P(k, k_));
                k = k_;
            else
                break;
            end
        end
        results(i) = exp(lnP);

    end

    txtFile = fopen(RESULTS_RL_FILE, 'w');
    fprintf(txtFile, '%d\n', results);
    fclose(txtFile);

end
