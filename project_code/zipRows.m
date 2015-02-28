% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function matrix = zipRows(matrices, N)
    %{
    Zip the rows from a cell array of matrices (matrix_1, matrix_2, ...,
    matrix_m).
     
    N is expected to be an array of length m, n_1, n_2, ..., n_m, where n_i is
    the number of rows from matrix_i to zip during each iteration.
     
    The resulting matrix is composed of:
        - the first n_1 rows of matrix_1,
        - then the first n_2 rows of matrix_2,
        - ...
        - then the first n_m rows from matrix_m,
        - then the next n_1 rows from matrix_1,
        - then the next n_2 rows from matrix_2,
        - ...

    It is assumed that the height of matrix_i % n_i = 0.
    TODO: Not assume that height % n = 0 ?

    It is also assumed that the height of all the matrices are compatible with
    respect to N, that is #rows / n is the same for every matrix.
    %}
    
    totalNumberOfRows = sum(arrayfun(@(x) size(x{:}, 1), matrices));
    maxWidth = max(arrayfun(@(x) size(x{:}, 2), matrices));
    matrix = zeros(totalNumberOfRows, maxWidth);

    cursor = 1;
    nIterations = size(matrices{1}, 1) / N(1);
    for i = 1:nIterations
        for j = 1:size(matrices, 2)
            cursorIndices = cursor:cursor+N(j)-1;

            width = size(matrices{j}, 2);
            
            startIndex = (i - 1) * N(j) + 1;
            rowIndices = startIndex:startIndex+N(j)-1;
            
            matrix(cursorIndices, 1:width) = matrices{j}(rowIndices, :);
            
            cursor = cursor + N(j);
        end
    end
end
