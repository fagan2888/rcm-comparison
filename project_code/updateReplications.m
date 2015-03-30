% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function updatedPaths = updateReplications(paths, nDraws)
    %{
    TODO: ...
    %}

    paths = paths(:, 2:end);
    reps = replications(paths, nDraws);
    updatedPaths = [reps, paths];
end
