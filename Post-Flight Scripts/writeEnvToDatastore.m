function writeEnvToDatastore(PayloadEnvDatai, FlightFolder, payloadNumber)

if ~isempty(PayloadEnvDatai)
    if length(PayloadEnvDatai.PacketNum) < 2
        fn = fieldnames(PayloadEnvDatai);
        for k=1:numel(fn)-3
            PayloadEnvDatai.(fn{k}) = NaN;
        end
    end
    writetable(PayloadEnvDatai,strcat(FlightFolder,'4-Datastore\PayloadEnvData-',num2str(payloadNumber),'.csv'));
end
end

