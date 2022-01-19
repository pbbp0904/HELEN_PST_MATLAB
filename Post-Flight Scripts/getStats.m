function Stats = getStats(PayloadEnvData, PayloadRadData, PayloadPrefixes)

Stats = [];

disp('Generating Statistics...')
% Generate Statistics
for payload = 1:length(PayloadEnvData)
    try
    % Environmental Stats
    % Time on GPS (serial time)
    Stats.TIME_GPS_ON_SERIAL(payload,1) = min(PayloadEnvData{payload}.gpsTimes);
    % Time on GPS (datetime)
    %Stats.TIME_GPS_ON_DATETIME(payload,1) = datetime(Stats.TIME_GPS_ON_SERIAL(payload,1),'ConvertFrom','datenum');

    % Time off GPS (serial time)
    Stats.TIME_GPS_OFF_SERIAL(payload,1) = max(PayloadEnvData{payload}.gpsTimes);
    % Time off GPS (datetime)
    %Stats.TIME_GPS_OFF_DATETIME(payload,1) = datetime(Stats.TIME_GPS_OFF_SERIAL(payload,1),'ConvertFrom','datenum');

    % GPS Duration (hours)
    Stats.TIME_DURATION_GPS(payload,1) = (Stats.TIME_GPS_OFF_SERIAL(payload,1)-Stats.TIME_GPS_ON_SERIAL(payload,1))*24;

    % First Packet Number
    Stats.PACKETNUMBER_FIRST(payload,1) = PayloadEnvData{payload}.PacketNum(1);
    % Last Packet Number
    Stats.PACKETNUMBER_LAST(payload,1) = PayloadEnvData{payload}.PacketNum(end);
    % Expected Number of Packets (#)
    Stats.NUMBEROFPACKETS_EXPECTED(payload,1) = Stats.PACKETNUMBER_LAST(payload,1)-Stats.PACKETNUMBER_FIRST(payload,1)+1;
    % Total Number of packets (#)
    Stats.NUMBEROFPACKETS_ACTUAL(payload,1) = length(PayloadEnvData{payload}.PacketNum);
    % First packet with GPS ON
    Stats.PACKETNUMBER_GPSON(payload,1) = min(PayloadEnvData{payload}.gpsPacketNums);
    % Last packet with GPS ON
    Stats.PACKETNUMBER_GPSOFF(payload,1) = max(PayloadEnvData{payload}.gpsPacketNums);

    % Number of Packets with GPS ON
    Stats.NUMBEROFPACKETS_GPS_DURATION(payload,1) = Stats.PACKETNUMBER_GPSOFF(payload,1)-Stats.PACKETNUMBER_GPSON(payload,1);
    % Average Number of Packets per second
    Stats.NUMBEROFPACKETS_PERSECOND(payload,1) = Stats.NUMBEROFPACKETS_GPS_DURATION(payload,1)/Stats.TIME_DURATION_GPS(payload,1)/60/60;
    
    % Time on (serial time)
    Stats.TIME_ON_SERIAL(payload,1) = Stats.TIME_GPS_ON_SERIAL(payload,1) - ((Stats.PACKETNUMBER_GPSON(payload,1)-Stats.PACKETNUMBER_FIRST(payload,1))/Stats.NUMBEROFPACKETS_PERSECOND(payload,1))/60/60/24;
    % Time on (datetime)
    %Stats.TIME_ON_DATETIME(payload,1) = datetime(Stats.TIME_ON_SERIAL(payload,1),'ConvertFrom','datenum');
    
    % Time off (serial time)
    Stats.TIME_OFF_SERIAL(payload,1) = Stats.TIME_GPS_OFF_SERIAL(payload,1) + ((Stats.PACKETNUMBER_LAST(payload,1)-Stats.PACKETNUMBER_GPSOFF(payload,1))/Stats.NUMBEROFPACKETS_PERSECOND(payload,1))/60/60/24;
    % Time off (datetime)
    %Stats.TIME_OFF_DATETIME(payload,1) = datetime(Stats.TIME_OFF_SERIAL(payload,1),'ConvertFrom','datenum');

    % Total Duration (hours)
    Stats.TIME_DURATION(payload,1) = (Stats.TIME_OFF_SERIAL(payload,1)-Stats.TIME_ON_SERIAL(payload,1))*24;
    
    
    % Max Temp (C)
    Stats.TEMP_MAX(payload,1) = max(PayloadEnvData{payload}.IMUTemp)/100;
    % Min Temp (C)
    Stats.TEMP_MIN(payload,1) = min(PayloadEnvData{payload}.IMUTemp)/100;
    % Mean Temp (C)
    Stats.TEMP_MEAN(payload,1) = mean(PayloadEnvData{payload}.IMUTemp)/100;

    NonNaNLats = PayloadEnvData{payload}.gpsLats(~isnan(PayloadEnvData{payload}.gpsLats));
    NonNaNLongs = PayloadEnvData{payload}.gpsLongs(~isnan(PayloadEnvData{payload}.gpsLongs));
    % Starting latitude (degrees)
    if(~isempty(NonNaNLats))
        Stats.LATITUDE_START(payload,1) = NonNaNLats(1);
    else
        Stats.LATITUDE_START(payload,1) = 0;
    end
    % Starting longitude (degrees)
    if(~isempty(NonNaNLongs))
        Stats.LONGITUDE_START(payload,1) = NonNaNLongs(1);
    else
        Stats.LONGITUDE_START(payload,1) = 0;
    end
    % Ending latitude (degrees)
     if(~isempty(NonNaNLats))
        Stats.LATITUDE_END(payload,1) = NonNaNLats(end);
     else
         Stats.LATITUDE_END(payload,1) = 0;
     end
    % Ending longitude (degrees)
    if(~isempty(NonNaNLongs))
        Stats.LONGITUDE_END(payload,1) = NonNaNLongs(end);
    else
        Stats.LONGITUDE_END(payload,1) = 0;
    end
    % Distance Travelled (km)
    phi1 = deg2rad(Stats.LATITUDE_START(payload,1));
    phi2 = deg2rad(Stats.LATITUDE_END(payload,1));
    deltaphi = deg2rad(Stats.LATITUDE_END(payload,1)-Stats.LATITUDE_START(payload,1));
    deltalambda = deg2rad(Stats.LONGITUDE_END(payload,1)-Stats.LONGITUDE_START(payload,1));
    a = sin(deltaphi/2) * sin(deltaphi/2) + cos(phi1) * cos(phi2) * sin(deltalambda/2) * sin(deltalambda/2);
    Stats.DISTANCE(payload,1) = 6371 * 2 * asin(min(1, sqrt(a)));
    
    % Maximum Acceleration (g)
    Stats.ACCELERATION_MAX_X(payload,1) = max(PayloadEnvData{payload}.AccX);
    Stats.ACCELERATION_MAX_Y(payload,1) = max(PayloadEnvData{payload}.AccY);
    Stats.ACCELERATION_MAX_Z(payload,1) = max(PayloadEnvData{payload}.AccZ);

    
    catch
        fprintf('Failed to get stats for %s environmental data\n', PayloadPrefixes{payload});
    end
    
    try
    % Radiation Stats
    % Total Number Counts (#)
    Stats.COUNTS_TOTAL(payload,1) = length(PayloadRadData{payload}.dcc_time);
    % FPGA Second Resets
    Stats.TIME_FPGACOUNTER_RESETS(payload,1) = sum((PayloadRadData{payload}.dcc_time(2:end)-(PayloadRadData{payload}.dcc_time(1:end-1)))<0);
    % FPGA Duration (hours)
    Stats.TIME_DURATION_FPGA(payload,1) = Stats.TIME_FPGACOUNTER_RESETS(payload,1)/60/60;
    % Mean number of counts per second (#/s)
    Stats.COUNTS_PERSECOND_MEAN(payload,1) = Stats.COUNTS_TOTAL(payload,1)/Stats.TIME_DURATION_FPGA(payload,1)/60/60;
    
    t = PayloadRadData{payload}.dcc_time;
    bp = max(PayloadRadData{payload}.pulsedata_b');
    countsPerSecond = [];
    countsPerSecond1500 = [];
    startTimes = [];
    countNumber = 0;
    countNumber1500 = 0;
    s = 1;
    for j = 2:length(t)
        if t(j)-t(j-1) >= 0
            countNumber = countNumber + 1;
            if bp(j) > 1500
                countNumber1500 = countNumber1500 + 1;
            end
        else
            countsPerSecond(s) = countNumber;
            countsPerSecond1500(s) = countNumber1500;
            startTimes(s) = t(j);
            s = s + 1;
            countNumber = 0;
            countNumber1500 = 0;
        end
    end
    
    % Max number of counts per second (#/s)
    Stats.COUNTS_PERSECOND_MAX(payload,1) = max(countsPerSecond);
    
    % Number of counts greater than 1500 (#)
    Stats.COUNTS_TOTAL_1500(payload,1) = length(PayloadRadData{payload}.dcc_time(PayloadRadData{payload}.dcc_time>1500));
    % Mean number of counts per second greater than 1500 (#/s)
    Stats.COUNTS_PERSECOND_MEAN_1500(payload,1) = Stats.COUNTS_TOTAL_1500(payload,1)/Stats.TIME_DURATION_FPGA(payload,1);
    % Max number of counts per second greater than 1500 (#/s)
    Stats.COUNTS_PERSECOND_MAX_1500(payload,1) = max(countsPerSecond1500);
    
    % Mean clock ticks of first count after reset
    Stats.TICKS_RESET_MEAN(payload,1) = mean(startTimes);
    % Mean clock ticks in between counts 
    Stats.TICKS_COUNTS_MEAN(payload,1) = (50*10^6)/Stats.COUNTS_PERSECOND_MEAN(payload,1);
    % Mean dead time duration (us)
    Stats.DEADTIME_MEAN_US(payload,1) = (Stats.TICKS_RESET_MEAN(payload,1)-Stats.TICKS_COUNTS_MEAN(payload,1))*0.02;
    % Mean dead time (%)
    Stats.DEADTIME_MEAN_PERCENT(payload,1) = (mean(startTimes)-(50*10^6)/Stats.COUNTS_PERSECOND_MEAN(payload,1))/(50*10^6);
    catch
        fprintf('Failed to get stats for %s radiation data\n', PayloadPrefixes{payload});
    end
    
    fprintf('Done with %s\n', PayloadPrefixes{payload});
end
end

