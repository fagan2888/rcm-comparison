%   Get MUtility
%%
function Mfull = getMLinkSize(beta, linkSize)

    global incidenceFull;

    u = beta * linkSize; 

    Mfull = incidenceFull .* u;    
end
