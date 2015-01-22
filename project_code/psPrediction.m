% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function psPrediction(betas, observations, nSamples, nDraws, resultsFile)
    %{
    Applies the path size model, parametrized by betas, on the observations
    nSamples times. For each sample and each observation (in the observations),
    nDraws paths are generated. The output (generated paths and their
    probabilities) is saved in resultsFile.

    TODO: Support the use case where the user has origin-destination pairs
          instead of observations.
    TODO: Modify the function's signature so that it can handle noised betas.
    TODO: Get rid of the constants.
    %}
    USE_NOISE = false;
    N_DRAWS_PER_BETAS = nDraws;
    N_DRAWS_PREDICTION = nDraws;
    N_SAMPLES = nSamples;
    RESULTS_PS_FILE = resultsFile;

    set = observations;
    setSize = size(set, 1);

    %{
    Using the estimated betas, we repeatedly generate choice sets for the
    validSet and predict the path probabilities.
    %}
    results = {};
    idxStartSample = 1;
    choiceSetSize = setSize * N_DRAWS_PER_BETAS;
    colObsID = linspace(1, choiceSetSize, choiceSetSize)';
    for i = 1:N_SAMPLES
        disp(strcat('Sample', num2str(i)));
    
        % We concatenate several choiceSets generated with different betas.
        choiceSet = [];
        b = 1;
        while b <= N_DRAWS_PREDICTION/N_DRAWS_PER_BETAS
            betas_ = betas;
            if USE_NOISE
                betas_ = noisedBetas(betas);
            end
            newChoiceSet = pathsSampling(set, N_DRAWS_PER_BETAS, betas_, false);
            if ~isempty(newChoiceSet)
                newChoiceSet = [newChoiceSet, colsBetas(choiceSetSize, betas_), colObsID];
                choiceSet = cat(1, choiceSet, newChoiceSet);
                b = b + 1;
            end
        end
        shape = size(choiceSet);
        idxLastCol = shape(2);
        choiceSet = sortrows(choiceSet, idxLastCol);
    
        attributes = myGetPathAttributes(choiceSet(:, 1:end-5), N_DRAWS_PREDICTION);
        for j = 1:setSize
            observedPath = pathToString(set(j, 2:end));
            sumExpV = 0.0;
            distinctPaths = {};
            for k = 1:N_DRAWS_PREDICTION
            
                %{
                results_row [sample#, observation#, choice#, path,
                             beta1, beta2, beta3, beta4,
                             isObservedPath, probability]
                %}
                                  
                results_row{1} = i;
                results_row{2} = j;
                results_row{3} = k;            
            
                idx = (j - 1)*N_DRAWS_PREDICTION + k;
                path = full(choiceSet(idx, :));
                results_row{4} = pathToString(path(3:end-5));
            
                results_row{5} = path(end - 4);
                results_row{6} = path(end - 3);
                results_row{7} = path(end - 2);
                results_row{8} = path(end - 1);
            
                results_row{9} = strcmp(results_row{4}, observedPath);
            
                %{
                TODO: I guess the values could be computed for the whole matrix
                      in the outer loop. It might be faster.
                %}
                v = attributes(idx, :) * betas;
                results_row{10} = exp(v);
                if any(strcmp(distinctPaths, results_row{4}))
                    sumExpV = sumExpV + results_row{10};
                    distinctPaths = [distinctPaths, results_row{4}];
            end
            
                idxResult = idxStartSample + idx - 1;
                results{idxResult} = results_row;
            end
            % We compute the path probabilities.
            for k = 1:N_DRAWS_PREDICTION
                idx = (j - 1)*N_DRAWS_PREDICTION + k;
                idxResult = idxStartSample + idx - 1;
                results{idxResult}{10} = results{idxResult}{10} / sumExpV;
            end
        end
        idxStartSample = idxStartSample + setSize*N_DRAWS_PREDICTION;
    end

    % We store results in a text file.
    shape = size(results);
    nRows = shape(2);
    txtFile = fopen(RESULTS_PS_FILE, 'w');
    fprintf(txtFile, '%s\n', 'Sample Observation Choice Path Beta1 Beta2 Beta3 Beta4 IsObservedPath Probability');
    for i = 1:nRows
        row = results{i};
        fprintf(txtFile, ...
                '%d %d %d %s %d %d %d %d %d %d\n', ...
                row{1}, row{2}, row{3}, row{4}, row{5}, row{6}, row{7}, row{8}, row{9}, row{10});
    end
    fclose(txtFile);
end
