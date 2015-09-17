% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function probability = choiceSetProbabilityGivenObs_(paths, betas)
    %{
    Following "Sampling of alternatives for route choice modeling, Frejinger,
    Bierlaire, and Ben-Akiva, 2009".

    It is assumed that the observation is the first path (in paths).

    TODO: Bla bla bla ...
    %}

    nDraws = size(paths, 1);
    
    [paths, uniqueIndices] = uniquePaths(paths, nDraws);
    
    % We preserve the original order.
    temp = sortrows([uniqueIndices, paths], 1);
    paths = temp(:, 3:end);
    
    [~, probabilities] = rlPrediction(paths(:, 2:end), betas);
    
    probability = factorial(nDraws - 1) / prod(factorial(paths(:, 1)));
    probability = probability * prod(power(probabilities, paths(:, 1)));
    probability = probability * paths(1, 1) / probabilities(1);
end
