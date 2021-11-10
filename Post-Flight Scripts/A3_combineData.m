%% A3 Todo

% Fix combining payload data slowness
% Transition to datastores

%%
clear; clc; close all;

FlightFolder = "D:\Flight Data\Flight 2\";
%FlightFolder = "D:\MATLAB\HELEN Data\Flight 2\";

DirectoryLocation = strcat(FlightFolder,"3-Processed Data\");
tic

PayloadEnvData = datastore(strcat(DirectoryLocation,"PayloadEnvData-Refined.mat"),'Type','tall');

PayloadRadData = datastore(strcat(DirectoryLocation,"PayloadRadData-Refined.mat"),'Type','tall');


%%

% Merge environmental and radiation data
mergedDataTables = mergeRadEnvData(PayloadEnvData, PayloadRadData, DirectoryLocation);

% Merge all payload data together into one table
FlightData = combinePayloadData(mergedDataTables);
FlightData = sortrows(FlightData,'gpsTimes');
disp('Done Combining Data!')
toc