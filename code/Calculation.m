global Alters;
global nbobs;
global nDraws;
C = zeros(nbobs,1);
for n =1:nbobs
    n
    choiceSet = Alters((n-1)* nDraws + 1: n* nDraws,2:end);
    cs = unique(choiceSet, 'rows');
    C(n) = size(cs,1);
end
hist(C,20);