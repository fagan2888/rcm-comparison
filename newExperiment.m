RNG_SEED = 2015;

OBS_FILE = 'data/observationsForEstimBAI.txt';
TRAIN_SET_SIZE = 9; % ~50% (916)
VALID_SET_SIZE = 458; % ~25% (458)
% TEST_SET_SIZE = 1832 - TRAIN_SET_SIZE - VALID_SET_SIZE; % ~25%

% ============================================================================
% Parameters for EPS
% ----------------------------------------------------------------------------
N_DRAWS_ESTIMATION = 50;
N_DRAWS_PREDICTION = 5;
N_DRAWS_PER_BETAS = 5;
USE_NOISE = false;
N_SAMPLES = 0; % No prediction will be done if set to zero.
RESULTS_PS_FILE = 'output/resultsPS.txt';

BETAS = [-1.8, -0.9, -0.8, -4.0]'; % The betas we use for path sampling during
                                   % the EPS estimation.

% The betas we use for prediction. They will be estimated if empty.
ESTIMATED_BETAS = [];
% ESTIMATED_BETAS = [ , , , , ]'; % 4055
% ============================================================================

% ==================================================
% Parameters for RL
% --------------------------------------------------
LINK_SIZE_BETAS = [-2.5,-1,-0.4,-20]'; % [];
PREDICTION_RL = false;
RESULTS_RL_FILE = 'output/results/resultsRL.txt';

ESTIMATED_BETAS_RL = [];
% ESTIMATED_BETAS_RL = [ , , , ]'; % 4055 - w/out LS
% ESTIMATED_BETAS_RL = [ , , , , ]'; % 4055 - w/ LS
% ==================================================


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

paths = pathGeneration(trainSet, sprintf('train%d', RNG_SEED), 5, BETAS, ...
                       'rngSeed', 20155)
morePaths = pathGeneration(trainSet, sprintf('train%d', RNG_SEED), 15, BETAS, ...
                           'rngSeed', 201515, 'nest', paths)

%{

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

%}
