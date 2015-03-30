% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function loadProjectData(lsBetas, observations)
    %{
    TODO: Bla bla bla ...

    observations is considered only when lsBetas is provided.
    %}

    global file_linkIncidence;
    global file_AttEstimatedtime;
    global file_turnAngles;

    file_linkIncidence = 'data/linkIncidence.txt';
    file_AttEstimatedtime = 'data/ATTRIBUTEestimatedtime.txt';
    file_turnAngles = 'data/ATTRIBUTEturnangles.txt';

    if nargin == 0
        loadData();
    else
        % TODO: Rewrite loadData.m so that we don't need the global variable Obs.

        global Obs;
        Obs = observations;
        
        loadData(lsBetas');
    end
end
