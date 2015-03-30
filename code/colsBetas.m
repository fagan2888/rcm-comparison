function cols = colsBetas(nRows, betas)
    nBetas = size(betas, 1);
    cols = zeros(nRows, nBetas);
    for i = 1:nBetas
        cols(:, i) = betas(i);
    end
end
