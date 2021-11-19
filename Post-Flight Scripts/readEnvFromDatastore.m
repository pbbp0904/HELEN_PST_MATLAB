function [PayloadEnvData] = readEnvFromDatastore(FlightFolder)

for payloadNumber = 1:10
    try
        d = datastore(strcat(FlightFolder,'4-Datastore\PayloadEnvData-',num2str(payloadNumber),'.csv'));
        PayloadEnvData{payloadNumber} = d;
    catch
    end
end
end

