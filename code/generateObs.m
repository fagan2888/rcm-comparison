%   Generate Observatios with link size is include
%   The link size attributes are already computed for all pairs OD
%   --------
%   filename:   Name of file which stores the observations
%   x0:         Given parameters
%   ODpairs:    Matrix with all OD pairs
%   nbobsOD:    Number of generated obs each OD
%%
function ok = generateObs(filename, x0)

    global nbobs;
    global Alters;
    global nDraws;   
    global Atts;
    global Corr; % Sampling correction
    global Op;
    % Generate Obs
    % ----------------------------------------------------  
    
    location = 0;
    scale = 1;
    euler = 0.577215665;
    SmlObs = Alters;
    for n = 1: nbobs
        n
        U = (Atts((n-1)*nDraws + 1: n * nDraws,1:Op.n) * x0)' + Corr(1,(n-1)*nDraws + 1:n * nDraws) +  random('ev',location,scale,1,nDraws) - euler;
        [maxU,ind] = max(U(:));
        v = SmlObs((n-1)*nDraws + 1,:);
        SmlObs((n-1)*nDraws + 1,:) = SmlObs((n-1)*nDraws + ind,:);
        SmlObs((n-1)*nDraws + ind,:) = v;
    end
    % Write to file::
    [i,j,val] = find(SmlObs);
    data_dump = [i,j,val];
    save(filename,'data_dump','-ascii');
    ok = true;
end