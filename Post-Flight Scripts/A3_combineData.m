%% A3 Todo

% Fix combining payload data slowness
% Transition to datastores

%%
DirectoryLocation = "D:\MATLAB\HELEN Data\Flight 2\3-Processed Data\";
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