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
RESULTS_PS_FILE = 'output/resultsPS.txt';

BETAS = [-1.8, -0.9, -0.8, -4.0]'; % The betas we use for path sampling during
                                   % the EPS estimation.

% The betas we use for prediction. They will be estimated if empty.
% ESTIMATED_BETAS = [];
ESTIMATED_BETAS = [-2.7814, -1.0224, -0.5453, -4.4426, 1.5654]'; % 4055
% ESTIMATED_BETAS = [-2.7399, -1.0585, -0.5422, -4.2816, 1.4734]'; % 2014
% ESTIMATED_BETAS = [-2.7573, -0.9818, -0.5496, -4.2807, 1.5135]'; % 1213
% =======================================================================

% ===========================================================================
% Parameters for RL
% ---------------------------------------------------------------------------
LINK_SIZE_BETAS = [-2.5,-1,-0.4,-20]'; % [];
PREDICTION_RL = false;
RESULTS_RL_FILE = 'output/results/resultsRL.txt';

ESTIMATED_BETAS_RL = [];
% ESTIMATED_BETAS_RL = [-2.4680, -0.9356, -0.4103, -4.5455]'; % 4055
% ESTIMATED_BETAS_RL = [-2.4014, -0.9871, -0.4234, -4.3860]'; % 2014
% ESTIMATED_BETAS_RL = [-2.4166, -0.9120, -0.4276, -4.4041]'; % 1213
% ESTIMATED_BETAS_RL = [-2.9806, -1.0744, -0.3580, -4.6282, -0.2361]'; % 4055
% ESTIMATED_BETAS_RL = [-3.0001, -1.1073, -0.3575, -4.4415, -0.2140]'; % 2014
% ===========================================================================


addpath('code');
addpath('project_code');

rng(RNG_SEED);

% We partition the observations into three sets (train, valid, test).
myObs = spconvert(load(OBS_FILE));
myObs = myObs(randperm(size(myObs, 1)), :); % Shuffling the observations.
idxEndTrain = TRAIN_SET_SIZE;
idxEndValid = TRAIN_SET_SIZE + VALID_SET_SIZE;
trainSet = myObs(1:idxEndTrain, :);
validSet = myObs(idxEndTrain+1:idxEndValid, :);
testSet = myObs(idxEndValid+1:end, :);

% rng('shuffle');

% If necessary, we estimate the EPS model.
if isempty(ESTIMATED_BETAS)
    estimatedBetas = psEstimation(trainSet, N_DRAWS_ESTIMATION, BETAS)
else
    estimatedBetas = ESTIMATED_BETAS;
end

%{
We apply the PS  model on some set of observations N_SAMPLES times. The
output (generated paths and their probabilities) is saved in RESULTS_PS_FILE.
%}
if N_SAMPLES > 0
    psPrediction(estimatedBetas, validSet, N_SAMPLES, N_DRAWS_PREDICTION, RESULTS_PS_FILE);
end

% If necessary, we estimate the RL model with or without the link size (LS) attribute.
if isempty(ESTIMATED_BETAS_RL)
    if isempty(LINK_SIZE_BETAS) % Without LS.
        estimatedBetasRL = rlEstimation(trainSet);
    else % With LS.
        estimatedBetasRL = rlEstimation(trainSet, LINK_SIZE_BETAS);
    end
else
    estimatedBetasRL = ESTIMATED_BETAS_RL;
end

% TODO : Put in a function.
if PREDICTION_RL
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

    Obs = trainSet;
    loadData;
    lastIndexNetworkState = size(incidenceFull, 1);

    results = [];

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
