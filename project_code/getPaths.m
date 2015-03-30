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
        pathsArray = [{currentPathsStruct.paths}, pathsArray];
        if isempty(currentPathsStruct.nestFile)
            N = [currentPathsStruct.nDraws, N];
            break;
        else
            nDraws = currentPathsStruct.nDraws;

            cachedVariables = load(currentPathsStruct.nestFile);
            currentPathsStruct = cachedVariables.paths;

            N = [nDraws - currentPathsStruct.nDraws, N];
        end
    end

    paths = zipRows(pathsArray, N);

    paths = updateReplications(paths, pathsStruct.nDraws);
    
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
