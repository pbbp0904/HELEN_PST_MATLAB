DirectoryLocation = "D:/Flight Data/Flight 3/3-Processed Data/";


if ~exist('PayloadEnvData','var')
    load(strcat(DirectoryLocation,"PayloadEnvData.mat"))
end

if ~exist('PayloadRadData','var')
    load(strcat(DirectoryLocation,"PayloadRadData.mat"))
end



%% Todo

%A3
%Check for missed seconds
%Fix sub second calculation
%Fix combining payload data slowness

%%

% Add timing info and missed pulses to radiation data
fprintf('Finding Subsecond Values...\n');
PayloadRadData = findSubSeconds(PayloadRadData);
fprintf('Adding in Missed Pulses...\n');
PayloadRadData = addMissedPulses(PayloadRadData);

% Project back GPS time in environmental data
fprintf('Projecting GPS Time...\n');
PayloadEnvData = projectBackTime(PayloadEnvData);

% Merge radiation and environmental data
mergedDataTables = mergeRadEnvData(PayloadRadData, PayloadEnvData);

% Merge all payload data together into one table
FlightData = combinePayloadData(mergedDataTables);
FlightData = sortrows(FlightData,'gpsTimes');
disp('Done Combining Data!')
toc