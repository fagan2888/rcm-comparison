% Compute the loglikelohood value and its gradient.
%%
function [LL, grad, betas] = getPSLL()

    global Gradient;
    global Op;
    global nbobs; 
    global nDraws;   
    global Atts;
    global Alters;
    global idxObs;
    global Corr; % Sampling correction
    global isFixedUturn;
    
    % mu = 6.456908e-01;
    mu = 1.0;
    grad = zeros(1,Op.n);
    Gradient = zeros(nbobs, Op.n);
    LL = 0;
    %  idxObs = 1:nbobs;
    % LOOp ON ALL OBSERVATIONS
    % Compute the LL and gradient.

    disp(nbobs);
    disp(size(idxObs));
    disp(size(Atts));
    disp(Op.x);
    disp(size(Corr));

    for n = 1:nbobs 
        if isFixedUturn == true
            U = (Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,1:Op.n) * (Op.x * mu))' + (Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,Op.n+1) * (-20) * mu)' + Corr(1,(idxObs(n)-1)*nDraws + 1:idxObs(n) * nDraws) ;
        else
            U = (Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,1:Op.n) * (Op.x * mu))' + Corr(1,(idxObs(n)-1)*nDraws + 1:idxObs(n) * nDraws) ;
        end
        K = Alters((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,1)';
        V = (exp(U - U(1))) ./ K;
        A = Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,1:Op.n) * mu;
        B = Atts((idxObs(n)-1)*nDraws + 1,1:Op.n) * mu;
        C = repmat(V', 1, Op.n);
        D = (A - B(ones(size(A,1),1),:));  
        G = D .* C;       
        lnPn = 0;
        for i = 1: nDraws
            lnPn = lnPn + V(i); 
            Gradient(n,:) = Gradient(n,:) + G(i,:); 
        end
        Gradient(n,:) = - Gradient(n,:) / lnPn;
        lnPn = - log(lnPn);  
        LL =  LL + (lnPn - LL)/n;
        grad = grad + (Gradient(n,:) - grad)/n;
        Gradient(n,:) = - Gradient(n,:);
    end
    LL = -1 * LL; % IN ORDER TO HAVE A MIN PROBLEM
    grad =  - grad';
    betas = Op.x;
end
