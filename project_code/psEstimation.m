% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function estimatedBetas = psEstimation(observations, paths, samplingBetas)
    %{
    Estimates an expanded path size logit model. paths are used to fit the model.
    %}

    estimatedBetas = PSLoptimizer(observations, paths, samplingBetas);
end
