% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function pathsWithObservations = addObservationsToPaths(observations, paths)
    %{
    TODO: Bla bla bla ...
    %}

    nObservations = size(observations, 1);
    nDraws = size(paths, 1) / nObservations;

    observations = [ones(nObservations, 1), observations];

    pathsWithObservations = zipRows([{observations}, {paths}], [1, nDraws]);
    pathsWithObservations = updateReplications(pathsWithObservations, nDraws + 1);
    pathsWithObservations = sparse(pathsWithObservations);
end
