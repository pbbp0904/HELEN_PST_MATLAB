%% A3 Todo

% Fix combining payload data slowness
% Transition to datastores - Chris

%%
clear; clc; close all;
FlightFolder = runFile();

DirectoryLocation = strcat(FlightFolder,"4-Datastore\");
tic

PayloadEnvDatastores = readEnvFromDatastore(FlightFolder);
PayloadRadDatastores = readRadFromDatastore(FlightFolder);


%%

% Merge environmental and radiation data
fprintf('Merging Radiation and Environmental Data...\n')
mergedDataTables = mergeRadEnvData(PayloadEnvDatastores, PayloadRadDatastores, DirectoryLocation);

% Merge all payload data together into one table
fprintf('Merging Payload Data...\n')
FlightData = combinePayloadData(mergedDataTables);

% Finalizing time

disp('Done Combining Data!')
toc