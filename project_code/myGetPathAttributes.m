% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function attributes = myGetPathAttributes(paths, nDraws)
    %{
    TODO: Bla bla bla ...
    %}
    
    regularAttributes = getRegularAttributes(paths);
    psAttribute = getPSAttribute(paths, nDraws);
    
    attributes = [regularAttributes, psAttribute];

    % TODO: Add the sampling correction, like in the original getPathAttributes.m.
    %
    %       Then get rid of the original getPathAttributes.m.
end
