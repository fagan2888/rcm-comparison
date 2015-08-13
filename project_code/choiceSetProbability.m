% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function probability = choiceSetProbability(paths, betas)
    %{
    TODO: Bla bla bla ...
    %}

    nDraws = size(paths, 1);
    paths = unique(paths, 'rows');
    [~, probabilities] = rlPrediction(paths(:, 2:end), betas);

    probability = choiceSetProbabilityAux(probabilities, nDraws);
end
