% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca) 
% =========================================================


function attributes = getRegularAttributes(paths)
    %{
    TODO: Bla bla bla ...
    %}

    global EstimatedTime;
    global LeftTurn;
    global TurnAngles;
    global Uturn;

    loadProjectData();

    % We retrieve the travel times.
    travelTimes = max(EstimatedTime);

    % We retrieve the link counts.
    linkCounts = max(LeftTurn); % TODO: Why do linkCounts depend on LeftTurn?

    % TODO: The following computation is done over all the paths, including the
    %       duplicates. Seems inneficient.

    % TODO: Get rid of the loop(s).
    nPaths = size(paths, 1);
    attributes = sparse(zeros(4, nPaths));
    for i = 1:nPaths
        path = paths(i, 3:end);
        pathLength = size(find(path), 2);

        attributes(1, i) = attributes(1, i) + travelTimes(path(1));
        attributes(3, i) = attributes(3, i) + linkCounts(path(1));

        for j = 1:pathLength-1
            attributes(1, i) = attributes(1, i) + travelTimes(path(j + 1));
            attributes(2, i) = attributes(2, i) + TurnAngles(path(j), path(j + 1));
            attributes(3, i) = attributes(3, i) + linkCounts(path(j + 1));
            attributes(4, i) = attributes(4, i) + Uturn(path(j), path(j + 1));
        end
    end

    attributes = attributes';
end
