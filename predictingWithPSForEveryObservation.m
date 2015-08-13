% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


ESTIMATED_BETAS = [-2.7629, -0.9894, -0.5637, -4.3165, 1.5382]; % 2015


% Seed used for the partitionning of the observations into three sets (training,
% validation and test).
RNG_SEED = 2015; % 2015, 4055, 1234, 1107

OBS_FILE = 'data/observationsForEstimBAI.txt';
TRAIN_SET_SIZE = 916; % ~50%
VALID_SET_SIZE = 458; % ~25%
% TEST_SET_SIZE = 1832 - TRAIN_SET_SIZE - VALID_SET_SIZE; % ~25%


addpath('code');
addpath('project_code');


rng(RNG_SEED);

% We partition the observations into three sets.
myObs = spconvert(load(OBS_FILE));
myObs = myObs(randperm(size(myObs, 1)), :); % Shuffling the observations.
idxEndTrain = TRAIN_SET_SIZE;
idxEndValid = TRAIN_SET_SIZE + VALID_SET_SIZE;
trainSet = myObs(1:idxEndTrain, :);
validSet = myObs(idxEndTrain+1:idxEndValid, :);
testSet = myObs(idxEndValid+1:end, :);


rng('shuffle');

% =============================================================================
% We estimate the probabilities using 5 iterations for each observation.
% -----------------------------------------------------------------------------
nDraws = 5;
nIterations = 5;
terminationCriteria = @(x) fixedNumberOfIterationsCriteria(x, nIterations);

[probabilities, iterationProbabilities] = psProbabilities(validSet, ...
                                                          ESTIMATED_BETAS, ...
                                                          nDraws, ...
                                                          terminationCriteria);
save('psProbabilities5.mat', 'probabilities', 'iterationProbabilities');
% =============================================================================

% ================================================================================================
% We estimate the probabilities using 10 iterations for each observation,
% re-using the probabilities from the 5 previous iterations.
% ------------------------------------------------------------------------------------------------
nIterations = 10;
terminationCriteria = @(x) fixedNumberOfIterationsCriteria(x, nIterations);

cachedVariables = load('psProbabilities5.mat');

[probabilities, iterationProbabilities] = psProbabilities(validSet, ...
                                                          ESTIMATED_BETAS, ...
                                                          nDraws, ...
                                                          terminationCriteria, ...
                                                          cachedVariables.iterationProbabilities);
save('psProbabilities10.mat', 'probabilities', 'iterationProbabilities');
% ================================================================================================
