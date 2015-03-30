% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function attribute = getPSAttribute(paths, nDraws, nPathsPerLinkMatrix)
    %{
    TODO: Bla bla bla ...
    %}

    global EstimatedTime;

    loadProjectData();

    % We retrieve the travel times.
    travelTimes = max(EstimatedTime);

    if nargin < 3
        nPathsPerLinkMatrix = nPathsPerLink(paths, nDraws);
    end
    M = nPathsPerLinkMatrix;

    % TODO: Get rid of the loop(s).
    nPaths = size(paths, 1);
    attribute = sparse(zeros(1, nPaths));
    for i = 1:nPaths
        path = paths(i, 3:end);
        pathLength = size(find(path), 2);
        obsID = fix((i - 1) / nDraws) + 1;
        for j = 1:pathLength
            attribute(i) = attribute(i) + travelTimes(path(j))/M(obsID, path(j));
        end
        attribute(i) = attribute(i) / sum(travelTimes(path(1:pathLength)));
    end

    attribute = attribute';
end
