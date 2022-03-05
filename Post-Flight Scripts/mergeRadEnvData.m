function [mergedDataTables] = mergeRadEnvData(PayloadEnvDatastores, PayloadRadDatastores, DirectoryLocation)
startingRADSecond = 9;



for i = 1:length(PayloadEnvDatastores)
    
    PayloadRadDatastores{i}.SelectedVariableNames = {'pulse_num','subSecond','dcc_time','pps_time','isTail','EPeakB'};
    PayloadEnvDatastores{i}.SelectedVariableNames = {'PacketNum','gpsTimes','xEast','yNorth','zUp'};
    PayloadRadDatastores{i}.ReadSize = "file";
    PayloadEnvDatastores{i}.ReadSize = "file";
    
    PayloadRadData{i} = read(PayloadRadDatastores{i});
    PayloadEnvData{i} = read(PayloadEnvDatastores{i});
    
    if height(PayloadRadData{i}) > 1 && height(PayloadEnvData{i}) > 1
        subSeconds = PayloadRadData{i}.subSecond;
        dcc_time = PayloadRadData{i}.dcc_time;
        pps_time = PayloadRadData{i}.pps_time;

        radSeconds = zeros(1,length(subSeconds));

        startingIndex = 1;
        while isnan(subSeconds(startingIndex))
            subSeconds(startingIndex) = NaN;
            startingIndex = startingIndex + 1;
        end
        radSeconds(startingIndex) = startingRADSecond;
        
        NaNCounter = 0;
        for j = startingIndex+1:length(subSeconds)
            if isnan(subSeconds(j))
                NaNCounter = NaNCounter + 1;
                radSeconds(j) = radSeconds(j-1);
            else
                if (subSeconds(j-1-NaNCounter)>subSeconds(j)+0.1)
                    radSeconds(j) = radSeconds(j-1)+1;
                    NaNCounter = 0;
                else
                    radSeconds(j) = radSeconds(j-1);
                    NaNCounter = 0;
                end
            end

        end

        EnvDataInterp = zeros(length(subSeconds),32);
        interpVals = [3,4,5];
        otherVals = [2];

        % Interpolated values
        for m = interpVals
            x = PayloadEnvData{i}.PacketNum;
            v = table2array(PayloadEnvData{i}(:,m));
            xq = radSeconds+subSeconds';
            EnvDataInterp(:,m) = interp1(x,v,xq);
        end
        
        % Non-interpolated values
        for m = otherVals
            x = PayloadEnvData{i}.PacketNum;
            v = table2array(PayloadEnvData{i}(:,m));
            xq = radSeconds;
            EnvDataInterp(:,m) = interp1(x,v,xq);
        end

        mergedDataTables{i}.gpsTimes = EnvDataInterp(:,2);
        mergedDataTables{i}.subSeconds = subSeconds;
        mergedDataTables{i}.xEast = EnvDataInterp(:,3);
        mergedDataTables{i}.yNorth = EnvDataInterp(:,4);
        mergedDataTables{i}.ZUp = EnvDataInterp(:,5);
        mergedDataTables{i}.pulse_num = PayloadRadData{i}.pulse_num;
        mergedDataTables{i}.isTail = PayloadRadData{i}.isTail;
        mergedDataTables{i}.EPeakB = PayloadRadData{i}.EPeakB;
        fprintf('Done with %i\n', i);
    else
        mergedDataTables{i}.gpsTimes = NaN;
        mergedDataTables{i}.subSeconds = NaN;
        mergedDataTables{i}.gpsLats = NaN;
        mergedDataTables{i}.gpsLongs = NaN;
        mergedDataTables{i}.gpsAlts = NaN;
        mergedDataTables{i}.pulse_num = NaN;
        fprintf('Not enough data for payload %i\n', i);
    end
end


end