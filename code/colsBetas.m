function cols = colsBetas(nRows, betas)
    cols = zeros(nRows, 4);                        
    cols(:, 1) = betas(1);
    cols(:, 2) = betas(2);
    cols(:, 3) = betas(3);
    cols(:, 4) = betas(4);
end
