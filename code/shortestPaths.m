% Shortest path in the large scale network
%
disp('Loading data ...')

global file_AttEstimatedtime;
global file_linkIncidence;
global file_observations;
global file_turnAngles;

file_linkIncidence = './Input/linkIncidence.txt';
file_AttEstimatedtime = './Input/ATTRIBUTEestimatedtime.txt';
file_turnAngles = './Input/ATTRIBUTEturnangles.txt';
file_observations = './Input/observationsForEstimBAI.txt';

%   Load link indidence
global incidenceFull;
incidenceFull = spconvert(load(file_linkIncidence));
[lastIndexNetworkState, n] = size(incidenceFull);

%   Load estimated time
%   Adjust the size to account for dummy links
%   att1 ~ EstimatedTime
global EstimatedTime;
EstimatedTime = spconvert(load(file_AttEstimatedtime));
EstimatedTime(lastIndexNetworkState,n)=0;

EstimatedTime = EstimatedTime .* incidenceFull;

Weight = EstimatedTime(1:lastIndexNetworkState,1:lastIndexNetworkState);
[dist,path,pred] = graphshortestpath(Weight,1,7288)

