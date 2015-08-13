% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


LINK_SIZE_BETAS = [-2.5, -1.0, -0.4, -20.0];


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


% We estimate the model.
estimatedBetas = rlEstimation(trainSet);
save('betasWithoutLS.mat', 'estimatedBetas');

estimatedBetas = rlEstimation(trainSet, LINK_SIZE_BETAS);
save('betasWithLS.mat', 'estimatedBetas');
