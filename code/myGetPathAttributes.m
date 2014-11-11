function attributes = myGetPathAttributes(choiceSet, nDraws)

    global EstimatedTime;
    global LeftTurn;
    global TurnAngles;
    global Uturn;
    global incidenceFull;

    % =============================================================================
    % Copied and adapted from the original getPathAttributes.
    % -----------------------------------------------------------------------------
    I = find(EstimatedTime);
    travelTime = zeros(size(EstimatedTime, 2));    
    for i = 1:size(I, 1);
       [k, a] = ind2sub(size(EstimatedTime), I(i));
       travelTime(a) = EstimatedTime(k, a);
    end
    
    J = find(LeftTurn);
    LC = zeros(size(LeftTurn, 2));
    for i = 1:size(J, 1);
        [k, a] = ind2sub(size(LeftTurn), J(i));
        LC(a) = LeftTurn(k,a);
    end
    
    lastDestNode = size(incidenceFull,2);
        
    nPaths = size(choiceSet, 1);
    attributes = sparse(zeros(5, nPaths));
    for n = 1:nPaths        
        if mod(n, nDraws) == 0
            fix(n / nDraws);
        end
        path = choiceSet(n, 1:end);
        lpath = size(find(path), 2);
        
        % Compute regular attributes.
        for i = 3:lpath-1
            attributes(1, n) = attributes(1, n) + travelTime(path(i + 1));
            attributes(2, n) = attributes(2, n) + TurnAngles(path(i), path(i + 1));
            attributes(3, n) = attributes(3, n) + LC(path(i + 1));
            attributes(4, n) = attributes(4, n) + Uturn(path(i), path(i + 1));
        end
        attributes(1, n) = attributes(1, n) + travelTime(path(3));
        attributes(3, n) = attributes(3, n) + LC(path(3));
    
        % Compute path size attribute.
        M = zeros(1, lastDestNode);
        idxStart = fix((n - 1) / nDraws)*nDraws + 1;
        idxEnd = fix((n - 1) / nDraws)*nDraws + nDraws;
        U = choiceSet(idxStart:idxEnd, 3:end);
        U(U == 0) = [];
        unqU = unique(U);
        histU =  histc(full(U), full(unqU));
        M(unqU) = histU;
        % Path size attribute uses travel time as the length of link.       
        for i = 3: lpath
           link = path(i);
           attributes(5, n) = attributes(5, n) + travelTime(link)/M(link);
        end
        attributes(5, n) = attributes(5, n) / attributes(1, n);
        
    end
        
    attributes = attributes';
    % =============================================================================
    
end
