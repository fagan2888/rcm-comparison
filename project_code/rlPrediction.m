% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function [utilities, probabilities] = rlPrediction(observations, betas, lsBetas)
    %{
    TODO: Bla bla bla ...
    %}

    global incidenceFull;
    global LSatt;

    useLinkSize = nargin >= 3;
    if ~useLinkSize
        loadProjectData();
    else
        % TODO: This is taking an awful lot of time. Find a solution.
        %       
        %       The link size attribute need only be computed once for each
        %       origin-destination pair.
        %
        %       Further analysis/optimization should still be made. Look at
        %       getLinkSizeAtt.m.
        [obsWithUniqueOD, ~, pathToUniqueIndiceMap] = uniqueOD(observations);
        loadProjectData(lsBetas, obsWithUniqueOD);
    end

    nObservations = size(observations, 1);
    
    utilities = zeros(nObservations, 1);
    probabilities = zeros(nObservations, 1);

    lastIndexNetworkState = size(incidenceFull, 1);

    % TODO: Profile and speed up!!!
    
    transitionUtilitiesFromRegularAttributes = getMRegular(betas');

    for i = 1:nObservations
        i
        transitionUtilities = transitionUtilitiesFromRegularAttributes;
        
        if useLinkSize
            % TODO: Get rid of that global LinkSize variable.

            linkSize = LSatt(pathToUniqueIndiceMap(i)).value;
            transitionUtilities = transitionUtilities + getMLinkSize(betas(5), linkSize);
        end
        
        Mfull = incidenceFull .* exp(transitionUtilities);
        
        % We format M (to match the specifications required by getExpV.m and getP.m ?).
        M = Mfull(1:lastIndexNetworkState, 1:lastIndexNetworkState);
        M(:, lastIndexNetworkState + 1) = sparse(zeros(lastIndexNetworkState, 1));
        M(lastIndexNetworkState + 1, :) = sparse(zeros(1, lastIndexNetworkState + 1));

        % We further format M, based on the current destination.
        destination = observations(i, 1);
        M(1:lastIndexNetworkState, lastIndexNetworkState + 1) = Mfull(:, destination);

        expV = getExpV(M); % TODO What is this?
        P = getP(expV, M); % State-transition matrix.
        
        path = observations(i, 2:end);
        
        % TODO: Get rid of the loop.
        utility = 0.0;
        lnP = 0.0;
        j = 1;

        k = path(j);
        while true
            j = j + 1;
            k_ = path(j);
            if k_ ~= destination
                utility = utility + transitionUtilities(k, k_);
                lnP = lnP + log(P(k, k_));
                k = k_;
            else
                break;
            end
        end

        utilities(i) = utility;
        probabilities(i) = exp(lnP);
    end    
end
