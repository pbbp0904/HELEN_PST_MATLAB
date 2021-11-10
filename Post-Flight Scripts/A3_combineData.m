%% A3 Todo

% Fix combining payload data slowness
% Transition to datastores

%%
FlightFolder = "D:\Flight Data\Flight 2\";
%FlightFolder = "D:\MATLAB\HELEN Data\Flight 2\";

DirectoryLocation = strcat(FlightFolder,"3-Processed Data");
tic

if ~exist('PayloadEnvData','var')
    load(strcat(DirectoryLocation,"PayloadEnvData-Refined.mat"))
end

if ~exist('PayloadRadData','var')
    load(strcat(DirectoryLocation,"PayloadRadData-Refined.mat"))
end


%%

% Merge environmental and radiation data
mergedDataTables = mergeRadEnvData(PayloadEnvData, PayloadRadData, DirectoryLocation);

% Merge all payload data together into one table
FlightData = combinePayloadData(mergedDataTables);
FlightData = sortrows(FlightData,'gpsTimes');
disp('Done Combining Data!')
toc