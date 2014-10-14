%   Generate obs
%%
global Op;
disp('Observation generating ....')
Op.n = 4;
x0 = [-1.8,-0.9,-0.8,-4.0]';
filename = './simulatedData/SimulatedObs_NoPS.txt';
generateObs(filename, x0);
