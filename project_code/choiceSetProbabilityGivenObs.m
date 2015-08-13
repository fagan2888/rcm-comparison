% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca) 
% =========================================================


function probability = choiceSetProbabilityGivenObs(paths, betas)
    %{
    The probability is computed by enumerating every possible combination
    (from a drawing sequence) that maps to the paths given in argument.
    
    TODO: Bla bla bla ...
    %}

    observation = paths(1, :);
    otherPaths = paths(2:end, :);

    probability = choiceSetProbability(otherPaths, betas);

    countObservation = countPath(otherPaths, observation);
    if countObservation == 0
        if ~containsOnlyUniquePaths(otherPaths)
            % TODO: Do it without relying on the counts?
            otherPaths(find(otherPaths(:, 1) > 1, 1, 'first'), :) = observation;
            probability = probability + choiceSetProbability(otherPaths, betas);
        end
    else if countObservation ~= size(otherPaths, 1)
        isObservation = ismember(otherPaths, observation, 'rows');        
        someNonObservationIndex = find(~isObservation, 1, 'first');        
        otherPaths(isObservation, :) = repmat(otherPaths(someNonObservationIndex, :), ...
                                              sum(isObservation), 1);
        
        probability = probability + choiceSetProbability(otherPaths, betas);
    end
end
