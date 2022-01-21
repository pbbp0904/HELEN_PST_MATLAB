function [PayloadRadData] = readRadFromDatastore(FlightFolder)

a = dir(strcat(FlightFolder, '4-Datastore\*.csv'));
numberOfFiles = numel(a);
maxPayloadNumber = floor(numberOfFiles/4);

for payloadNumber = 1:maxPayloadNumber
    try
        d = datastore(strcat(FlightFolder,'4-Datastore\PayloadRadData-',num2str(payloadNumber),'.csv'));
        PayloadRadData{payloadNumber} = d;
    catch
        fprintf("Could not load rad data for payload %i.\n",payloadNumber);
    end
end
end
