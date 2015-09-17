% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function utilities = psUtilities(paths, nDraws, betas, correctUtilities)
    %{
    TODO: Bla bla bla ..

    TODO: Define the distinction that is made between observations and paths
          throughout the whole code, in a README or whatever.
          
          choiceSets would probably be a better name for paths.
    %}

    % TODO: The following computation is done over all the paths, including the
    %       duplicates. Seems inneficient.
   
    attributes = myGetPathAttributes(paths, nDraws);    
    utilities = attributes*betas';
    if correctUtilities
        utilities = utilities + samplingCorrectionTerms(paths, nDraws, betas);
    end
end
