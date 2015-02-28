% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function paths = pathGeneration(observations, label, nDraws, samplingBetas, varargin)
    %{
    For each observation, nDraws paths are generated with a recursive logit
    model parametrized by samplingBetas.
    
    Returns a structure array:
    - paths.label           
    - paths.rngSeed         % Seed that was used to generate the paths.
    - paths.nDraws          % Total number of draws. Includes the number of draws
                            % from the nest.
    - paths.samplingBetas
    - paths.nestFile        % The file where the nest is stored.
    - paths.paths           % Does not include the paths from the nest.

    The structure array will be saved at
    'path_cache/label_rngSeed_nDraws_samplingBetas.mat'.

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
    ip.addRequired('samplingBetas');
    ip.addOptional('rngSeed', randi(9999));
    ip.addOptional('nest', []);

    ip.parse(observations, label, nDraws, samplingBetas, varargin{:});
    opts = ip.Results;

    % We check if the paths can be retrieved from the cache.
    file = filename(opts.label, ...
                    opts.rngSeed, ...
                    opts.nDraws, ...
                    opts.samplingBetas);
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
        nDraws_ = nDraws_ - opts.nest.nDraws;
        nestFile = filenameFromPaths(opts.nest);
        % TODO: Check if nestFile actually exists.
    end

    rng(opts.rngSeed);
    newPaths = pathsSampling(observations, nDraws_, opts.samplingBetas);
     
    paths.label = opts.label;
    paths.rngSeed = opts.rngSeed;
    paths.nDraws = opts.nDraws;
    paths.samplingBetas = opts.samplingBetas;
    paths.nestFile = nestFile;
    paths.paths = newPaths;

    % We save the paths structure array.
    save(file, 'paths');
    disp(sprintf('Paths were saved at %s.', file));

    
    function file = filename(label, seed, nDraws, betas)
        file = sprintf('%s/%s_%d_%d_%s.mat', ...
                       CACHE_DIR, label, seed, nDraws, floatsToString(betas'));
    end

    function file = filenameFromPaths(paths)
        file = filename(paths.label, ...
                        paths.rngSeed, ...
                        paths.nDraws, ...
                        paths.samplingBetas);
    end
end
