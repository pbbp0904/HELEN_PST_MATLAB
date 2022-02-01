function [mergedDataTables] = mergeRadEnvData(PayloadEnvDatastores, PayloadRadDatastores, DirectoryLocation)
startingRADSecond = 9;



for i = 1:length(PayloadEnvDatastores)
    
    PayloadRadDatastores{i}.SelectedVariableNames = {'pulse_num','subSecond','dcc_time','pps_time'};
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
        radSeconds(1) = startingRADSecond;

        for j = 2:length(subSeconds)
            % Try 1
%             if (dcc_time(j-1) < pps_time(j-1) && dcc_time(j) >= pps_time(j) && dcc_time(j) >= pps_time(j-1)) || (pps_time(j-1) == 0 && subSeconds(j-1)>subSeconds(j))
%                 radSeconds(j) = radSeconds(j-1)+1;
%             else
%                 radSeconds(j) = radSeconds(j-1);
%             end
            if (subSeconds(j-1)>subSeconds(j))
                radSeconds(j) = radSeconds(j-1)+1;
            else
                radSeconds(j) = radSeconds(j-1);
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