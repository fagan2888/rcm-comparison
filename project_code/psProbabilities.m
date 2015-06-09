% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)                     
% =========================================================


function probabilities = psProbabilities(observations, ...
                                         betas, ...
                                         nDraws, ...
                                         terminationCriteriaHandle, ...
                                         savedIterationProbabilities)
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
            cache = cell2mat(savedIterationProbabilities(i));
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
            
            if useCache & size(cache, 1) >= j
                logProbaChoiceSet = cache(j, 1);
                probaObservation = cache(j, 2);
            else
                paths = pathsSampling(obs, nDraws, betas, true);
                
                % TODO: The probabilities were already computed in pathsSampling.
                %       Refactor.
                [~, rlProbabilities] = rlPrediction(paths(:, 2:end), betas);
                
                logProbaChoiceSet = sum(log(rlProbabilities));

                predictions = psPrediction(paths, nDraws, betas);
                probaObservation = predictions(1).probability;
            end

            probas(j, 1:2) = {logProbaChoiceSet, probaObservation};

            %{
            TODO: Might very well be faster to use a standard array even though
                  growing a cell array is faster than growing a standard array.
            %}           
            probas_ = cell2mat(probas);
            maxLogProbaChoiceSets = max(probas_(:, 1));
            movedProbaChoiceSets = exp(probas_(:, 1) - maxLogProbaChoiceSets);
            normalizedProbaChoiceSets = exp(probas_(:, 1) - maxLogProbaChoiceSets - log(sum(movedProbaChoiceSets)));
            averageProba = dot(normalizedProbaChoiceSets, probas_(:, 2));
                        
            disp(' ');
            disp(sprintf('Probability from sample #%d: %f', j, probaObservation));
            disp(sprintf('Weighted average of the probabilities: %f', averageProba));            
            disp(' ');

            j = j + 1;
        end
        probabilities(i) = probaInclusion * averageProba;
        probasToSave(i) = {probas_};
    end
    
    % TODO: Make probas a return value.
    probas = probasToSave;
    save('proba_cache/probas500.mat', 'probas');
end
