%% A3 Todo

% Fix combining payload data slowness
% Transition to datastores - Chris

%%
clear; clc; close all;
FlightFolder = runFile();

DirectoryLocation = strcat(FlightFolder,"4-Datastore\");
tic

PayloadEnvData = readEnvFromDatastore(FlightFolder);
PayloadRadData = readRadFromDatastore(FlightFolder);


%%

% Merge environmental and radiation data
mergedDataTables = mergeRadEnvData(PayloadEnvData, PayloadRadData, DirectoryLocation);

% Merge all payload data together into one table
FlightData = combinePayloadData(mergedDataTables);
FlightData = sortrows(FlightData,'gpsTimes');
disp('Done Combining Data!')
toc