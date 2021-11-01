%tic
%DirectoryLocation = "D:/Flight Data/Flight 3/3-Processed Data/";
%load(strcat(DirectoryLocation,"Rad-Env_Data.mat"))
%toc

%% Todo

%A3
%Check for missed seconds
%Add UTC time column to RAD data table
%Add ENV data to each RAD data table
%Combine all payload radiation tables into 1 table

%%

mergedDataTables = mergeRadEnvData(PayloadRadData, PayloadEnvData);
CombinedData = combinePayloadData(mergedDataTables);