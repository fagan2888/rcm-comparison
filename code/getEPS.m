%   Get Expanded PS
%%
function isDone = getEPS()
    global Alters;
    global EstimatedTime;
    global Op;
    global nDraws;   
    global Atts;
    global Obs;
    global incidenceFull;
    
    lastIndexNetworkState = size(incidenceFull,1);
    lastDestNode = size(incidenceFull,2);
    disp('Calculating path size logit attributes ...');    
    I = find(EstimatedTime);
    travelTime = zeros(size(EstimatedTime,2));
    beta = [-1.8,-0.9,-0.8,-4.0]';
    Mfull = getM(beta,false);
    M = Mfull(1:lastIndexNetworkState,1:lastIndexNetworkState);
    M(:,lastIndexNetworkState+1) = sparse(zeros(lastIndexNetworkState,1));
    M(lastIndexNetworkState+1,:) = sparse(zeros(1, lastIndexNetworkState + 1));
        
    for i = 1: size(I,1);
       [k, a] =  ind2sub(size(EstimatedTime), I(i));
       travelTime(a) = EstimatedTime(k,a);
    end
    nPaths = size(Alters,1);
    disp(size(Atts));
    for n = 1:nPaths
        if mod(n,nDraws) == 0
            fix(n/nDraws);
        end
        
        % Get path probabilities
        
        ob = fix(n/nDraws)+1;
        if (mod(n,nDraws) == 1)
            dest = Obs(ob, 1);
            orig = Obs(ob, 2);      
            % Get probabilities       
            M(1:lastIndexNetworkState ,lastIndexNetworkState + 1) = Mfull(:,dest);
            [expV, expVokBool] = getExpV(M); % vector with value functions for given beta
            if (expVokBool == 0)
               isDone = false;
               disp('ExpV is not fesible')
               return;
            end  
            P = getP(expV, M);
            
            U = Alters((ob-1)*nDraws+1: ob * nDraws,:);
            U = unique(U,'rows');
            prob = zeros(nDraws, size(U,1));
            for i = 1: size(U,1);
               path = U(i,:);
               lpath = size(find(path),2);
               path(lpath) = lastIndexNetworkState + 1;
               prob(i) = 1;
               for j = 3 : lpath - 1
                   prob(i) = prob(i) * P(path(j),path(j+1));
               end
            end
            
            prob = prob /sum(prob);
            % Compute EPS factor
            Phi = zeros(size(U,1),1);
            for i = 1: size(U,1)
                Phi = 1/(prob * size(U,1));
                Phi(Phi <= 1) = 1;
            end
            % Compute the M factor
            Meps = zeros(1,lastDestNode);
            for i = 1: size(U,1)
               V = U(i,3:end);
               V(V == 0) = [];
               unqV = unique(V);
               Meps(unqV) = Meps(unqV) + Phi(i);
            end
        end
        path = Alters(n,:);
        lpath = size(find(path),2);
        if Op.n == 5
            % Path Size attribute, use travel time as the length of link   
            ps = 0;
            for i = 3: lpath
               link = path(i);
               ps = ps + travelTime(link)/Meps(link);
            end
            Atts(n,5) = log(ps/Atts(n,1));
        end    
    end
end
