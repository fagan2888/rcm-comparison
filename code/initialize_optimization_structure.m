%   Initialize optimization structure
%%
function [] = initialize_optimization_structure()
    global Op;
    Op.Optim_Method = OptimizeConstant.TRUST_REGION_METHOD;
    %Op.Optim_Method = OptimizeConstant.LINE_SEARCH_METHOD;
    Op.ETA1 = 0.05;
    Op.ETA2 = 0.75;
    Op.maxIter = 150;
    Op.k = 0;
    % Op.n = 4;
    Op.tol = 1e-6;
    Op.x = ones(Op.n,1) * -3;
    Op.radius = 1.0;
    Op.Ak = eye(Op.n);
    Op.H = eye(Op.n); 
end
