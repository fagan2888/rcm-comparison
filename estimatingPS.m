% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


% The betas we use for path sampling during the estimation.
BETAS = [-1.8, -0.9, -0.8, -4.0];


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
myObs = myObs(randperm(size(myObs, 1)), :); % We shuffle the observations.
idxEndTrain = TRAIN_SET_SIZE;
idxEndValid = TRAIN_SET_SIZE + VALID_SET_SIZE;
trainSet = myObs(1:idxEndTrain, :);
validSet = myObs(idxEndTrain+1:idxEndValid, :);
testSet = myObs(idxEndValid+1:end, :);


% We generate paths for training.
train5 = pathGeneration(trainSet, ...
                        sprintf('train%d', RNG_SEED), ...
                        5, ... % Number of draws.
                        BETAS, ...
                        true, ... % Include the observation.
                        'rngSeed', 20155);

% We generate more paths for training, using those above as a nest.
train10 = pathGeneration(trainSet, ...
                         sprintf('train%d', RNG_SEED), ...
                         10, ... % Number of draws.
                         BETAS, ...
                         false, ... % Don't include the observation.
                         'nest', train5, ...
                         'rngSeed', 201510);

% We estimate the model.
estimatedBetas = psEstimation(trainSet, getPaths(train10), BETAS);
save('betas.mat', 'estimatedBetas');
