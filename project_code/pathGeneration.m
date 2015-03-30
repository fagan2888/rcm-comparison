% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function paths = pathGeneration(observations, ...
                                label, ...
                                nDraws, ...
                                betas, ...
                                includeObs, ...
                                varargin)
    %{
    For each observation, nDraws paths are generated with a recursive logit
    model parametrized by betas.
    
    Returns a structure array:
    - paths.label           
    - paths.rngSeed         % Seed that was used to generate the paths.
    - paths.nDraws          % Total number of draws. Includes the number of draws
                            % from the nest.
    - paths.betas
    - paths.includeObs
    - paths.nestFile        % The file where the nest is stored.
    - paths.paths           % Does not include the paths from the nest.

    The structure array will be saved at    
    'path_cache/label_rngSeed_nDraws_betas[_wObs].mat'.

    The label argument can be seen as an id for the set of observations.
    TODO: Would it be a good idea to use a structure array to represent a dataset?
   
    varargin:
    ---------
    - nest:     paths structure array to use as a nest for this new paths
                structure array.
    - rngSeed:  One will be generated if not provided.
    %}

    CACHE_DIR = 'path_cache';

    rng('shuffle')
    
    ip = inputParser;
    ip.addRequired('observations');
    ip.addRequired('label');
    ip.addRequired('nDraws');
    ip.addRequired('betas');
    ip.addRequired('includeObs');
    ip.addOptional('rngSeed', randi(9999));
    ip.addOptional('nest', []);

    ip.parse(observations, label, nDraws, betas, includeObs, varargin{:});
    opts = ip.Results;

    % We check if the paths can be retrieved from the cache.
    file = filename(opts.label, ...
                    opts.rngSeed, ...
                    opts.nDraws, ...
                    opts.betas, ...
                    opts.includeObs);
    try
        cachedVariables = load(file);
        paths = cachedVariables.paths;
        disp(sprintf('Paths were loaded from %s.', file));
        return;
    catch
       % Nothing. 
    end

    % No previously generated paths. We generate them.
    nDraws_ = opts.nDraws;
    nestFile = '';
    if ~isempty(opts.nest)
        if opts.nest.nDraws >= opts.nDraws
            error('nest.nDraws must be smaller than nDraws.');
        end
        if opts.includeObs
            warning('Adding paths to a nest while including the observations.');
        end
        nDraws_ = nDraws_ - opts.nest.nDraws;
        nestFile = filenameFromPaths(opts.nest);
        % TODO: Check if nestFile actually exists.
    end

    rng(opts.rngSeed);
    loadProjectData();
    newPaths = pathsSampling(observations, nDraws_, opts.betas', opts.includeObs);
     
    paths.label = opts.label;
    paths.rngSeed = opts.rngSeed;
    paths.nDraws = opts.nDraws;
    paths.betas = opts.betas;
    paths.includeObs = opts.includeObs;
    paths.nestFile = nestFile;
    paths.paths = newPaths;

    % We save the paths structure array.
    save(file, 'paths');
    disp(sprintf('Paths were saved at %s.', file));

    
    function file = filename(label, seed, nDraws, betas, includeObs)
        includeObsStr = '';
        if includeObs
            includeObsStr = '_wObs';
        end
        
        betasStr = floatsToString(betas');

        file = sprintf('%s/%s_%d_%d_%s%s.mat', ...
                       CACHE_DIR, label, seed, nDraws, betasStr, includeObsStr);
    end

    function file = filenameFromPaths(paths)
        file = filename(paths.label, ...
                        paths.rngSeed, ...
                        paths.nDraws, ...
                        paths.betas, ...
                        paths.includeObs);
    end
end
