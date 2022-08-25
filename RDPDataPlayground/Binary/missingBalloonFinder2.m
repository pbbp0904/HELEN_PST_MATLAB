clear

data = readtable('D:\Flight Data\Flight 5\1-Raw Data\Tracking\Master Flight 5 Data.xlsx');

% Red predict green

% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-2 from pressures
[~,I] = max(data.Altitude_1);
altitudeLookup1 = data.Altitude_1(1:I-4);
pressureLookup1 = data.Pressure_1(1:I-4);

interpedAltitude1 = interp1(pressureLookup1,altitudeLookup1,data.Pressure_2);

calculatedAlt2 = interpedAltitude1;



% Ascent Simulation
startingLat = data.Latitude_2(16);
startingLong = data.Longitude_2(16);
Lat = startingLat;
Long = startingLong;
Latitude_2(1:16) = data.Latitude_2(1:16);
Longitude_2(1:16) = data.Longitude_2(1:16);
i = 17;

[maxAlt,I] = max(calculatedAlt2);
while i <= I
    altPre2 = calculatedAlt2(i-1);
    altPost2 = calculatedAlt2(i+3);
    [~,max1] = max(data.Altitude_1);
    [~,minIndPre1] = min(abs(altPre2-data.Altitude_1(1:max1)));
    [~,minIndPost1] = min(abs(altPost2-data.Altitude_1(1:max1)));

    latDiff1 = data.Latitude_1(minIndPost1)-data.Latitude_1(minIndPre1);
    longDiff1 = data.Longitude_1(minIndPost1)-data.Longitude_1(minIndPre1);
    t1 = datetime(data.Time_1(minIndPre1),'ConvertFrom','excel');
    t2 = datetime(data.Time_1(minIndPost1),'ConvertFrom','excel');
    timeDiff1 = seconds(t2-t1);
    latDiff1 = latDiff1/timeDiff1;
    longDiff1 = longDiff1/timeDiff1;

    t1 = datetime(data.Time_2(i-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_2(i),'ConvertFrom','excel');
    timeDiff = seconds(t2-t1);

    Lat = Lat + latDiff1*timeDiff;
    Long = Long + longDiff1*timeDiff;

    Latitude_2(i) = Lat;
    Longitude_2(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_1(i) <= max(calculatedAlt2) && data.Altitude_1(i-1) > max(calculatedAlt2)
        break
    end
    i = i + 1;
end
descentLatDiff1 = data.Latitude_1(end)-data.Latitude_1(i-5);
descentLongDiff1 = data.Longitude_1(end)-data.Longitude_1(i-5);


descentLatDiff = descentLatDiff1;
descentLongDiff = descentLongDiff1;

Latitude_2(end+1) = Latitude_2(end) + descentLatDiff;
Longitude_2(end+1) = Longitude_2(end) + descentLongDiff;

Latitude_2_1 = Latitude_2;
Longitude_2_1 = Longitude_2;

%%

clear

data = readtable('D:\Flight Data\Flight 5\1-Raw Data\Tracking\Master Flight 5 Data.xlsx');



% Green predict red

% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-2 from pressures
[~,I] = max(data.Altitude_2);
altitudeLookup2 = data.Altitude_2(1:I-5);
pressureLookup2 = data.Pressure_2(1:I-5);

interpedAltitude2 = interp1(pressureLookup2,altitudeLookup2,data.Pressure_1);

calculatedAlt1 = interpedAltitude2;



% Ascent Simulation
startingLat = data.Latitude_1(16);
startingLong = data.Longitude_1(16);
Lat = startingLat;
Long = startingLong;
Latitude_1(1:16) = data.Latitude_1(1:16);
Longitude_1(1:16) = data.Longitude_1(1:16);
i = 17;

[maxAlt,I] = max(calculatedAlt1);
while i <= I
    altPre1 = calculatedAlt1(i-1);
    altPost1 = calculatedAlt1(i+4);
    [~,max2] = max(data.Altitude_2);
    [~,minIndPre2] = min(abs(altPre1-data.Altitude_2(1:max2)));
    [~,minIndPost2] = min(abs(altPost1-data.Altitude_2(1:max2)));

    latDiff2 = data.Latitude_2(minIndPost2)-data.Latitude_2(minIndPre2);
    longDiff2 = data.Longitude_2(minIndPost2)-data.Longitude_2(minIndPre2);
    t1 = datetime(data.Time_2(minIndPre2),'ConvertFrom','excel');
    t2 = datetime(data.Time_2(minIndPost2),'ConvertFrom','excel');
    timeDiff2 = seconds(t2-t1);
    latDiff2 = latDiff2/timeDiff2;
    longDiff2 = longDiff2/timeDiff2;

    t1 = datetime(data.Time_1(i-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_1(i),'ConvertFrom','excel');
    timeDiff = seconds(t2-t1);

    Lat = Lat + latDiff2*timeDiff;
    Long = Long + longDiff2*timeDiff;

    Latitude_1(i) = Lat;
    Longitude_1(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_2(i) <= max(calculatedAlt1) && data.Altitude_2(i-1) > max(calculatedAlt1)
        break
    end
    i = i + 1;
end
descentLatDiff2 = data.Latitude_2(end-5)-data.Latitude_2(i-9);
descentLongDiff2 = data.Longitude_2(end-5)-data.Longitude_2(i-9);


descentLatDiff = descentLatDiff2;
descentLongDiff = descentLongDiff2;

Latitude_1(end+1) = Latitude_1(end) + descentLatDiff;
Longitude_1(end+1) = Longitude_1(end) + descentLongDiff;

Latitude_1_2 = Latitude_1;
Longitude_1_2 = Longitude_1;


%%

clear

data = readtable('D:\Flight Data\Flight 5\1-Raw Data\Tracking\Master Flight 5 Data.xlsx');

% Blue predict green

% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-2 from pressures
[~,I] = max(data.Altitude_4);
altitudeLookup4 = data.Altitude_4(1:I);
pressureLookup4 = data.Pressure_4(1:I);

interpedAltitude4 = interp1(pressureLookup4,altitudeLookup4,data.Pressure_2);

calculatedAlt2 = interpedAltitude4;



% Ascent Simulation
startingLat = data.Latitude_2(16);
startingLong = data.Longitude_2(16);
Lat = startingLat;
Long = startingLong;
Latitude_2(1:16) = data.Latitude_2(1:16);
Longitude_2(1:16) = data.Longitude_2(1:16);
i = 17;

[maxAlt,I] = max(calculatedAlt2);
while i <= I
    averageAlt = (calculatedAlt2(i-1)+calculatedAlt2(i))/2;
    [~,max4] = max(data.Altitude_4);
    [~,minInd4] = min(abs(averageAlt-data.Altitude_4(1:max4)));

    latDiff4 = data.Latitude_4(minInd4+1)-data.Latitude_4(minInd4-1);
    longDiff4 = data.Longitude_4(minInd4+1)-data.Longitude_4(minInd4-1);
    t1 = datetime(data.Time_4(minInd4-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_4(minInd4+1),'ConvertFrom','excel');
    timeDiff4 = seconds(t2-t1);
    latDiff4 = latDiff4/timeDiff4;
    longDiff4 = longDiff4/timeDiff4;

    t1 = datetime(data.Time_2(i-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_2(i),'ConvertFrom','excel');
    timeDiff = seconds(t2-t1);

    Lat = Lat + latDiff4*timeDiff;
    Long = Long + longDiff4*timeDiff;

    Latitude_2(i) = Lat;
    Longitude_2(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_4(i) <= max(calculatedAlt2) && data.Altitude_4(i-1) > max(calculatedAlt2)
        break
    end
    i = i + 1;
end
descentLatDiff4 = data.Latitude_4(end-25)-data.Latitude_4(i);
descentLongDiff4 = data.Longitude_4(end-25)-data.Longitude_4(i);


descentLatDiff = descentLatDiff4;
descentLongDiff = descentLongDiff4;

Latitude_2(end+1) = Latitude_2(end) + descentLatDiff;
Longitude_2(end+1) = Longitude_2(end) + descentLongDiff;

Latitude_2_4 = Latitude_2;
Longitude_2_4 = Longitude_2;

%%

clear

data = readtable('D:\Flight Data\Flight 5\1-Raw Data\Tracking\Master Flight 5 Data.xlsx');



% Blue predict red

% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-2 from pressures
[~,I] = max(data.Altitude_4);
altitudeLookup4 = data.Altitude_4(1:I);
pressureLookup4 = data.Pressure_4(1:I);

interpedAltitude4 = interp1(pressureLookup4,altitudeLookup4,data.Pressure_1);

calculatedAlt1 = interpedAltitude4;



% Ascent Simulation
startingLat = data.Latitude_1(16);
startingLong = data.Longitude_1(16);
Lat = startingLat;
Long = startingLong;
Latitude_1(1:16) = data.Latitude_1(1:16);
Longitude_1(1:16) = data.Longitude_1(1:16);
i = 17;

[maxAlt,I] = max(calculatedAlt1);
while i <= I
    averageAlt = (calculatedAlt1(i-1)+calculatedAlt1(i))/2;
    [~,max4] = max(data.Altitude_4);
    [~,minInd4] = min(abs(averageAlt-data.Altitude_4(1:max4)));

    latDiff4 = data.Latitude_4(minInd4+1)-data.Latitude_4(minInd4-1);
    longDiff4 = data.Longitude_4(minInd4+1)-data.Longitude_4(minInd4-1);
    t1 = datetime(data.Time_4(minInd4-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_4(minInd4+1),'ConvertFrom','excel');
    timeDiff4 = seconds(t2-t1);
    latDiff4 = latDiff4/timeDiff4;
    longDiff4 = longDiff4/timeDiff4;

    t1 = datetime(data.Time_1(i-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_1(i),'ConvertFrom','excel');
    timeDiff = seconds(t2-t1);

    Lat = Lat + latDiff4*timeDiff;
    Long = Long + longDiff4*timeDiff;

    Latitude_1(i) = Lat;
    Longitude_1(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_4(i) <= max(calculatedAlt1) && data.Altitude_4(i-1) > max(calculatedAlt1)
        break
    end
    i = i + 1;
end
descentLatDiff4 = data.Latitude_4(end-25)-data.Latitude_4(i);
descentLongDiff4 = data.Longitude_4(end-25)-data.Longitude_4(i);


descentLatDiff = descentLatDiff4;
descentLongDiff = descentLongDiff4;

Latitude_1(end+1) = Latitude_1(end) + descentLatDiff;
Longitude_1(end+1) = Longitude_1(end) + descentLongDiff;

Latitude_1_4 = Latitude_1;
Longitude_1_4 = Longitude_1;


%%

clear

data = readtable('D:\Flight Data\Flight 5\1-Raw Data\Tracking\Master Flight 5 Data.xlsx');



% Green predict Green

% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-2 from pressures
[~,I] = max(data.Altitude_2);
altitudeLookup2 = data.Altitude_2(1:I-5);
pressureLookup2 = data.Pressure_2(1:I-5);

interpedAltitude2 = interp1(pressureLookup2,altitudeLookup2,data.Pressure_2);

calculatedAlt2 = interpedAltitude2;



% Ascent Simulation
startingLat = data.Latitude_2(16);
startingLong = data.Longitude_2(16);
Lat = startingLat;
Long = startingLong;
Latitude_2(1:16) = data.Latitude_2(1:16);
Longitude_2(1:16) = data.Longitude_2(1:16);
i = 17;

[maxAlt,I] = max(calculatedAlt2);
while i <= I
    altPre2 = calculatedAlt2(i-1);
    altPost2 = calculatedAlt2(i+1);
    [~,max2] = max(data.Altitude_2);
    [~,minIndPre2] = min(abs(altPre2-data.Altitude_2(1:max2)));
    [~,minIndPost2] = min(abs(altPost2-data.Altitude_2(1:max2)));

    latDiff2 = data.Latitude_2(minIndPost2)-data.Latitude_2(minIndPre2);
    longDiff2 = data.Longitude_2(minIndPost2)-data.Longitude_2(minIndPre2);
    t1 = datetime(data.Time_2(minIndPre2),'ConvertFrom','excel');
    t2 = datetime(data.Time_2(minIndPost2),'ConvertFrom','excel');
    timeDiff2 = seconds(t2-t1);
    latDiff2 = latDiff2/timeDiff2;
    longDiff2 = longDiff2/timeDiff2;

    t1 = datetime(data.Time_2(i-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_2(i),'ConvertFrom','excel');
    timeDiff = seconds(t2-t1);

    Lat = Lat + latDiff2*timeDiff;
    Long = Long + longDiff2*timeDiff;

    Latitude_2(i) = Lat;
    Longitude_2(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_2(i) <= max(calculatedAlt2) && data.Altitude_2(i-1) > max(calculatedAlt2)
        break
    end
    i = i + 1;
end
descentLatDiff2 = data.Latitude_2(end-5)-data.Latitude_2(i-8);
descentLongDiff2 = data.Longitude_2(end-5)-data.Longitude_2(i-8);


descentLatDiff = descentLatDiff2;
descentLongDiff = descentLongDiff2;

Latitude_2(end+1) = Latitude_2(end) + descentLatDiff;
Longitude_2(end+1) = Longitude_2(end) + descentLongDiff;

Latitude_2_2 = Latitude_2;
Longitude_2_2 = Longitude_2;

%%

clear

data = readtable('D:\Flight Data\Flight 5\1-Raw Data\Tracking\Master Flight 5 Data.xlsx');



% Red predict Red

% Find ascent rate of 3
ft2m = 0.3048;
[maxAlt,I] = max(data.Altitude_3);
maxAlt = maxAlt*ft2m;
minAlt = data.Altitude_3(1)*ft2m;
ascentRate = (maxAlt-minAlt)/(data.Hour_3(I)*60*60+data.Minute_3(I)*60+data.Seconds_3(I)-data.Hour_3(1)*60*60-data.Minute_3(1)*60-data.Seconds_3(1));

% Generate Altitude-2 from pressures
[~,I] = max(data.Altitude_1);
altitudeLookup1 = data.Altitude_1(1:I-4);
pressureLookup1 = data.Pressure_1(1:I-4);

interpedAltitude1 = interp1(pressureLookup1,altitudeLookup1,data.Pressure_1);

calculatedAlt1 = interpedAltitude1;



% Ascent Simulation
startingLat = data.Latitude_1(16);
startingLong = data.Longitude_1(16);
Lat = startingLat;
Long = startingLong;
Latitude_1(1:16) = data.Latitude_1(1:16);
Longitude_1(1:16) = data.Longitude_1(1:16);
i = 17;

[maxAlt,I] = max(calculatedAlt1);
while i <= I
    altPre1 = calculatedAlt1(i-1);
    altPost1 = calculatedAlt1(i+1);
    [~,max1] = max(data.Altitude_1);
    [~,minIndPre1] = min(abs(altPre1-data.Altitude_1(1:max1)));
    [~,minIndPost1] = min(abs(altPost1-data.Altitude_1(1:max1)));

    latDiff1 = data.Latitude_1(minIndPost1)-data.Latitude_1(minIndPre1);
    longDiff1 = data.Longitude_1(minIndPost1)-data.Longitude_1(minIndPre1);
    t1 = datetime(data.Time_1(minIndPre1),'ConvertFrom','excel');
    t2 = datetime(data.Time_1(minIndPost1),'ConvertFrom','excel');
    timeDiff1 = seconds(t2-t1);
    latDiff1 = latDiff1/timeDiff1;
    longDiff1 = longDiff1/timeDiff1;

    t1 = datetime(data.Time_1(i-1),'ConvertFrom','excel');
    t2 = datetime(data.Time_1(i),'ConvertFrom','excel');
    timeDiff = seconds(t2-t1);

    Lat = Lat + latDiff1*timeDiff;
    Long = Long + longDiff1*timeDiff;

    Latitude_1(i) = Lat;
    Longitude_1(i) = Long;
    i = i + 1;
end


% Descent
i = 2;
while true
    if data.Altitude_1(i) <= max(calculatedAlt1) && data.Altitude_1(i-1) > max(calculatedAlt1)
        break
    end
    i = i + 1;
end
descentLatDiff1 = data.Latitude_1(end)-data.Latitude_1(i-5);
descentLongDiff1 = data.Longitude_1(end)-data.Longitude_1(i-5);


descentLatDiff = descentLatDiff1;
descentLongDiff = descentLongDiff1;

Latitude_1(end+1) = Latitude_1(end) + descentLatDiff;
Longitude_1(end+1) = Longitude_1(end) + descentLongDiff;

Latitude_1_1 = Latitude_1;
Longitude_1_1 = Longitude_1;
