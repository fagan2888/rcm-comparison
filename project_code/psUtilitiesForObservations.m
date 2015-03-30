% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function utilities = psUtilitiesForObservations(observations, ...
                                                betas, ...
                                                nPathsPerLinkMatrix)
    %{
    TODO: Bla bla bla ...

    TODO: Define the distinction that is made between observations and paths
          throughout the whole code, in a README or whatever.

          choiceSets would probably be a better name for paths.
    %}

    
    % Most functions working with paths expect them to be prepended with a
    % number-of-replications column. We prepend the observations with a dummy
    % column.
    %
    % TODO: Only psEstimation.m really needs the number of replications.
    %       Refactor the code so that only such function expects the paths to
    %       come with a number-of-replications column.
    observations = [ones(size(observations, 1), 1), observations];
     
    regularAttributes = getRegularAttributes(observations);
    psAttribute = getPSAttribute(observations, 1, nPathsPerLinkMatrix);
   
    attributes = [regularAttributes, psAttribute];

    utilities = attributes * betas';
end
