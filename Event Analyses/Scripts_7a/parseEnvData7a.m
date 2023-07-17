function [PayloadEnvData] = parseEnvData7a(DirectoryLocation, PayloadPrefixes, EnvPrefix)

PayloadEnvData = {};

disp('Parsing Environmental Data...')
% Load and Parse Environmental Data
parfor payload = 1:length(PayloadPrefixes)
    try
    filename = strcat(DirectoryLocation, "/", PayloadPrefixes{payload}, "_", EnvPrefix, ".TXT");

    % Parsing Environmental Data
    PacketNum = [];
    PacketNumLogged = [];
    Pitch = []; Roll = []; Yaw = [];
    AccX = []; AccY = []; AccZ = [];
    GyroX = []; GyroY = []; GyroZ = [];
    MagX = []; MagY = []; MagZ = [];
    IMUTemp = []; HPSTemp = []; EXTTemp = []; BATTemp = []; PMTTemp = [];

    gpsPacketNum = NaN;
    gpsTime = NaN;
    gpsLat = NaN;
    gpsLong = NaN;
    gpsSpeed = NaN;
    gpsAngle = NaN;
    
    gpsAlt = NaN;
    gpsSatNum = NaN;

    gpsLatErr = NaN;
    gpsLongErr = NaN;
    gpsAltErr = NaN;
    
    gpsClkBias = NaN;
    gpsClkDrift = NaN;
    gpsTimeErr = NaN;
    
    
    gpsPacketNums = [];
    gpsTimes = [];
    gpsLats = []; 
    gpsLongs = [];
    gpsSpeeds = [];
    gpsAngles = [];
    
    gpsAlts = [];
    gpsSatNums = [];
    
    gpsLatErrs = [];
    gpsLongErrs = [];
    gpsAltErrs = [];
    
    gpsClkBiases = [];
    gpsClkDrifts = [];
    gpsTimeErrs = [];
    

    fid = fopen(filename);
    tline = fgetl(fid);
    packet = 0;
    badGPS = 0;
    while ischar(tline)

        % Environmental Data
        if (~contains(tline, '$') && ~contains(tline, '#') && ~contains(tline, ',,')) && length(tline) > 112
            Gline = strsplit(tline,',');

            PacketNum = [PacketNum; packet];
            packet = packet+1;
            PacketNumLogged = [PacketNumLogged; str2double(Gline{1})];

            Pitch = [Pitch; str2double(Gline{2})];
            Roll = [Roll; str2double(Gline{3})];
            Yaw = [Yaw; str2double(Gline{4})];

            AccX = [AccX; str2double(Gline{5})/1000*9.80665];
            AccY = [AccY; str2double(Gline{6})/1000*9.80665];
            AccZ = [AccZ; str2double(Gline{7})/1000*9.80665];

            GyroX = [GyroX; str2double(Gline{8})/10];
            GyroY = [GyroY; str2double(Gline{9})/10];
            GyroZ = [GyroZ; str2double(Gline{10})/10];

            MagX = [MagX; str2double(Gline{11})];
            MagY = [MagY; str2double(Gline{12})];
            MagZ = [MagZ; str2double(Gline{13})];

            IMUTemp = [IMUTemp; str2double(Gline{14})/100];
            HPSTemp = [HPSTemp; channel2Temp(str2double(Gline{15}))];
            EXTTemp = [EXTTemp; channel2Temp(str2double(Gline{16}))];
            BATTemp = [BATTemp; channel2Temp(str2double(Gline{17}))];
            PMTTemp = [PMTTemp; channel2Temp(str2double(Gline{18}))];

            % Assign GPS Data
            gpsPacketNums = [gpsPacketNums; gpsPacketNum];
            gpsTimes = [gpsTimes; gpsTime];
            gpsLats = [gpsLats; gpsLat];
            gpsLongs = [gpsLongs; gpsLong];
            gpsSpeeds = [gpsSpeeds; gpsSpeed];
            gpsAngles = [gpsAngles; gpsAngle];
            
            gpsAlts = [gpsAlts; gpsAlt];
            gpsSatNums = [gpsSatNums; gpsSatNum];

            gpsLatErrs = [gpsLatErrs; gpsLatErr];
            gpsLongErrs = [gpsLongErrs; gpsLongErr];
            gpsAltErrs = [gpsAltErrs; gpsAltErr];
            
            gpsClkBiases = [gpsClkBiases; gpsClkBias];
            gpsClkDrifts = [gpsClkDrifts; gpsClkDrift];
            gpsTimeErrs = [gpsTimeErrs; gpsTimeErr];

        end
        % GPS Data
        if contains(tline, '$GNRMC,')
            Gline = strsplit(tline,',','CollapseDelimiters',false);
            if (length(Gline) == 13 && strcmp(Gline{1}, '$GNRMC') && contains(Gline{13}, '*') && length(Gline{2}) == 9 && length(Gline{10}) == 6) && length(Gline{13}) == 4 && strcmp(Gline{3}, 'A')
                
                if (Gline{4} == "-1" && Gline{6} == "-1")
                    badGPS = 1;
                    timeData = Gline{2};
                    dateData = Gline{10};
                    gpsdatetime = strcat(dateData, timeData);
                    
                    timeFormat = 'hhMMss.fff';
                    dateFormat = 'DDmmYY';
                    datetimeFormat = strcat(dateFormat, timeFormat);
    
                    gpsdatenum = datenum(gpsdatetime,datetimeFormat);
    
                    gpsTime = gpsdatenum;
                    gpsLat = NaN;
                    gpsLong = NaN;
                    
                    gpsSpeed = NaN;
                    gpsAngle = NaN;

                    gpsPacketNum = PacketNum(length(PacketNum));

                else
                    badGPS = 0;
                    timeData = Gline{2};
                    dateData = Gline{10};
                    gpsdatetime = strcat(dateData, timeData);
                    
                    timeFormat = 'hhMMss.fff';
                    dateFormat = 'DDmmYY';
                    datetimeFormat = strcat(dateFormat, timeFormat);
    
                    gpsdatenum = datenum(gpsdatetime,datetimeFormat);
    
                    gpsTime = gpsdatenum;
                    gpsLat = str2double(Gline{4}(1:2))+str2double(Gline{4}(3:end))/60;
                    gpsLong = -str2double(Gline{6}(1:3))-str2double(Gline{6}(4:end))/60;
                    
                    gpsSpeed = str2double(Gline{8})*0.514444; % Convert to m/s
                    gpsAngle = str2double(Gline{9});
                    
                    gpsPacketNum = PacketNum(length(PacketNum))+1;
                end
            end
        end
        
        if contains(tline, '$GNGGA,')
            Gline = strsplit(tline,',','CollapseDelimiters',false);
            if (length(Gline) == 15 && strcmp(Gline{1}, '$GNGGA') && contains(Gline{15}, '*') && length(Gline{2}) == 9 && length(Gline{15}) == 3 && str2double(Gline{7})>0)
                if badGPS
                    gpsAlt = NaN;
                    gpsSatNum = NaN;
                else
                    gpsAlt = str2double(Gline{10});
                    gpsSatNum = str2double(Gline{8});
                end
            end
        end
        
        if contains(tline, '$GNGST,')
            Gline = strsplit(tline,',','CollapseDelimiters',false);
            if (length(Gline) == 9 && strcmp(Gline{1}, '$GNGST') && contains(Gline{9}, '*') && str2double(Gline{3}) > 0)
                if badGPS
                    gpsLatErr = NaN;
                    gpsLongErr = NaN;
                    gpsAltErr = NaN;
                else
                    gpsLatErr = str2double(Gline{7});
                    gpsLongErr = str2double(Gline{8});
                
                    tempgpsAltErr = strsplit(Gline{9},'*');
                    gpsAltErr = str2double(tempgpsAltErr(1));
                end
                
            end
        end
        
        if contains(tline, '$PUBX,04')
            Gline = strsplit(tline,',','CollapseDelimiters',false);
            if (length(Gline) == 10 && strcmp(Gline{1}, '$PUBX') && strcmp(Gline{2}, '04') && contains(Gline{10}, '*') && str2double(Gline{3}) > 0 && ~contains(Gline{7}, 'D'))
                if badGPS
                    gpsClkBias = NaN;
                    gpsClkDrift = NaN;
                    gpsTimeErr = NaN;
                else
                    gpsClkBias = str2double(Gline{8});
                    gpsClkDrift = str2double(Gline{9});
                    
                    tempgpsTimeErr = strsplit(Gline{10},'*');
                    gpsTimeErr = str2double(tempgpsTimeErr(1));
                end
            end
        end
        tline = fgetl(fid);
    end
    fclose(fid);

    PayloadEnvData{payload} = table(PacketNum, PacketNumLogged, Pitch, Roll, Yaw, AccX, AccY, AccZ, GyroX, GyroY, GyroZ, MagX, MagY, MagZ, IMUTemp, HPSTemp, EXTTemp, BATTemp, PMTTemp, gpsPacketNums, gpsTimes, gpsLats, gpsLongs, gpsSpeeds, gpsAngles, gpsAlts, gpsSatNums, gpsLatErrs, gpsLongErrs, gpsAltErrs, gpsClkBiases, gpsClkDrifts, gpsTimeErrs);
    %PayloadEnvData{payload}.Properties.VariableDescriptions = {'PacketNum=number', 'PacketNum=number', 'Pitch=degrees', 'Roll=degrees', 'Yaw=degrees', 'AccX=meters/second^2', 'AccY=meters/second^2', 'AccZ=meters/second^2', 'GyroX=degrees/second', 'GyroY=degrees/second', 'GyroZ=degrees/second', 'MagX=???', 'MagY=???', 'MagZ=???', 'IMUTemp=Celsius', 'HPSTemp=???', 'EXTTemp=???', 'BATTemp=???', 'PMTTemp=???', 'gpsPacketNums=number', 'gpsTimes=date number', 'gpsLats=decimal latitude', 'gpsLongs=decimal longitude', 'gpsSpeeds=meters/second', 'gpsAngles=degrees', 'gpsAlts=meters', 'gpsSatNums=number', 'gpsLatErrs=standard deviation in meters', 'gpsLongErrs=standard deviation in meters', 'gpsAltErrs=standard deviation in meters', 'gpsClkBiases=nanoseconds', 'gpsClkDrifts=nanoseconds/second', 'gpsTimeErrs=standard deviation in nanoseconds'};
    PayloadEnvData{payload}.Properties.VariableUnits = {'number', 'number', 'degrees', 'degrees', 'degrees', 'meters/second^2', 'meters/second^2', 'meters/second^2', 'degrees/second', 'degrees/second', 'degrees/second', '???', '???', '???', 'Celsius', 'Celsius', 'Celsius', 'Celsius', 'Celsius', 'number', 'date number', 'decimal latitude', 'decimal longitude', 'meters/second', 'degrees', 'meters', 'number', 'standard deviation in meters', 'standard deviation in meters', 'standard deviation in meters', 'nanoseconds', 'nanoseconds/second', 'standard deviation in nanoseconds'};
    
    fprintf('Done with %s\n', PayloadPrefixes{payload});
    catch
        PayloadEnvData{payload} = [];
        fprintf('Failed to load %s\n', PayloadPrefixes{payload});
    end
end

% Set missing data to NaN
for i = 1:height(PayloadEnvData{4})
    if table2array(PayloadEnvData{4}(i,2)) == -1
        PayloadEnvData{4}(i,2:19) = {NaN};
    end
end

% Fill in NaN data
for i = 3:width(PayloadEnvData{4})
    PayloadEnvData{4}(:,i) = fillmissing(PayloadEnvData{4}(:,i),'linear');
end

% Round values
PayloadEnvData{4}.GyroX = round(PayloadEnvData{4}.GyroX,1);
PayloadEnvData{4}.GyroY = round(PayloadEnvData{4}.GyroY,1);
PayloadEnvData{4}.GyroZ = round(PayloadEnvData{4}.GyroZ,1);
PayloadEnvData{4}.MagX = round(PayloadEnvData{4}.MagX);
PayloadEnvData{4}.MagY = round(PayloadEnvData{4}.MagY);
PayloadEnvData{4}.MagZ = round(PayloadEnvData{4}.MagZ);
PayloadEnvData{4}.IMUTemp = round(PayloadEnvData{4}.IMUTemp,2);
PayloadEnvData{4}.gpsAngles = round(PayloadEnvData{4}.gpsAngles,2);
PayloadEnvData{4}.gpsSatNums = round(PayloadEnvData{4}.gpsSatNums);
PayloadEnvData{4}.gpsLatErrs = round(PayloadEnvData{4}.gpsLatErrs,1);
PayloadEnvData{4}.gpsLongErrs = round(PayloadEnvData{4}.gpsLongErrs,1);
PayloadEnvData{4}.gpsAltErrs = round(PayloadEnvData{4}.gpsAltErrs,1);
PayloadEnvData{4}.gpsClkBiases = round(PayloadEnvData{4}.gpsClkBiases);
PayloadEnvData{4}.gpsClkDrifts = round(PayloadEnvData{4}.gpsClkDrifts,3);
PayloadEnvData{4}.gpsTimeErrs = round(PayloadEnvData{4}.gpsTimeErrs);

% Add missing payloads
PayloadEnvData = addMissingEnvData(PayloadEnvData, 4);


end