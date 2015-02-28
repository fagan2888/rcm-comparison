% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca) 
% =========================================================


function paths = getPaths(pathsStruct)
    %{
    Returns the actual paths from a paths structure array (see pathGeneration.m).

    A paths structure array may contain a nest (an other paths structure array),
    in which case the paths will be retrieved recursively. This is pretty much
    why this function exists.
    %}
    pathsArray = {};
    N = [];
    currentPathsStruct = pathsStruct;
    while true
        pathsArray = [pathsArray, {currentPathsStruct.paths}];
        if isempty(currentPathsStruct.nestFile)
            N = [N, currentPathsStruct.nDraws];
            break;
        else
            nDraws = currentPathsStruct.nDraws;

            cachedVariables = load(currentPathsStruct.nestFile);
            currentPathsStruct = cachedVariables.paths;

            N = [N, nDraws - currentPathsStruct.nDraws];
        end
    end

    paths = zipRows(pathsArray, N);

    % Computing the numbers of replications (the first element of each path).
    paths = paths(:, 2:end);
    replications = getReplications(paths, pathsStruct.nDraws);
    paths = [replications, paths];
    
    % TODO: Having a number of replications prepended to every path, as
    %       required with the existing code, seems somewhat dirty.
    %       
    %       Also, the computation of the numbers of replications in the
    %       existing code (pathsSampling.m) could be more efficient.
    %
    %       Prepending the destination (2nd element of a path) is also not very
    %       clean.

    paths = sparse(paths);
end
