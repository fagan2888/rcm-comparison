% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function [unqObs, unqIndices, pathToUnqIndiceMap] = uniqueOD(observations)
    %{
    Returns a single observation for each distinct origin-destination pair.
    %}

    [~, unqIndices, pathToUnqIndiceMap] = unique(observations(:, 1:2), 'rows');
    unqObs = observations(unqIndices, :);
end
