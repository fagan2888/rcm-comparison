%   Compute Path Size attribute from data
%   
%%
function ok = getPathSizeAtt()
    global incidenceFull; 
    global EstimatedTime;
    global Obs;     % Observation
    global nbobs;
    global nDraws;
    
    % ---------------------------------------
    % Sampling aternatives
    % Compute Path size attribute
    % Compute correction
    % ---------------------------------------
    
    % get Matrix utilities 
    [lastIndexNetworkState, nsize] = size(incidenceFull);
    Ufull =  incidenceFull .* EstimatedTime;
    
    % Sampling aternatives;
    for n = 1:nbobs     
        dest = Obs(n, 1);
        orig = Obs(n, 2);
        % Get utilities matrix
        U = Ufull(1:lastIndexNetworkState,1:lastIndexNetworkState); 
        U(:,lastIndexNetworkState+1) = sparse(zeros(lastIndexNetworkState,1));
        U(lastIndexNetworkState+1,:) = sparse(zeros(1, lastIndexNetworkState + 1));
        U(1:lastIndexNetworkState ,lastIndexNetworkState + 1) = Ufull(:,dest);
        for i = 1:nDraws
            
        end
       
        
        
        
        
        
    end
    
end