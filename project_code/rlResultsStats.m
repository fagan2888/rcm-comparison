% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% ==========================================================


function rlResultsStats(rlPredictions, rlObsUtilities)
    %{
    TODO: ...
    %}

    % =========================================================================
    % We compute and display the average probability mass outside of the
    % choice sets.
    % -------------------------------------------------------------------------
    obsIDs = [rlPredictions.obsID];
    probabilities = [rlPredictions.probability];
    normalizedProbabilities = [rlPredictions.normalizedProbability];

    [~, uniqueObsIndices] = unique(obsIDs);

    averageOutsideMass = 1.0 - mean(probabilities(uniqueObsIndices) ./ ...
                                    normalizedProbabilities(uniqueObsIndices));

    disp(sprintf('Average out-of-choiceset probability mass: %f', ...
                 averageOutsideMass));
    % =========================================================================

    % =======================================================================
    % We compute and display the average loss and its standard error.
    % -----------------------------------------------------------------------
    l = losses(rlObsUtilities, rlPredictions);
    average = mean(l);

    disp(sprintf('Average loss: %f', average));
    disp(sprintf('Average''s standard error: %f', std(l) / sqrt(length(l))));
    % =======================================================================
end
