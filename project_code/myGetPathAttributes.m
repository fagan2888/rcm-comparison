% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function attributes = myGetPathAttributes(paths, nDraws)
    %{
    TODO: Bla bla bla ...
    %}

    % TODO: The following computation is done over all the paths, including the
    %       duplicates. Seems inneficient.
    
    regularAttributes = getRegularAttributes(paths);
    psAttribute = getPSAttribute(paths, nDraws);
    
    attributes = [regularAttributes, psAttribute];
end
