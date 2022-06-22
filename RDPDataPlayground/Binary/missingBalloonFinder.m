clear

data = readtable('D:\Flight Data\Flight 5\1-Raw Data\Tracking\Master Flight 5 Data.xlsx');


% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-3 from pressures
[~,I] = max(data.Altitude_1);
altitudeLookup1 = data.Altitude_1(1:I-5);
pressureLookup1 = data.Pressure_1(1:I-5);

interpedAltitude1 = interp1(pressureLookup1,altitudeLookup1,data.Pressure_3);

[~,I] = max(data.Altitude_2);
altitudeLookup2 = data.Altitude_2(1:I-5);
pressureLookup2 = data.Pressure_2(1:I-5);

interpedAltitude2 = interp1(pressureLookup2,altitudeLookup2,data.Pressure_3);

calculatedAlt3 = (interpedAltitude1+interpedAltitude2)./2;



% Ascent Simulation
startingLat = floor(data.Latitude_3(16)/100)+mod(data.Latitude_3(16),100)/60;
startingLong = -(floor(data.Longitude_3(16)/100)+mod(data.Longitude_3(16),100)/60);
Lat = startingLat;
Long = startingLong;
Latitude_3(1:16) = floor(data.Latitude_3(1:16)/100)+mod(data.Latitude_3(1:16),100)/60;
Longitude_3(1:16) = -(floor(data.Longitude_3(1:16)/100)+mod(data.Longitude_3(1:16),100)/60);
i = 17;

[maxAlt,I] = max(calculatedAlt3);
while i <= I
    averageAlt = (calculatedAlt3(i-1)+calculatedAlt3(i))/2;
    [~,max1] = max(data.Altitude_1);
    [~,minInd1] = min(abs(averageAlt-data.Altitude_1(1:max1)));

    latDiff1 = data.Latitude_1(minInd1+1)-data.Latitude_1(minInd1-1);
    longDiff1 = data.Longitude_1(minInd1+1)-data.Longitude_1(minInd1-1);
    t1 = datetime(data.Time_1(minInd1-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_1(minInd1+1),'ConvertFrom','excel');
    timeDiff1 = seconds(t2-t1);
    latDiff1 = latDiff1/timeDiff1;
    longDiff1 = longDiff1/timeDiff1;

    [~,max2] = max(data.Altitude_2);
    [~,minInd2] = min(abs(averageAlt-data.Altitude_2(1:max2)));

    latDiff2 = data.Latitude_2(minInd2+1)-data.Latitude_2(minInd2-1);
    longDiff2 = data.Longitude_2(minInd2+1)-data.Longitude_2(minInd2-1);
    t1 = datetime(data.Time_2(minInd2-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_2(minInd2+1),'ConvertFrom','excel');
    timeDiff2 = seconds(t2-t1);
    latDiff2 = latDiff2/timeDiff2;
    longDiff2 = longDiff2/timeDiff2;

    timeDiff = data.Hour_3(i)*60*60+data.Minute_3(i)*60+data.Seconds_3(i)-data.Hour_3(i-1)*60*60-data.Minute_3(i-1)*60-data.Seconds_3(i-1);

    Lat = Lat + (latDiff1+latDiff2)/2*timeDiff;
    Long = Long + (longDiff1+longDiff2)/2*timeDiff;

    Latitude_3(i) = Lat;
    Longitude_3(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_1(i) <= max(calculatedAlt3) && data.Altitude_1(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff1 = data.Latitude_1(end)-data.Latitude_1(i);
descentLongDiff1 = data.Longitude_1(end)-data.Longitude_1(i);

i = 2;
while true
    if data.Altitude_2(i) <= max(calculatedAlt3) && data.Altitude_2(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff2 = data.Latitude_2(end-5)-data.Latitude_2(i);
descentLongDiff2 = data.Longitude_2(end-5)-data.Longitude_2(i);

descentLatDiff = (descentLatDiff1+descentLatDiff2)/2;
descentLongDiff = (descentLongDiff1+descentLongDiff2)/2;

Latitude_3(end+1) = Latitude_3(end) + descentLatDiff;
Longitude_3(end+1) = Longitude_3(end) + descentLongDiff;

Latitude_3_12 = Latitude_3;
Longitude_3_12 = Longitude_3;




%%

clearvars -except Longitude_3_12 Latitude_3_12 data
% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-3 from pressures
[~,I] = max(data.Altitude_1);
altitudeLookup1 = data.Altitude_1(1:I-5);
pressureLookup1 = data.Pressure_1(1:I-5);

interpedAltitude1 = interp1(pressureLookup1,altitudeLookup1,data.Pressure_3);

calculatedAlt3 = interpedAltitude1;



% Ascent Simulation
startingLat = floor(data.Latitude_3(16)/100)+mod(data.Latitude_3(16),100)/60;
startingLong = -(floor(data.Longitude_3(16)/100)+mod(data.Longitude_3(16),100)/60);
Lat = startingLat;
Long = startingLong;
Latitude_3(1:16) = floor(data.Latitude_3(1:16)/100)+mod(data.Latitude_3(1:16),100)/60;
Longitude_3(1:16) = -(floor(data.Longitude_3(1:16)/100)+mod(data.Longitude_3(1:16),100)/60);
i = 17;

[maxAlt,I] = max(calculatedAlt3);
while i <= I
    averageAlt = (calculatedAlt3(i-1)+calculatedAlt3(i))/2;
    [~,max1] = max(data.Altitude_1);
    [~,minInd] = min(abs(averageAlt-data.Altitude_1(1:max1)));

    latDiff1 = data.Latitude_1(minInd+1)-data.Latitude_1(minInd-1);
    longDiff1 = data.Longitude_1(minInd+1)-data.Longitude_1(minInd-1);
    t1 = datetime(data.Time_1(minInd-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_1(minInd+1),'ConvertFrom','excel');
    timeDiff1 = seconds(t2-t1);
    latDiff1 = latDiff1/timeDiff1;
    longDiff1 = longDiff1/timeDiff1;

    timeDiff = data.Hour_3(i)*60*60+data.Minute_3(i)*60+data.Seconds_3(i)-data.Hour_3(i-1)*60*60-data.Minute_3(i-1)*60-data.Seconds_3(i-1);

    Lat = Lat + latDiff1*timeDiff;
    Long = Long + longDiff1*timeDiff;

    Latitude_3(i) = Lat;
    Longitude_3(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_1(i) <= max(calculatedAlt3) && data.Altitude_1(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff1 = data.Latitude_1(end)-data.Latitude_1(i);
descentLongDiff1 = data.Longitude_1(end)-data.Longitude_1(i);

descentLatDiff = descentLatDiff1;
descentLongDiff = descentLongDiff1;

Latitude_3(end+1) = Latitude_3(end) + descentLatDiff;
Longitude_3(end+1) = Longitude_3(end) + descentLongDiff;
Latitude_3_1 = Latitude_3;
Longitude_3_1 = Longitude_3;


%%

clearvars -except Longitude_3_12 Latitude_3_12 Longitude_3_1 Latitude_3_1 data
% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-3 from pressures

[~,I] = max(data.Altitude_2);
altitudeLookup2 = data.Altitude_2(1:I-5);
pressureLookup2 = data.Pressure_2(1:I-5);

interpedAltitude2 = interp1(pressureLookup2,altitudeLookup2,data.Pressure_3);

calculatedAlt3 = interpedAltitude2;



% Ascent Simulation
startingLat = floor(data.Latitude_3(16)/100)+mod(data.Latitude_3(16),100)/60;
startingLong = -(floor(data.Longitude_3(16)/100)+mod(data.Longitude_3(16),100)/60);
Lat = startingLat;
Long = startingLong;
Latitude_3(1:16) = floor(data.Latitude_3(1:16)/100)+mod(data.Latitude_3(1:16),100)/60;
Longitude_3(1:16) = -(floor(data.Longitude_3(1:16)/100)+mod(data.Longitude_3(1:16),100)/60);
i = 17;

[maxAlt,I] = max(calculatedAlt3);
while i <= I
    averageAlt = (calculatedAlt3(i-1)+calculatedAlt3(i))/2;
    [~,max2] = max(data.Altitude_2);
    [~,minInd2] = min(abs(averageAlt-data.Altitude_2(1:max2)));

    latDiff2 = data.Latitude_2(minInd2+1)-data.Latitude_2(minInd2-1);
    longDiff2 = data.Longitude_2(minInd2+1)-data.Longitude_2(minInd2-1);
    t1 = datetime(data.Time_2(minInd2-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_2(minInd2+1),'ConvertFrom','excel');
    timeDiff2 = seconds(t2-t1);
    latDiff2 = latDiff2/timeDiff2;
    longDiff2 = longDiff2/timeDiff2;

    timeDiff = data.Hour_3(i)*60*60+data.Minute_3(i)*60+data.Seconds_3(i)-data.Hour_3(i-1)*60*60-data.Minute_3(i-1)*60-data.Seconds_3(i-1);

    Lat = Lat + latDiff2*timeDiff;
    Long = Long + longDiff2*timeDiff;

    Latitude_3(i) = Lat;
    Longitude_3(i) = Long;
    i = i + 1;
end


% Descent

i = 2;
while true
    if data.Altitude_2(i) <= max(calculatedAlt3) && data.Altitude_2(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff2 = data.Latitude_2(end-5)-data.Latitude_2(i);
descentLongDiff2 = data.Longitude_2(end-5)-data.Longitude_2(i);

descentLatDiff = descentLatDiff2;
descentLongDiff = descentLongDiff2;

Latitude_3(end+1) = Latitude_3(end) + descentLatDiff;
Longitude_3(end+1) = Longitude_3(end) + descentLongDiff;

Latitude_3_2 = Latitude_3;
Longitude_3_2 = Longitude_3;

%% Old
clearvars -except Longitude_3_12 Latitude_3_12 Longitude_3_1 Latitude_3_1 Longitude_3_2 Latitude_3_2 data
% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-3 from pressures
[~,I] = max(data.Altitude_1);
altitudeLookup1 = data.Altitude_1(1:I-5);
pressureLookup1 = data.Pressure_1(1:I-5);

interpedAltitude1 = interp1(pressureLookup1,altitudeLookup1,data.Pressure_3);

[~,I] = max(data.Altitude_2);
altitudeLookup2 = data.Altitude_2(1:I-5);
pressureLookup2 = data.Pressure_2(1:I-5);

interpedAltitude2 = interp1(pressureLookup2,altitudeLookup2,data.Pressure_3);

calculatedAlt3 = (interpedAltitude1+interpedAltitude2)./2;



% Ascent Simulation
startingLat = floor(data.Latitude_3(16)/100)+mod(data.Latitude_3(16),100)/60;
startingLong = -(floor(data.Longitude_3(16)/100)+mod(data.Longitude_3(16),100)/60);
Lat = startingLat;
Long = startingLong;
Latitude_3(1:16) = floor(data.Latitude_3(1:16)/100)+mod(data.Latitude_3(1:16),100)/60;
Longitude_3(1:16) = -(floor(data.Longitude_3(1:16)/100)+mod(data.Longitude_3(1:16),100)/60);
i = 17;

[maxAlt,I] = max(calculatedAlt3);
while i <= I
    averageAlt = (calculatedAlt3(i-1)+calculatedAlt3(i))/2;
    [~,max1] = max(data.Altitude_1);
    [~,minInd1] = min(abs(averageAlt-data.Altitude_1(1:max1)));

    latDiff1 = data.Latitude_1(minInd1+1)-data.Latitude_1(minInd1-1);
    longDiff1 = data.Longitude_1(minInd1+1)-data.Longitude_1(minInd1-1);
    t1 = datetime(data.Time_1(minInd1-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_1(minInd1+1),'ConvertFrom','excel');
    timeDiff1 = seconds(t2-t1);
    latDiff1 = latDiff1/timeDiff1;
    longDiff1 = longDiff1/timeDiff1;

    timeDiff = data.Hour_3(i)*60*60+data.Minute_3(i)*60+data.Seconds_3(i)-data.Hour_3(i-1)*60*60-data.Minute_3(i-1)*60-data.Seconds_3(i-1);

    Lat = Lat + latDiff1*timeDiff;
    Long = Long + longDiff1*timeDiff;

    Latitude_3(i) = Lat;
    Longitude_3(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_1(i) <= max(calculatedAlt3) && data.Altitude_1(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff1 = data.Latitude_1(end)-data.Latitude_1(i);
descentLongDiff1 = data.Longitude_1(end)-data.Longitude_1(i);

i = 2;
while true
    if data.Altitude_2(i) <= max(calculatedAlt3) && data.Altitude_2(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff2 = data.Latitude_2(end-5)-data.Latitude_2(i);
descentLongDiff2 = data.Longitude_2(end-5)-data.Longitude_2(i);

descentLatDiff = (descentLatDiff1+descentLatDiff2)/2;
descentLongDiff = (descentLongDiff1+descentLongDiff2)/2;

Latitude_3(end+1) = Latitude_3(end) + descentLatDiff;
Longitude_3(end+1) = Longitude_3(end) + descentLongDiff;

Latitude_3_old = Latitude_3;
Longitude_3_old = Longitude_3;



%%

clearvars -except Longitude_3_12 Latitude_3_12 Longitude_3_1 Latitude_3_1 Longitude_3_2 Latitude_3_2 Longitude_3_old Latitude_3_old data
% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-3 from pressures

[~,I] = max(data.Altitude_4);
altitudeLookup4 = data.Altitude_4(1:I);
pressureLookup4 = data.Pressure_4(1:I);

interpedAltitude4 = interp1(pressureLookup4,altitudeLookup4,data.Pressure_3);

calculatedAlt3 = interpedAltitude4;



% Ascent Simulation
startingLat = floor(data.Latitude_3(16)/100)+mod(data.Latitude_3(16),100)/60;
startingLong = -(floor(data.Longitude_3(16)/100)+mod(data.Longitude_3(16),100)/60);
Lat = startingLat;
Long = startingLong;
Latitude_3(1:16) = floor(data.Latitude_3(1:16)/100)+mod(data.Latitude_3(1:16),100)/60;
Longitude_3(1:16) = -(floor(data.Longitude_3(1:16)/100)+mod(data.Longitude_3(1:16),100)/60);
i = 17;

[maxAlt,I] = max(calculatedAlt3);
while i <= I
    averageAlt = (calculatedAlt3(i-1)+calculatedAlt3(i))/2;
    [~,max4] = max(data.Altitude_4);
    [~,minInd4] = min(abs(averageAlt-data.Altitude_4(1:max4)));

    latDiff4 = data.Latitude_4(minInd4+1)-data.Latitude_4(minInd4-1);
    longDiff4 = data.Longitude_4(minInd4+1)-data.Longitude_4(minInd4-1);
    t1 = datetime(data.Time_4(minInd4-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_4(minInd4+1),'ConvertFrom','excel');
    timeDiff4 = seconds(t2-t1);
    latDiff4 = latDiff4/timeDiff4;
    longDiff4 = longDiff4/timeDiff4;

    timeDiff = data.Hour_3(i)*60*60+data.Minute_3(i)*60+data.Seconds_3(i)-data.Hour_3(i-1)*60*60-data.Minute_3(i-1)*60-data.Seconds_3(i-1);

    Lat = Lat + latDiff4*timeDiff;
    Long = Long + longDiff4*timeDiff;

    Latitude_3(i) = Lat;
    Longitude_3(i) = Long;
    i = i + 1;
end


% Descent

i = 2;
while true
    if data.Altitude_4(i) <= max(calculatedAlt3) && data.Altitude_4(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff4 = data.Latitude_4(end-25)-data.Latitude_4(i);
descentLongDiff4 = data.Longitude_4(end-25)-data.Longitude_4(i);

descentLatDiff = descentLatDiff4;
descentLongDiff = descentLongDiff4;

Latitude_3(end+1) = Latitude_3(end) + descentLatDiff;
Longitude_3(end+1) = Longitude_3(end) + descentLongDiff;

Latitude_3_4 = Latitude_3;
Longitude_3_4 = Longitude_3;


%%

clearvars -except Longitude_3_12 Latitude_3_12 Longitude_3_1 Latitude_3_1 Longitude_3_2 Latitude_3_2 Longitude_3_old Latitude_3_old Longitude_3_4 Latitude_3_4 data
% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-3 from pressures
[~,I] = max(data.Altitude_4);
altitudeLookup4 = data.Altitude_4(1:I);
pressureLookup4 = data.Pressure_4(1:I);

interpedAltitude4 = interp1(pressureLookup4,altitudeLookup4,data.Pressure_3);

[~,I] = max(data.Altitude_2);
altitudeLookup2 = data.Altitude_2(1:I-5);
pressureLookup2 = data.Pressure_2(1:I-5);

interpedAltitude2 = interp1(pressureLookup2,altitudeLookup2,data.Pressure_3);

calculatedAlt3 = (interpedAltitude4*3/18+interpedAltitude2*15/18);



% Ascent Simulation
startingLat = floor(data.Latitude_3(16)/100)+mod(data.Latitude_3(16),100)/60;
startingLong = -(floor(data.Longitude_3(16)/100)+mod(data.Longitude_3(16),100)/60);
Lat = startingLat;
Long = startingLong;
Latitude_3(1:16) = floor(data.Latitude_3(1:16)/100)+mod(data.Latitude_3(1:16),100)/60;
Longitude_3(1:16) = -(floor(data.Longitude_3(1:16)/100)+mod(data.Longitude_3(1:16),100)/60);
i = 17;

[maxAlt,I] = max(calculatedAlt3);
while i <= I
    averageAlt = (calculatedAlt3(i-1)+calculatedAlt3(i))/2;
    [~,max4] = max(data.Altitude_4);
    [~,minInd4] = min(abs(averageAlt-data.Altitude_4(1:max4)));

    latDiff4 = data.Latitude_4(minInd4+1)-data.Latitude_4(minInd4-1);
    longDiff4 = data.Longitude_4(minInd4+1)-data.Longitude_4(minInd4-1);
    t1 = datetime(data.Time_4(minInd4-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_4(minInd4+1),'ConvertFrom','excel');
    timeDiff4 = seconds(t2-t1);
    latDiff4 = latDiff4/timeDiff4;
    longDiff4 = longDiff4/timeDiff4;

    [~,max2] = max(data.Altitude_2);
    [~,minInd2] = min(abs(averageAlt-data.Altitude_2(1:max2)));

    latDiff2 = data.Latitude_2(minInd2+1)-data.Latitude_2(minInd2-1);
    longDiff2 = data.Longitude_2(minInd2+1)-data.Longitude_2(minInd2-1);
    t1 = datetime(data.Time_2(minInd2-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_2(minInd2+1),'ConvertFrom','excel');
    timeDiff2 = seconds(t2-t1);
    latDiff2 = latDiff2/timeDiff2;
    longDiff2 = longDiff2/timeDiff2;

    timeDiff = data.Hour_3(i)*60*60+data.Minute_3(i)*60+data.Seconds_3(i)-data.Hour_3(i-1)*60*60-data.Minute_3(i-1)*60-data.Seconds_3(i-1);

    Lat = Lat + (latDiff4*3/18+latDiff2*15/18)*timeDiff;
    Long = Long + (longDiff4*3/18+longDiff2*15/18)*timeDiff;

    Latitude_3(i) = Lat;
    Longitude_3(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_4(i) <= max(calculatedAlt3) && data.Altitude_4(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff4 = data.Latitude_4(end-25)-data.Latitude_4(i);
descentLongDiff4 = data.Longitude_4(end-25)-data.Longitude_4(i);

i = 2;
while true
    if data.Altitude_2(i) <= max(calculatedAlt3) && data.Altitude_2(i-1) > max(calculatedAlt3)
        break
    end
    i = i + 1;
end
descentLatDiff2 = data.Latitude_2(end-5)-data.Latitude_2(i);
descentLongDiff2 = data.Longitude_2(end-5)-data.Longitude_2(i);

descentLatDiff = (descentLatDiff4*3/18+descentLatDiff2*15/18);
descentLongDiff = (descentLongDiff4*3/18+descentLongDiff2*15/18);

Latitude_3(end+1) = Latitude_3(end) + descentLatDiff;
Longitude_3(end+1) = Longitude_3(end) + descentLongDiff;

Latitude_3_Monster = Latitude_3;
Longitude_3_Monster = Longitude_3;


%%