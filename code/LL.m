function [f g] = LL(x)
    global Op;
    Op.x = x;
    [f g] = getPSLL(); % getLL();
    Op.nFev  = Op.nFev + 1;
%     step = 1e-6;
%     H = eye(Op.n) * step;
%     Op.x = x;
%     grad = zeros(Op.n,1);
%     value = getPSLL_getScale();
%     for i = 1:Op.n
%         Op.x = x + H(:,i);
%         vl = getPSLL_getScale();
%         grad(i) = (getPSLL_getScale() - value)/step;
%     end
%     f = value;
%     g = grad;
%     Op.x = x;
end
