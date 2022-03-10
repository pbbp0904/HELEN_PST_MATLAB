%% A3


%%
clear; close all;
FlightFolder = runFile();

DirectoryLocation = strcat(FlightFolder,"4-Datastore\");
tic

if isfolder(FlightFolder + '5-FlightData') == 0
    mkdir(FlightFolder, '5-FlightData');
end

PayloadEnvDatastores = readEnvFromDatastore(FlightFolder);
PayloadRadDatastores = readRadFromDatastore(FlightFolder);


%%

% Merge environmental and radiation data
fprintf('Merging Radiation and Environmental Data...\n')
mergedDataTables = mergeRadEnvData(PayloadEnvDatastores, PayloadRadDatastores, DirectoryLocation);

% Merge all payload data together into one table
fprintf('Merging Payload Data...\n')
FlightData = combinePayloadData(mergedDataTables);

% Save Flight Data
fprintf('Saving Flight Data...\n');
save(strcat(FlightFolder,"5-FlightData\FlightData.mat"),'FlightData','-v7.3');
fprintf('Done Saving Flight Data!\n');

toc