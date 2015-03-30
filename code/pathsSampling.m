% Paths sampling
% 25 - Oct - 2013
% -------------------------------------------

function samples = pathsSampling(observations, nDraws, betas, includeObs)

    % TODO: As is, calling pathsSampling repeatedly, with the same observations
    %       and betas, results in quite a bit of computation that is performed
    %       more than once on the same data (in particular, the functions
    %       loaddata and getP). For a few hundred observations, it seems to add
    %       up to a waste of 5+ minutes per sample.
    
    if nargin < 4
        includeObs = true;
    end  
    
    global file_AttEstimatedtime;
    global file_linkIncidence;
    global file_observations;
    global file_turnAngles;

    global incidenceFull; 
    % global Obs;     % Observation
    global nbobs;
    % global nDraws;
    global Alters;
    global isLinkSizeInclusive;
    
    tic;   
    
    maxPathLength = 500;
    beta = betas;
    % beta = [-1.8,-0.9,-0.8,-4.0]';
    % beta = [-1.0,-1.0,-1.0,-1.0]';
    isLinkSizeInclusive = false;
    % file_linkIncidence = 'data/linkIncidence.txt';
    % file_AttEstimatedtime = 'data/ATTRIBUTEestimatedtime.txt';
    % file_turnAngles = 'data/ATTRIBUTEturnangles.txt';
    % file_observations = 'data/observationsForEstimBAI.txt';
    
    loadData; % Recursive logit

    [lastIndexNetworkState, nsize] = size(incidenceFull);
    Obs = observations;
    % Obs = spconvert(load(file_observations));
    [nbobs, maxstates] = size(Obs);
    % nbobs = 400;
    % nDraws =100;
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
        choiceSet = zeros(nDraws,maxPathLength);
        i = 1;
        if includeObs == true
            choiceSet(1,1:size(Obs(n,:),2)+1) = [0, Obs(n,:)];
            i = 2;
        end
        %Alters((n-1) * nDraws + 1, 1:size(Obs(n,:),2)+1) = [0, Obs(n,:)];
        while i <= nDraws  
            hasLoop = 0;
            %fprintf(' %d: %d: %d\n',n,i,nLoop);
            visited = zeros(1,lastIndexNetworkState + 1 );
            path = zeros(1,maxPathLength);
            visited(orig) = 1;k = orig;
            path(2) = dest; path(3) = orig;
            %Alters((n-1) * nDraws + i, 2) = dest;
            %Alters((n-1) * nDraws + i, 3) = orig;
            t = 4;
            while k ~= dummy
                ind = find(Incidence(k,:)); %.* (1-visited));
                prob = P(k,:); %.* (1-visited);
                %prob = prob / sum(prob);
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
                    path(t) = sInd;
                    visited(sInd) = 1;
                    t = t + 1;
                    if t > maxPathLength
                        break;
                    end
                end
                k = sInd;
            end
            nLoop = nLoop + hasLoop;
            if nbInd == 0
                 path = zeros(1,maxPathLength);
                 continue;
            end
            if t <= maxPathLength
                path(t) = dest;
                choiceSet(i,:) = path;
                i = i + 1;
            end
        end
        % Get number of replications
        np = zeros(1,nDraws);
        for i = 1: nDraws
            np(i) = 0;
            for j = 1: nDraws
                if isequal(choiceSet(i,:),choiceSet(j,:)) == true
                    np(i) = np(i) + 1;
                end
            end            
        end
        for i = 1: nDraws
            choiceSet(i,1) = np(i);
        end
        Alters((n-1) * nDraws + 1 : n * nDraws, :) = choiceSet;
    end
    
    [i,j,val] = find(Alters);
    samples = spconvert([i,j,val]);
    %{
    % Write to sampling file
    save('output/choice_sets_estimation/choice_sets.txt','samples','-ascii');
    %}

    nLoop
    elapsedTime = toc / 60;
    disp(elapsedTime);
end
