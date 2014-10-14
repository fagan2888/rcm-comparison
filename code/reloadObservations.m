function reloadObservations(fileObs)
    global Alters;
    global EstimatedTime;
    global LeftTurn;
    global TurnAngles;
    global Uturn;   
    global Op;
    global nDraws;   
    global Atts;
    global Corr; % Sampling correction
    global Obs;
    global nbobs;
    global incidenceFull;
    
    Obs = spconvert(load(fileObs));
    [nbobs, maxstates] = size(Obs);
    
    for n = 1: nbobs
        n
        choiceSet = Alters((n-1)* nDraws + 1: n* nDraws,: );
        choiceSet(1,:) = choiceSet(1,:) * 0.0;
        choiceSet(1,1:size(Obs(n,:),2)+1) = [0, Obs(n,:)];
        np = zeros(1,nDraws);
        for i = 1: nDraws
            np(i) = 0;
            for j = 1: nDraws
                if isequal(choiceSet(i,2:end),choiceSet(j,2:end)) == true
                    np(i) = np(i) + 1;
                end
            end            
        end
        for i = 1: nDraws
            choiceSet(i,1) = np(i);
        end
        Alters((n-1) * nDraws + 1 : n * nDraws, :) = choiceSet;
    end
end