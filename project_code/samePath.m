% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function same = samePath(path1, path2)
    %{
    TODO: Bla bla bla ...
    %}
    same = size(path1, 2) == size(path2, 2) & all(path1 == path2);
end
