function [PayloadEnvData] = calcSWIRLLDistance(PayloadEnvData)
SWIRLL = [ 34.72498, -86.64615, 210];

for i = 1:length(PayloadEnvData)
    if ~isempty(PayloadEnvData{i})
        lats = PayloadEnvData{i}.gpsLats;
        longs = PayloadEnvData{i}.gpsLongs;
        alts = PayloadEnvData{i}.gpsAlts;

        [xEast,yNorth,zUp] = latlon2local(lats,longs,alts,SWIRLL);

        PayloadEnvData{i}.xEast = xEast;
        PayloadEnvData{i}.yNorth = yNorth;
        PayloadEnvData{i}.zUp = zUp;
    end

end
