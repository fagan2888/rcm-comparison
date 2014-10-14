%   Get analytical Hessian matrix
%   Link size is included
%%
function Hessian = getHessian()
    
    globalVar;
    step = 1e-9;
    x = Op.x;
    h = eye(Op.n) * step;
    H = zeros(Op.n);
    [f,g] = LL(x)
    for i = 1: Op.n
        [f1, g1] = LL(x + h(:,i));
        H(:,i) = (g1 - g)/step;
    end
    Hessian  = H;  
end