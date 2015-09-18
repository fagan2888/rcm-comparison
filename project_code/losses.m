% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


% TODO: Find a name for this novel loss function :)

function L = losses(obsUtilities, predictions)
    %{
    Evaluates the loss for each observation. The loss depends on the predictions
    associated with it (a set of alternatives with their associated utilities
    and probabilities). More precisely, it is defined as the sum of the
    probabilities of all alternatives having a higher utility than the
    observation.

    obsUtilities is expected to be an array containing the utility of each
    observation (see psUtilitiesForObservations.m or rlUtilities.m).

    Typically, predictions is a structure array returned by psPrediction.m or
    rlPrediction.m.
    %}
    
    obsIDs = [predictions.obsID]';    
    utilities = [predictions.utility]';

    if isfield(predictions, 'correctedProbability')
        probabilities = [predictions.correctedProbability]';
    elseif isfield(predictions, 'normalizedProbability')
        probabilities = [predictions.normalizedProbability]';
    else
        probabilities = [predictions.probability]';
    end

    tailIndices = find(utilities > obsUtilities(obsIDs));

    L = accumarray(full(obsIDs(tailIndices)), probabilities(tailIndices));
    % We make sure the vector has the right size. (We pad it with zeros.)
    nObservations = size(obsUtilities, 1);
    if size(L, 1) ~= nObservations
        L(nObservations) = 0.0;
    end
end
