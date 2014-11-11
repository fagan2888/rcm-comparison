% Calculate path attribute
% Travel time, Left turn, LC, Path Size
% Sampling correction
function isDone = getPathAttributes(samplingBetas)
    %{
    samplingBetas: Parameters that were used to generate the choice sets and
                   that we use here for sampling correction.
    %}

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
    % global Pro;
    
    lastIndexNetworkState = size(incidenceFull,1);
    lastDestNode = size(incidenceFull,2);
    disp('Calculating path size logit attributes ...');    
    I = find(EstimatedTime);
    J = find(LeftTurn);
    travelTime = zeros(size(EstimatedTime,2));
    LC = zeros(size(LeftTurn,2));
    for i = 1: size(I,1);
       [k, a] =  ind2sub(size(EstimatedTime), I(i));
       travelTime(a) = EstimatedTime(k,a);
    end
    
    for i = 1: size(J,1);
       [k, a] =  ind2sub(size(LeftTurn), J(i));
       LC(a) = LeftTurn(k,a);
    end    
%     nEles = nDraws + 1;
%     choiceSet = zeros(size(Alters,1)+ nbobs, size(Alters,1));
%     for n = 1:nbobs
%         choiceSet((n-1)*nEles+1,:) = Obs();
%     end

    disp(Op.n);
    nPaths = size(Alters,1);
    disp(nPaths);
    Atts = sparse(zeros(Op.n,nPaths));
    disp(size(Atts));
    Corr = sparse(zeros(1,nPaths));
    for n = 1:nPaths
        if mod(n,nDraws) == 0
            fix(n/nDraws);
        end
        path = Alters(n,:);
        lpath = size(find(path),2);
        % Compute regular attributes
        for i = 3: lpath - 1
            Atts(1,n) = Atts(1,n) +  travelTime(path(i+1));
            Atts(2,n) = Atts(2,n) +  TurnAngles(path(i),path(i+1));
            Atts(3,n) = Atts(3,n) +  LC(path(i+1));
            Atts(4,n) = Atts(4,n) +  Uturn(path(i),path(i+1));
        end
        Atts(1,n) = Atts(1,n) + travelTime(path(3));
        Atts(3,n) = Atts(3,n) +  LC(path(3));
        if Op.n == 5
            M = zeros(1,lastDestNode);
            U = Alters(fix((n-1)/nDraws)*nDraws + 1:fix((n-1)/nDraws)*nDraws + nDraws,3:end);
            U(U == 0) = [];
            unqU = unique(U);
            histU =  histc(full(U),full(unqU));
            M(unqU) = histU;
            % Path Size attribute, use travel time as the length of link        
            for i = 3: lpath
               link = path(i);
               Atts(5,n) = Atts(5,n) + travelTime(link)/M(link);
            end
            Atts(5,n) = Atts(5,n)/Atts(1,n);
        end
        % Extened path size ....
    end
    Atts = Atts';
    disp(size(Atts));
    % Sampling correction
    % beta = [-1.8,-0.9,-0.8,-4.0]';
    beta = samplingBetas;
    % loadData; % Recursive logit
    Mfull = getM(beta,false);    
    M = Mfull(1:lastIndexNetworkState,1:lastIndexNetworkState); 
    M(:,lastIndexNetworkState+1) = sparse(zeros(lastIndexNetworkState,1));
    M(lastIndexNetworkState+1,:) = sparse(zeros(1, lastIndexNetworkState + 1));  
    
    for n = 1:nbobs
        % n
        dest = Obs(n, 1);
        orig = Obs(n, 2);      
        % Get probabilities       
        M(1:lastIndexNetworkState ,lastIndexNetworkState + 1) = Mfull(:,dest);
        [expV, expVokBool] = getExpV(M); % vector with value functions for given beta                                                                     
        if (expVokBool == 0)
           isDone = false;
           disp('ExpV is not fesible')
           return; 
        end  
        P = getP(expV, M);
       % Pro(n) = P;
        prob = zeros(nDraws, 1);
        for i = (n-1)*nDraws+1: n * nDraws
           path = Alters(i,:);
           lpath = size(find(path),2);
           path(lpath) = lastIndexNetworkState + 1;
           prob(i) = 1;
           for j = 3 : lpath - 1
               prob(i) = prob(i) * P(path(j),path(j+1));
           end
           Corr(i) = log(path(1));
        end
        prob = prob /sum(prob);
        for i = (n-1)*nDraws+1: n * nDraws
            Corr(i) = Corr(i) - log(prob(i));
        end
    end
    isDone = true;
end
