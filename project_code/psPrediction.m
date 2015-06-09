% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function predictions = psPrediction(paths, nDraws, betas)
    %{
    Applies the path size model, parametrized by betas, on each path and
    computes the path's utility and probability.

    paths is expected to be a 2D array with the following structure:

       [1st path for the 1st observation,
        2nd path for the 1st observation,
        ...,
        nDraws-th path for the 1st observation,
        1st path for the 2nd observation,
        ...,
        nDraws-th path for the 2nd observation,
        ...,
        nDraws-th path for the last observation].

    Returns the predictions (utility and probability) for each distinct paths
    (duplicate paths for the same observation ID are filtered out).
    %}

    % TODO: Duplicate paths should probably be filtered out as early as possible
    %       in the pipeline (as early as in pathGeneration.m).
    [uPaths, uniqueIndices] = uniquePaths(paths, nDraws);
    
    % Preserving the original order.
    temp = sortrows([uniqueIndices, uPaths], 1);
    uPaths = temp(:, 2:end);
    uniqueIndices = temp(:, 1);

    %{
    Comptuting pathStrings is too costly. It makes the computation time of this
    function 50%+ longer.

    pathStrings = cellfun(@(path) pathToString(path), ...
                          num2cell(full(uPaths(:, 4:end)), 2), ...
                          'un', 0);
    %}

    utilities = psUtilities(paths, nDraws, betas);
    utilities = utilities(uniqueIndices);

    obsIDs = uPaths(:, 1);
    expV = exp(utilities);
    sumExpV = accumarray(full(obsIDs), expV);
    probabilities = expV ./ sumExpV(obsIDs);

    predictions = predictionAux(uPaths, utilities, probabilities);
end
