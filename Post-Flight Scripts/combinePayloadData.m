function [FlightData] = combinePayloadData(mergedDataTables)

FlightData = mergedDataTables{1};

for i = 2:length(mergedDataTables)
    FlightData = [FlightData; mergedDataTables{i}];
end

end