% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)                     
% =========================================================


function [probabilities, iterationProbabilities] = psProbabilities(observations, ...
                                                                   betas, ...
                                                                   nDraws, ...
                                                                   terminationCriteriaHandle, ...
                                                                   previousIterationProbabilities)
    %{
    TODO: Bla bla bla ...
    %}

    useCache = false;
    if nargin == 5
        useCache = true;
    end

    loadProjectData();

    nObservations = size(observations, 1);
    probabilities = zeros(nObservations, 1);
    
    for i = 1:nObservations
        disp(sprintf('Estimating probability for observation #%d ...', i));

        if useCache
            cache = cell2mat(previousIterationProbabilities(i));
        end

        probaInclusion = 0.0;
        probas = {};
        j = 1;
        while ~terminationCriteriaHandle(probas)
            obs = observations(i, :);

            if probaInclusion == 0.0
                [~, rlProbability] = rlPrediction(obs, betas);
                probaInclusion = 1.0 - (1.0 - rlProbability)^nDraws;
            end
            
            if useCache & size(cache, 2) >= j
                probaObservation = cache(j);
            else
                paths = pathsSampling(obs, nDraws, betas, true);
                [~, uniqueIndices] = unique(paths, 'rows');                

                predictions = psPrediction(paths, nDraws, betas);
                probaObservation = predictions(1).probability;
            end

            probas(j) = {probaObservation};

            %{
            TODO: Might very well be faster to use a standard array even though
                  growing a cell array is faster than growing a standard array.
            %}           
            probas_ = cell2mat(probas);
            averageProba = mean(probas_);
                        
            disp(' ');
            disp(sprintf('Probability from sample #%d: %f', j, probaObservation));
            disp(sprintf('Average of the probabilities: %f', averageProba));            
            disp(' ');

            j = j + 1;
        end
        probabilities(i) = probaInclusion * averageProba;
        iterationProbabilities(i) = {probas_};
    end    
end
