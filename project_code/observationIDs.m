% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function ids = observationIDs(nObservations, nDraws)
    %{
    Returns a row array of IDs to distinguish each observation in a typical
    2D array of paths (with nPaths x nDraws rows).

    For example, if nPaths = 3 and nDraws = 2, this will return
    [1, 1, 2, 2, 3, 3].

    The transpose of the returned array can be stacked vertically to a typical
    2D array of paths to identify each observation.
    %}

    nRows = nObservations * nDraws;
    ids = floor(linspace(0, nRows - 1, nRows) / nDraws) + 1; 
end
