% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function predictions = rlPredictionForPaths(paths, nDraws, ...
                                            betas, samplingBetas, ...
                                            lsBetas)
    %{
    TODO: Bla bla bla ...
    %}

    uPaths = uniquePaths(paths, nDraws);

    counts = full(uPaths(:, 2));
    
    disp(sprintf('Computing utilities and probabilities for %d paths', ...
                 size(uPaths, 1)));
   
    if nargin < 5
        [utilities, probabilities] = rlPrediction(uPaths(:, 3:end), betas);
    else
        [utilities, probabilities] = rlPrediction(uPaths(:, 3:end), betas, lsBetas);
    end    
    
    % ====================================================================================
    % We normalize the probabilities.
    % ------------------------------------------------------------------------------------
    %{
    % 1. We condition the probabilities using the choice set probabilities (and
       Bayes formula).
    % TODO: Explain further.
    % TODO: It might be better to have the sampling probabilities attached to
    %       the paths as soon as they're sampled (in pathGeneration.m).
    [~, samplingProbabilities] = rlPrediction(uPaths(:, 3:end), samplingBetas);
    normalizedProbabilities = probabilities .* counts ./ (nDraws * samplingProbabilities);
    %}

    % We skip the conditioning (for now) because it doesn't seem to be working (yet).
    normalizedProbabilities = probabilities;

    % 2. We normalize the conditionned probabilities.
    obsIDs = uPaths(:, 1);
    sumProbabilities = accumarray(full(obsIDs), normalizedProbabilities);
    normalizedProbabilities = normalizedProbabilities ./ sumProbabilities(obsIDs);
    % ====================================================================================

    predictions = predictionAux(uPaths, counts, utilities, probabilities);
   
    cellNormalizedProbabilities = num2cell(normalizedProbabilities);
    [predictions.normalizedProbability] = cellNormalizedProbabilities{:};

    % We don't save the sampling probabilities (for now) since we skipped their
    % computation above.
    %{
    cellSamplingProbabilities = num2cell(samplingProbabilities);
    [predictions.samplingProbability] = cellSamplingProbabilities{:};
    %}
end
