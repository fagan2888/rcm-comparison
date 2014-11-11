%{
TODO: Must we support w/ LS attribute? Probably not.
TODO: Float betas for LS attribute (getLinkSizeAtt()).

TODO: Must we support basic PS? Probably. Not implemented in the existing code.
%}

function estimatedBetas = psEstimation(observations, nDraws, samplingBetas)
    %{
    Estimates an expanded path size logit model. For each observation (in
    observations), nDraws paths are generated with a recursive logit model
    parametrized by samplingBetas. These generated paths are used to fit the
    model.
    %}
    paths = pathsSampling(observations, nDraws, samplingBetas);
    estimatedBetas = PSLoptimizer(observations, paths, samplingBetas);
end
