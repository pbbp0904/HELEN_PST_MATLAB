function [PayloadRadData] = readRadFromDatastore(FlightFolder)

for payloadNumber = 1:10
    try
        d = datastore(strcat(FlightFolder,'4-Datastore\PayloadRadData-',num2str(payloadNumber),'.csv'));
        PayloadRadData{payloadNumber} = d;
    catch
    end
end
end
