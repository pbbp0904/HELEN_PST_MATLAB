function [mergedDataTables] = mergeRadEnvData(PayloadEnvData, PayloadRadData)
startingRADSecond = 9; 

disp('Merging Radiation and Environmental Data...')
parfor i = 1:length(PayloadEnvData)
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
        interpVals = [2:18,21,22,23,24,25,30,31];
        otherVals = [1,19,20,26,27,28,29,32];

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

        mergedDataTables{i} = PayloadRadData{i};

        mergedDataTables{i}.radSeconds = radSeconds';
        mergedDataTables{i}.PacketNum = EnvDataInterp(:,1);
        mergedDataTables{i}.Pitch = EnvDataInterp(:,2);
        mergedDataTables{i}.Roll = EnvDataInterp(:,3);
        mergedDataTables{i}.Yaw = EnvDataInterp(:,4);
        mergedDataTables{i}.AccX = EnvDataInterp(:,5);
        mergedDataTables{i}.AccY = EnvDataInterp(:,6);
        mergedDataTables{i}.AccZ = EnvDataInterp(:,7);
        mergedDataTables{i}.GyroX = EnvDataInterp(:,8);
        mergedDataTables{i}.GyroY = EnvDataInterp(:,9);
        mergedDataTables{i}.GyroZ = EnvDataInterp(:,10);
        mergedDataTables{i}.MagX = EnvDataInterp(:,11);
        mergedDataTables{i}.MagY = EnvDataInterp(:,12);
        mergedDataTables{i}.MagZ = EnvDataInterp(:,13);
        mergedDataTables{i}.IMUTemp = EnvDataInterp(:,14);
        mergedDataTables{i}.HPSTemp = EnvDataInterp(:,15);
        mergedDataTables{i}.EXTTemp = EnvDataInterp(:,16);
        mergedDataTables{i}.BATTemp = EnvDataInterp(:,17);
        mergedDataTables{i}.PMTTemp = EnvDataInterp(:,18);
        mergedDataTables{i}.gpsPacketNums = EnvDataInterp(:,19);
        mergedDataTables{i}.gpsTimes = EnvDataInterp(:,20);
        mergedDataTables{i}.gpsLats = EnvDataInterp(:,21);
        mergedDataTables{i}.gpsLongs = EnvDataInterp(:,22);
        mergedDataTables{i}.gpsSpeeds = EnvDataInterp(:,23);
        mergedDataTables{i}.gpsAngles = EnvDataInterp(:,24);
        mergedDataTables{i}.gpsAlts = EnvDataInterp(:,25);
        mergedDataTables{i}.gpsSatNum = EnvDataInterp(:,26);
        mergedDataTables{i}.gpsLatErrs = EnvDataInterp(:,27);
        mergedDataTables{i}.gpsLongErrs = EnvDataInterp(:,28);
        mergedDataTables{i}.gpsAltErrs = EnvDataInterp(:,29);
        mergedDataTables{i}.gpsClkBiases = EnvDataInterp(:,30);
        mergedDataTables{i}.gpsClkDrifts = EnvDataInterp(:,31);
        mergedDataTables{i}.TimeErrs = EnvDataInterp(:,32);

        fprintf('Done with %i\n', i);
    else
        fprintf('Not enough data for payload %i\n', i);
    end
end


end