%% A3 Todo

% Fix combining payload data slowness
% Transition to datastores - Chris

%%
clear; clc; close all;

%FlightFolder = "D:\Flight Data\Testing\Database Test\";
%FlightFolder = "C:\Users\Sean\Desktop\UAH\SHC\HELEN\HELEN_Data\Flight 2\";
FlightFolder = "D:\Flight Data\Flight 2\";
%FlightFolder = "D:\MATLAB\HELEN Data\Flight 2\";

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