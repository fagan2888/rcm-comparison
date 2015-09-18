% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function newPredictions = hansenCorrection(predictions, obsUtilities, nDraws, ...
                                           samplingBetas)
    %{
    TODO: Bla bla bla ...
    %}

    if isfield(predictions, 'normalizedProbability')
        probabilities = [predictions.normalizedProbability]';
    else
        probabilities = [predictions.probability]';
    end

    if nargin > 3
        disp('Computing the sampling probabilities ...');
        % TODO: It might be better to have the sampling probabilities attached to
        %       the paths as soon as they're sampled (in pathGeneration.m).
        paths = getPathsFromPredictions(predictions);
        [~, samplingProbabilities] = rlPrediction(paths, samplingBetas);

        cellSamplingProbabilities = num2cell(samplingProbabilities);
        [predictions.samplingProbability] = cellSamplingProbabilities{:};
    else
        % The sampling probabilities are expected to be included in the
        % predictions structure array.
        samplingProbabilities = [predictions.samplingProbability]';
    end

    % We sum the samplingProbabilities for each choice set, considering only
    % the alternatives with a utility greater than the utility of the
    % observation.
    obsIDs = [predictions.obsID]';
    utilities = [predictions.utility]';
    tailIndices = find(utilities > obsUtilities(obsIDs));
    sumSamplingProbabilities = accumarray(full(obsIDs(tailIndices)), ...
                                          samplingProbabilities(tailIndices));
    % We make sure the vector has the right size. (We pad it with zeros.)
    nObservations = size(obsUtilities, 1);
    if size(sumSamplingProbabilities, 1) ~= nObservations
        sumSamplingProbabilities(nObservations) = 0.0;
    end

    % ================================================================
    % We compute the corrected probabilities.
    % ----------------------------------------------------------------
    probabilities = probabilities ./ (nDraws * samplingProbabilities);
    
    counts = [predictions.count]';
    probabilities = probabilities .* counts;

    probabilities = probabilities .* sumSamplingProbabilities(obsIDs);
    % ================================================================
    
    cellProbabilities = num2cell(probabilities);
    [predictions.correctedProbability] = cellProbabilities{:};

    newPredictions = predictions;
end
