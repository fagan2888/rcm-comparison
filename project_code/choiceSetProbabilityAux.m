% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function probability = choiceSetProbabilityAux(probabilities, nDraws)
    %{
    TODO: Bla bla bla ...
    %}

    probability = generate(zeros(size(probabilities)), 1, nDraws);

    function probability = generate(combo, nextIndex, nDraws)
        probability = 0.0;
        if nextIndex == size(combo, 1)
            combo(nextIndex, 1) = nDraws;

            nPermutations = factorial(sum(combo)) / prod(factorial(combo));

            probability = prod(power(probabilities, combo));
            probability = probability * nPermutations;

            return;
        end
        for i = 1:nDraws-1
            combo(nextIndex, 1) = i;
            probability = probability + generate(combo, nextIndex + 1, nDraws - i);
        end
    end
end
