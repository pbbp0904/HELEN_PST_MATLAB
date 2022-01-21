function [PayloadEnvData] = readEnvFromDatastore(FlightFolder)

a = dir(strcat(FlightFolder, '4-Datastore\*.csv'));
numberOfFiles = numel(a);
maxPayloadNumber = floor(numberOfFiles/4);

for payloadNumber = 1:maxPayloadNumber
    try
        d = datastore(strcat(FlightFolder,'4-Datastore\PayloadEnvData-',num2str(payloadNumber),'.csv'));
        PayloadEnvData{payloadNumber} = d;
    catch
        fprintf("Could not load env data for payload %i.\n",payloadNumber);
    end
end
end

