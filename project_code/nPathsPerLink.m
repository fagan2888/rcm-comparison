% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function M = nPathsPerLink(paths, nDraws)
    %{
    For each observation (choice set) in paths, returns the number of
    alternatives that use each link.

    Those numbers are used in the computation of the path size attribute.
    %}

    if nargin < 2
        nDraws = size(paths, 1);
    end

    global incidenceFull;
   
    loadProjectData();
    
    nLinks = size(incidenceFull, 2);

    paths = paths(:, 3:end);
    nObservations = size(paths, 1) / nDraws;
    paths = reshape(paths', [size(paths, 2) * nDraws, nObservations])';

    M = cellfun(@(links) nPathsPerLinkAux(links, nLinks), ...
                num2cell(full(paths), 2), ...
                'un', 0);
    M = sparse(cell2mat(M));

    
    function M = nPathsPerLinkAux(links, nLinks)
        M = zeros(1, nLinks);
        links(links == 0) = [];
        uniqueLinks = full(unique(links));
        M(uniqueLinks) = histc(full(links), uniqueLinks);
    end
end
