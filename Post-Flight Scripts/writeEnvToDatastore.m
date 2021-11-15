function writeEnvToDatastore(PayloadEnvDatai, FlightFolder, payloadNumber)

if ~isempty(PayloadEnvDatai)
    writetable(PayloadEnvDatai,strcat(FlightFolder,'4-Datastore\PayloadEnvData-',num2str(payloadNumber),'.csv'));
end
end

