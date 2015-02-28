% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function replications = getReplications(paths, nDraws)
    %{
    Returns the number of replications for each path for each observation. paths
    is expected to be an array with the following structure:

        [1st path for the 1st observation,
         2nd path for the 1st observation,
         ...,
         nDraws-th path for the 1st observation,
         1st path for the 2nd observation,
         ...,
         nDraws-th path for the 2nd observation,
         ...,
         nDraws-th path for the last observation]

    Returns the number of replications for each path in paths (in the form of an
    array).
    %}
    nRows = size(paths, 1);
    obsID = floor(linspace(0, nRows - 1, nRows) / nDraws) + 1;
    [~, indexes, indexes2] = unique([obsID', paths], 'rows');
    counts = histc(indexes2, 1:size(indexes, 1));
    replications = counts(indexes2);
end
