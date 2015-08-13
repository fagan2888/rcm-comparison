% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


ESTIMATED_BETAS = [-2.7629, -0.9894, -0.5637, -4.3165, 1.5382];
N_DRAWS = 5;


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

paths = pathGeneration(validSet, ...
                      sprintf('valid%d', RNG_SEED), ...
                      N_DRAWS, ...
                      ESTIMATED_BETAS, ...
                      false, ...
                      'rngSeed', 20155);
paths = getPaths(paths);

nObservations = size(validSet, 1);
probabilities = zeros(nObservations, 2);
for i = 1:nObservations
    i

    startIndex = (i - 1) * N_DRAWS + 1;
    endIndex = startIndex + N_DRAWS - 1;
    
    % Following Frejinger, Bierlaire, Ben-Akiva, 2009.
    proba1 = choiceSetProbabilityGivenObs_(paths(startIndex:endIndex, :), ESTIMATED_BETAS);
    
    % From an exhaustive enumeration of the possible combinations.
    proba2 = choiceSetProbabilityGivenObs(paths(startIndex:endIndex, :), ESTIMATED_BETAS);

    proba1
    proba2

    probabilities(i, 1) = proba1;
    probabilities(i, 2) = proba2;
end
save('choiceSetProbabilities.mat', 'probabilities');
