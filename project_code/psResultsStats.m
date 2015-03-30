% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function psResultsStats(psPredictions, psObsUtilities)
    %{
    TODO: ...
    %}

    probabilities = [psPredictions.probability];

    % We assume that the observations IDs are ordered and ranging from 1 to
    % nObservations.
    % TODO; We could not make this assumption and use a more robust approach.
    nObservations = psPredictions(end).obsID;

    unobservedIndices = find(probabilities == 0.0);

    % We compute and display the choice sets' average size
    averageSize = (size(psPredictions, 1) - length(unobservedIndices)) / nObservations;
    disp(sprintf('Choice sets'' average size: %f', averageSize));

    % We compute and display the proportion of the observations that are
    % included in their respective choice set.
    observedProportion = 1.0 - length(unobservedIndices)/nObservations;
    disp(sprintf('Observations that were generated: %.1f%%', ...
                  observedProportion * 100));

    % ===========================================================================
    % We compute and display the average loss and its standard error.
    % ---------------------------------------------------------------------------
    l = losses(psObsUtilities, psPredictions);
    average = mean(l);
    
    disp(sprintf('Average loss: %f', average));
    disp(sprintf('average''s standard error: %f', std(l) / sqrt(nObservations)));
    % ===========================================================================
end
