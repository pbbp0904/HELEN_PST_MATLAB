function [mergedDataTables] = mergeRadEnvData(PayloadEnvDatastores, PayloadRadDatastores)
startingRADSecond = 9;


disp('Merging Radiation and Environmental Data...')
parfor i = 1:length(PayloadEnvDatastores)
    
    PayloadRadDatastores{i}.SelectedVariableNames = {'pulseNum','subSecond','dcc_time','pps_time'};
    PayloadEnvDatastores{i}.SelectedVariableNames = {'gpsTimes','xEast','yNorth','zUp'};
    PayloadRadDatastores{i}.readSize = "file";
    PayloadEnvDatastores{i}.readSize = "file";
    
    PayloadRadData{i} = read(PayloadRadDatastores{i});
    PayloadEnvData{i} = read(PayloadEnvDatastores{i});
    
    if height(PayloadRadData{i}) > 1 && height(PayloadEnvData{i}) > 1
        subSeconds = PayloadRadData{i}.subSecond;
        dcc_time = PayloadRadData{i}.dcc_time;
        pps_time = PayloadRadData{i}.pps_time;

        radSeconds = zeros(1,length(subSeconds));
        radSeconds(1) = startingRADSecond;

        for j = 2:length(subSeconds)
            if (dcc_time(j-1) < pps_time(j-1) && dcc_time(j) >= pps_time(j) && dcc_time(j) >= pps_time(j-1)) || (pps_time(j-1) == 0 && subSeconds(j-1)>subSeconds(j))
                radSeconds(j) = radSeconds(j-1)+1;
            else
                radSeconds(j) = radSeconds(j-1);
            end
        end

        EnvDataInterp = zeros(length(subSeconds),32);
        interpVals = [2,3,4];
        otherVals = [1];

        for m = interpVals
            x = PayloadEnvData{i}.PacketNum;
            v = table2array(PayloadEnvData{i}(:,m));
            xq = radSeconds+subSeconds';
            EnvDataInterp(:,m) = interp1(x,v,xq);
        end

        for m = otherVals
            x = PayloadEnvData{i}.PacketNum;
            v = table2array(PayloadEnvData{i}(:,m));
            xq = radSeconds;
            EnvDataInterp(:,m) = interp1(x,v,xq);
        end

        mergedDataTables{i}.gpsTimes = EnvDataInterp(:,20);
        mergedDataTables{i}.subSeconds = subSeconds';
        mergedDataTables{i}.gpsLats = EnvDataInterp(:,21);
        mergedDataTables{i}.gpsLongs = EnvDataInterp(:,22);
        mergedDataTables{i}.gpsAlts = EnvDataInterp(:,25);
        mergedDataTables{i}.pulse_num = PayloadRadData{i}.pulse_num;
        fprintf('Done with %i\n', i);
    else
        mergedDataTables{i}.gpsTimes = missing;
        mergedDataTables{i}.subSeconds = missing;
        mergedDataTables{i}.gpsLats = missing;
        mergedDataTables{i}.gpsLongs = missing;
        mergedDataTables{i}.gpsAlts = missing;
        mergedDataTables{i}.pulse_num = missing;
        fprintf('Not enough data for payload %i\n', i);
    end
end


end