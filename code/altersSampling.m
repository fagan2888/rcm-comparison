% Alternative sampling
% -------------------------------------------

function samples = altersSampling()
    
    global file_AttEstimatedtime;
    global file_linkIncidence;
    global file_observations;
    global file_turnAngles;

    global incidenceFull; 
    global Obs;     % Observation
    global nbobs;
    global nDraws;
    global Alters;
    global isLinkSizeInclusive;
    
    
    maxPathLength = 500;
    beta = [-1.8,-0.9,-0.8,-4.0]';    isLinkSizeInclusive = false;
    file_linkIncidence = './Input/linkIncidence.txt';
    file_AttEstimatedtime = './Input/ATTRIBUTEestimatedtime.txt';
    file_turnAngles = './Input/ATTRIBUTEturnangles.txt';
    file_observations = './Input/observationsForEstimBAI.txt';
    
    loadData; % Recursive logit

    [lastIndexNetworkState, nsize] = size(incidenceFull);
    Obs = spconvert(load(file_observations));
    [nbobs, maxstates] = size(Obs);
    %nbobs = 10;
    nDraws = 50;
    Alters = sparse(zeros(nbobs * nDraws, maxPathLength));
    Incidence = incidenceFull(1:lastIndexNetworkState,1:lastIndexNetworkState); 
    Incidence(:,lastIndexNetworkState+1) = sparse(zeros(lastIndexNetworkState,1));
    Incidence(lastIndexNetworkState+1,:) = sparse(zeros(1, lastIndexNetworkState + 1));
    hasLoop = 0;
    nLoop = 0;
    Mfull = getM(beta,false);
    [p q] = size(Mfull);
    M = Mfull(1:lastIndexNetworkState,1:lastIndexNetworkState); 
    M(:,lastIndexNetworkState+1) = sparse(zeros(lastIndexNetworkState,1));
    M(lastIndexNetworkState+1,:) = sparse(zeros(1, lastIndexNetworkState + 1));
    for n = 1:nbobs     
        n
        dest = Obs(n, 1);
        orig = Obs(n, 2);      
        % Get probabilities       
        M(1:lastIndexNetworkState ,lastIndexNetworkState + 1) = Mfull(:,dest);
        [expV, expVokBool] = getExpV(M); % vector with value functions for given beta                                                                     
        if (expVokBool == 0)
           samples = [];
           disp('ExpV is not fesible')
           return; 
        end  
        P = getP(expV, M);   
        Incidence(1:lastIndexNetworkState ,lastIndexNetworkState + 1) = incidenceFull(:,dest);
        dummy = lastIndexNetworkState + 1;
        Alters((n-1) * nDraws + 1, 1:size(Obs(n,:),2)+1) = [0, Obs(n,:)];
        i = 2;
        while i <= nDraws  
            hasLoop = 0;
            fprintf(' %d: %d: %d\n',n,i,nLoop);
            visited = zeros(1,lastIndexNetworkState + 1 );
            visited(orig) = 1;k = orig;
            Alters((n-1) * nDraws + i, 2) = dest;
            Alters((n-1) * nDraws + i, 3) = orig;
            t = 4;
            while k ~= dummy
                ind = find(Incidence(k,:)); %.* (1-visited));
                prob = P(k,:); %.* (1-visited);
                prob = prob / sum(prob);
                nbInd = size(ind,2);
                if nbInd == 0
                    break;
                end
                sInd = gendist(full(prob),1,1);   
                if visited(sInd) == 1
                    hasLoop = 1;
                end
%                 while true
%                                 
%                     if visited(sInd) == 0
%                         break;
%                     end
%                 end
                if sInd ~= dummy
                    Alters((n-1) * nDraws + i, t) = sInd;
                    visited(sInd) = 1;
                    t = t + 1;
                end
                k = sInd;
            end
            nLoop = nLoop + hasLoop;
            if nbInd == 0
                 Alters((n-1) * nDraws + i, :) = zeros(1,maxPathLength);
                 continue;
            end
            Alters((n-1) * nDraws + i, t) = dest;
            i = i + 1;
        end
        % Get number of replication
        np = zeros(1,nDraws);
        for i = 1: nDraws
            np(i) = 0;
            for j = 1: nDraws
                if all(Alters((n-1) * nDraws + i,:) == Alters((n-1) * nDraws + j,:)) == 1
                    np(i) = np(i) + 1;
                end
            end            
        end
        for i = 1: nDraws
            Alters((n-1) * nDraws + i,1) = np(i);
        end
    end
    samples = Alters;
    % Write to sampling file
    [i,j,val] = find(Alters);
    data_dump = [i,j,val];
    save('./Input/pathsSampling1.txt','data_dump','-ascii');
    nLoop
end