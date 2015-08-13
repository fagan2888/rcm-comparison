% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


ESTIMATED_BETAS = [-2.7629, -0.9894, -0.5637, -4.3165, 1.5382];
% ESTIMATED_BETAS = [-2.7538, -0.9936, -0.5638, -4.4168, 1.5303];

LINK_SIZE_BETAS = [-2.5, -1.0, -0.4, -20.0];

ESTIMATED_BETAS_RL = [-2.4225, -0.9223, -0.4394, -4.3992];
ESTIMATED_BETAS_RL_LS = [-3.0416, -1.0571, -0.3720, -4.4641, -0.2309];


% Seed used for the partitionning of the observations into three sets (training,
% validation and test).
RNG_SEED = 2015;% 2015, 4055, 1234, 1107

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


% We generate paths for validation.
valid5 = pathGeneration(validSet, ...
                        sprintf('valid%d', RNG_SEED), ...
                        5, ...
                        ESTIMATED_BETAS, ...
                        false, ...
                        'rngSeed', 20155);
valid10 = pathGeneration(validSet, ...
                        sprintf('valid%d', RNG_SEED), ...
                        10, ...
                        ESTIMATED_BETAS, ...
                        false, ...
                        'nest', valid5, ...
                        'rngSeed', 201510);
paths = getPaths(valid10);

% We compute the loss for the "without-LinkSize" model.
predictions = rlPredictionForPaths(paths, 10, ESTIMATED_BETAS_RL);
[utilities, ~] = rlPrediction(validSet, ESTIMATED_BETAS_RL);
loss = mean(losses(utilities, predictions));

% We compute the loss for the "with-LinkSize" model.
predictions = rlPredictionForPaths(paths, 10, ESTIMATED_BETAS_RL_LS, LINK_SIZE_BETAS);
[utilities, ~] = rlPrediction(validSet, ESTIMATED_BETAS_RL_LS, LINK_SIZE_BETAS);
lossLS = mean(losses(utilities, predictions));

disp(sprintf('Tail loss for the "without-LinkSize" RL model: %f', loss));
disp(sprintf('Tail loss for the "with-LinkSize" RL model: %f', lossLS));
