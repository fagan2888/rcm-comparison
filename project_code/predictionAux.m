% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function predictions = predictionAux(uniquePaths, counts, utilities, probabilities)
    %{
    Packages prediction's results in a nice array of structure arrays (see
    predictionsStruct.m.
    %}
    
    predictions = predictionsStruct(size(uniquePaths, 1));
    
    obsIDs = uniquePaths(:, 1);
    cellObsIDs = num2cell(obsIDs);
    [predictions.obsID] = cellObsIDs{:};

    cellPaths = num2cell(uniquePaths(:, 3:end), 2);
    [predictions.path] = cellPaths{:};

    cellCounts = num2cell(counts);
    [predictions.count] = cellCounts{:};

    cellUtilities = num2cell(utilities);
    [predictions.utility] = cellUtilities{:};

    cellProbabilities = num2cell(probabilities);
    [predictions.probability] = cellProbabilities{:};
end
