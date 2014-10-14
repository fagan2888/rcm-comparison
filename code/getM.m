%   Get MUtility
%%
function Mfull = getM(x, isLS)

    global incidenceFull;
    global EstimatedTime;
    global TurnAngles;
    global LeftTurn;
    global Uturn;
    global LinkSize;

    mu = 1;
    u1 = x(1) * EstimatedTime;
    u2 = x(2) * TurnAngles;
    u3 = x(3) * LeftTurn;
    u4 = x(4) * Uturn;
    if isLS == false
        u = 1/mu * (u1 + u2 + u3 + u4);
    else
        u5 = x(5) * LinkSize;
        u = 1/mu * (u1 + u2 + u3 + u4 + u5);
    end
    expM = exp(u);
    Mfull = incidenceFull .* expM;
    
end
