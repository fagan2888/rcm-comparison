% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function reps = replications(paths, nDraws)
    %{
    Computes the number of replications for each path in paths (for each
    path for each observation). paths is expected to be an array with the
    following structure:

        [1st path for the 1st observation,
         2nd path for the 1st observation,
         ...,
         nDraws-th path for the 1st observation,
         1st path for the 2nd observation,
         ...,
         nDraws-th path for the 2nd observation,
         ...,
         nDraws-th path for the last observation].

    Returns the number of replications in the form of a column array (aligned
    with the array of paths passed in argument).
    %}

    [~, uniqueIndices, pathToUniqueIndiceMap] = uniquePaths(paths, nDraws); 
        
    counts = histc(pathToUniqueIndiceMap, 1:size(uniqueIndices, 1));
    reps = counts(pathToUniqueIndiceMap);
end
