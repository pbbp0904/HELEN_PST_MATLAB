%% A2 Todo

% Check for missed seconds
% Fix sub second calculation

%%
FlightFolder = "D:\Flight Data\Flight 2\";
%FlightFolder = "D:\MATLAB\HELEN Data\Flight 2\";

DirectoryLocation = strcat(FlightFolder,"3-Processed Data\");
tic

if ~exist('PayloadEnvData','var')
    fprintf('Loading Environmental Data...\n');
    load(strcat(DirectoryLocation,"PayloadEnvData.mat"))
end

if ~exist('PayloadRadData','var')
    fprintf('Loading Radiation Data...\n');
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
PayloadEnvData = tall(PayloadEnvData);
write(strcat(FlightFolder,"4-Datastore\PayloadEnvData-Refined.mat"),PayloadEnvData);
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
PayloadRadData = tall(PayloadRadData);
write(strcat(FlightFolder,"4-Datastore\PayloadRadData-Refined.mat"),PayloadRadData);
fprintf('Done Saving Radiation Data...\n');

toc