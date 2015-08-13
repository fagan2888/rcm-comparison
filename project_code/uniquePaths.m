% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function [unqPaths, unqIndices, pathToUnqIndiceMap] = uniquePaths(paths, nDraws)
    %{
    TODO: Bla bla bla ...
    %}

    nObservations = size(paths, 1) / nDraws;
    obsIDs = observationIDs(nObservations, nDraws);
    [unqPaths, unqIndices, pathToUnqIndiceMap] = unique([obsIDs', paths], 'rows', 'first');

    % TODO: Preserving the original order?
end
