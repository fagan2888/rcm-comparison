% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function count = countPath(choiceSet, path)
    %{
    TODO: Bla bla bla ...

    Both choiceSet and path are expected to have a count in the first column
    (i.e. they are expected to be formatted like the paths generated by
    pathGeneration.m). However, the count column is not considered when
    comparing path with each path in choiceSet.

    TODO: Not sure this is the best behaviour. Maybe we should simply have a 
          more general function that checks if path is a row of choiceSet.
    %}

    count = sum(ismember(choiceSet(:, 2:end), path(2:end), 'rows'));
end
