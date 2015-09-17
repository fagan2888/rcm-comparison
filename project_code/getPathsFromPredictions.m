% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function paths = getPathsFromPredictions(predictions)
    %{
    TODO: Bla bla bla ...
    %}

    paths = [predictions.path]';    
    nPaths = size(predictions, 1);
    pathWidth = size(paths, 1) / nPaths;

    paths = reshape(paths, pathWidth, nPaths)';
end
