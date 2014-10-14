% Compute the loglikelohood value - estimate scale value:
%%
function [LL, grad] = getPSLL_getScale()

    global Gradient;
    global Op;
    global nbobs; 
    global nDraws;   
    global Atts;
    global idxObs;
    global Corr; % Sampling correction
      
    % LOOp ON ALL OBSERVATIONS
    % Compute the LL and gradient.
    grad = zeros(1,Op.n);
    Gradient = zeros(nbobs, Op.n);
    LL = 0;
    idxObs = 1:nbobs;
%     for n = 1:nbobs 
%         v = Op.x * Op.x(1);
%         v(1) = v(1)*(-2.0)/Op.x(1);
%         U = (Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,1:Op.n) * v)' + (Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,Op.n+1) * (-20))' + Corr(1,(idxObs(n)-1)*nDraws + 1:idxObs(n) * nDraws) ;
%         A = Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,1:Op.n);
%         B = Atts((idxObs(n)-1)*nDraws + 1,1:Op.n);
%         C = repmat((exp(U - U(1)))', 1, Op.n);
%         G = (A - B(ones(size(A,1),1),:)) .* C;       
%         lnPn = 0;
%         for i = 1: nDraws
%             lnPn = lnPn + exp(U(i) - U(1)); 
%         end
%         lnPn = - log(lnPn);  
%         LL =  LL + (lnPn - LL)/n;
%     end
%     LL = -1 * LL; % IN ORDER TO HAVE A MIN PROBLEM
%     grad =  [];
    for n = 1:nbobs 
        v = Op.x * Op.x(1);
        v(1) = v(1)*(-2.0)/Op.x(1);
        U = (Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,1:Op.n) * v)' + (Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,Op.n+1) * (-20) * Op.x(1))' + Corr(1,(idxObs(n)-1)*nDraws + 1:idxObs(n) * nDraws) ;
        A = Atts((idxObs(n)-1)*nDraws + 1: idxObs(n) * nDraws,1:Op.n + 1);
        B = Atts((idxObs(n)-1)*nDraws + 1, 1:Op.n + 1);
        C = repmat((exp(U - U(1)))', 1, Op.n );
        D = (A - B(ones(size(A,1),1),:)); E = D(:,1:3);  
        E(:,1) = -2.0 * D(:,1) + Op.x(2) * D(:,2) + Op.x(3) * D(:,3) -20 * D(:,4);
        E(:,2) = Op.x(1) * D(:,2);
        E(:,3) = Op.x(1) * D(:,3);        
        G = E .* C;       
        lnPn = 0;
        for i = 1: nDraws
            lnPn = lnPn + exp(U(i) - U(1)); 
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
end