function [FlightData] = combinePayloadData(mergedDataTables)

disp('Merging Payload Data...')

FlightData = [];
%FlightData = tall(FlightData);

for j = 1:length(mergedDataTables)
    fprintf('Merging Payload %i Data...\n',j)
    if ~isempty(FlightData)
        if height(mergedDataTables{j}.gpsTimes) > 1
            mergedDataTables{j}.PayloadNumber = j*ones(length(mergedDataTables{j}.gpsTimes),1);
            FlightData = [FlightData; struct2table(mergedDataTables{j})];
        else
            fprintf('Not enough data for payload %i\n', j);
        end
    else
        if height(mergedDataTables{j}.gpsTimes) > 1
            mergedDataTables{j}.PayloadNumber = j*ones(length(mergedDataTables{j}.gpsTimes),1);
            FlightData = struct2table(mergedDataTables{j});
        else
            fprintf('Not enough data for payload %i\n', j);
        end
    end
end

FlightData = sortrows(FlightData,{'gpsTimes'});
FlightData.time = round((FlightData.gpsTimes-FlightData.gpsTimes(1)).*(3600*24)) + round(FlightData.subSeconds,9);
FlightData = movevars(FlightData,'time','Before','gpsTimes');
FlightData = sortrows(FlightData,{'time','PayloadNumber'});


end

