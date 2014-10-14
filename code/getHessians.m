%   Get analytical Hessian matrix
%   Link size is included
%%
function Hessians = getHessians()
    
    globalVar;
    step = 1e-9;
    x = Op.x;
    h = eye(Op.n) * step;
    Hessians  =  objArray(nbobs);
    for n = 1: nbobs
        Hessians(n).value = zeros(Op.n); 
    end
    [f,g] = getPSLLs();
    for i = 1: Op.n
        Op.x = x + h(:,i);
        [f1, g1] = getPSLLs();
        for n = 1: nbobs
            Hessians(n).value(:,i) = (g1(n) - g(n))/step; 
            %H(:,i) = (g1 - g)/step;
        end
    end
    Op.x = x;
    %Hessian  = H;  
end