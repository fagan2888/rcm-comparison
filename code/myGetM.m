%   Get MUtility
%%
function Mfull = getM(betas, linkSize)

    global incidenceFull;
    global EstimatedTime;
    global TurnAngles;
    global LeftTurn;
    global Uturn;

    u1 = betas(1) * EstimatedTime;
    u2 = betas(2) * TurnAngles;
    u3 = betas(3) * LeftTurn;
    u4 = betas(4) * Uturn;
    
    u = u1 + u2 + u3 + u4;

    if nargin >= 2
        u5 = betas(5) * linkSize;
        u = u + u5;
    end
    
    %expM = exp(u);
    
    Mfull = incidenceFull .* u;    
end
