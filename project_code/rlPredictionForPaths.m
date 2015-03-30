% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function predictions = rlPredictionForPaths(paths, nDraws, betas, lsBetas)
    %{
    TODO: Bla bla bla ...
    %}

    uPaths = uniquePaths(paths, nDraws);
    
    disp(sprintf('Computing utilities and probabilities for %d paths', ...
                 size(uPaths, 1)));
    
    if nargin < 4
        [utilities, probabilities] = rlPrediction(uPaths(:, 3:end), betas);
    else
        [utilities, probabilities] = rlPrediction(uPaths(:, 3:end), betas, lsBetas);
    end

    obsIDs = uPaths(:, 1);
    sumProbabilities = accumarray(full(obsIDs), probabilities);
    normalizedProbabilities = probabilities ./ sumProbabilities(obsIDs);

    predictions = predictionAux(uPaths, utilities, probabilities);
    
    cellNormalizedProbabilities = num2cell(normalizedProbabilities);
    [predictions.normalizedProbability] = cellNormalizedProbabilities{:};
end
