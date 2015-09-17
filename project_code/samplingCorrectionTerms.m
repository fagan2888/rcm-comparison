% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function terms = samplingCorrectionTerms(paths, nDraws, betas)
    %{
    TODO: Bla bla bla ...
    %}
    
    % TODO: The following computation is done over all the paths, including the
    %       duplicates. Seems inneficient.
    
    counts = full(paths(:, 1));
    [~, samplingProbabilities] = rlPrediction(paths(:, 2:end), betas);

    terms = log(counts ./ samplingProbabilities);
end
