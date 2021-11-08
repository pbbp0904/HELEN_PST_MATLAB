function [FlightData] = combinePayloadData(mergedDataTables)

disp('Merging Payload Data...')

FlightData = [];
FlightData = tall(FlightData);

for i = 1:length(mergedDataTables)
    fprintf('Merging Payload %i Data...\n',i)
    if height(mergedDataTables{i}) > 1
        mergedDataTables{i}.PayloadNumber = i*ones(height(mergedDataTables{i}),1);
        FlightData = [FlightData; mergedDataTables{i}];
    else
        fprintf('Not enough data for payload %i\n', i);
    end
end


end

