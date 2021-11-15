function writeRadToDatastore(PayloadRadDatai, FlightFolder, payloadNumber)

if ~isempty(PayloadRadDatai)
    writetable(array2table(PayloadRadDatai.pulsedata_a),strcat(FlightFolder,'4-Datastore\PayloadRadPulseAData-',num2str(payloadNumber),'.csv'));
    writetable(array2table(PayloadRadDatai.pulsedata_b),strcat(FlightFolder,'4-Datastore\PayloadRadPulseBData-',num2str(payloadNumber),'.csv'));
    PayloadRadDatai.pulsedata_a = [];
    PayloadRadDatai.pulsedata_b = [];
    writetable(PayloadRadDatai,strcat(FlightFolder,'4-Datastore\PayloadRadData-',num2str(payloadNumber),'.csv'));
end


end

