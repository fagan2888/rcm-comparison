function estimatedBetas = rlEstimation(observations, lsBetas)
    % Estimates the RL model with or without the link size (LS) attribute.
    if nargin < 2 % Without LS.
        estimatedBetas = main(observations);
    else % With LS.        
        estimatedBetas = main(observations, lsBetas);
     end
end
