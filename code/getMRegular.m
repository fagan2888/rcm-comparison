%   Get MUtility
%%
function Mfull = getMRegular(betas)

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
    
    Mfull = incidenceFull .* u;    
end
