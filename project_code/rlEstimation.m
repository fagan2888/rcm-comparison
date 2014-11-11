function estimatedBetas = rlEstimation(observations, lsBetas)
    if nargin < 2
        estimatedBetas = main(observations);
    else
        estimatedBetas = main(observations, lsBetas);
     end
end
