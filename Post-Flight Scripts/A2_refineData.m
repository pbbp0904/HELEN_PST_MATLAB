%% A2 Todo

% Check for missed seconds
% Fix sub second calculation

%%
DirectoryLocation = "D:/Flight Data/Flight 3/3-Processed Data/";
tic

if ~exist('PayloadEnvData','var')
    load(strcat(DirectoryLocation,"PayloadEnvData.mat"))
end

if ~exist('PayloadRadData','var')
    load(strcat(DirectoryLocation,"PayloadRadData.mat"))
end



%% Refine Env Data

% Project back GPS time to start
fprintf('Projecting GPS Time...\n');
PayloadEnvData = projectBackTime(PayloadEnvData);

% Add cartesian distance from SWIRLL
fprintf('Calculating Cartesian Distances...\n');
PayloadEnvData = calcSWIRLLDistance(PayloadEnvData);

% Save Env Data
fprintf('Saving Enviornmental Data...\n');
save(strcat(FlightFolder,"3-Processed Data\PayloadEnvData-Refined.mat"),'PayloadEnvData','-v7.3');
fprintf('Done Saving Enviornmental Data...\n');




%% Refine Rad Data

% Calculate subsecond values for pulses
fprintf('Finding Subsecond Values...\n');
PayloadRadData = findSubSeconds(PayloadRadData);

% Add missing pulses to the data table
fprintf('Adding in Missed Pulses...\n');
PayloadRadData = addMissedPulses(PayloadRadData);

% Save Rad Data
fprintf('Saving Radiation Data...\n');
save(strcat(FlightFolder,"3-Processed Data\PayloadRadData-Refined.mat"),'PayloadRadData','-v7.3');
fprintf('Done Saving Radiation Data...\n');

toc