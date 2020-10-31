function [PayloadEnvData] = parseEnvData(DirectoryLocation, PayloadPrefixes, EnvPrefix)

PayloadEnvData = {};

disp('Parsing Environmental Data...')
% Load and Parse Environmental Data
for payload = 1:length(PayloadPrefixes)
    filename = strcat(DirectoryLocation, "/", PayloadPrefixes{payload}, "_", EnvPrefix, ".TXT");

    % Parsing Environmental Data
    PacketNum = [];
    Pitch = []; Roll = []; Yaw = [];
    AccX = []; AccY = []; AccZ = [];
    GyroX = []; GyroY = []; GyroZ = [];
    MagX = []; MagY = []; MagZ = [];
    IMUTemp = []; HPSTemp = []; EXTTemp = []; BATTemp = []; PMTTemp = [];

    gpsTime = NaN;
    gpsLat = NaN;
    gpsLong = NaN;
    gpsPacketNum = NaN;

    gpsTimes = [];
    gpsLats = []; gpsLongs = [];
    gpsPacketNums = [];


    fid = fopen(filename);
    tline = fgetl(fid);
    while ischar(tline)

        % Environmental Data
        if (~contains(tline, '$') && ~contains(tline, '#') && ~contains(tline, ',,')) && length(tline) > 112
            Gline = strsplit(tline,',');

            PacketNum = [PacketNum str2double(Gline{1})];

            Pitch = [Pitch str2double(Gline{2})];
            Roll = [Roll str2double(Gline{3})];
            Yaw = [Yaw str2double(Gline{4})];

            AccX = [AccX str2double(Gline{5})];
            AccY = [AccY str2double(Gline{6})];
            AccZ = [AccZ str2double(Gline{7})];

            GyroX = [GyroX str2double(Gline{8})];
            GyroY = [GyroY str2double(Gline{9})];
            GyroZ = [GyroZ str2double(Gline{10})];

            MagX = [MagX str2double(Gline{11})];
            MagY = [MagY str2double(Gline{12})];
            MagZ = [MagZ str2double(Gline{13})];

            IMUTemp = [IMUTemp str2double(Gline{14})];
            HPSTemp = [HPSTemp str2double(Gline{15})];
            EXTTemp = [EXTTemp str2double(Gline{16})];
            BATTemp = [BATTemp str2double(Gline{17})];
            PMTTemp = [PMTTemp str2double(Gline{18})];

            % Assign GPS Data
            gpsTimes = [gpsTimes gpsTime];
            gpsLats = [gpsLats gpsLat];
            gpsLongs = [gpsLongs gpsLong];

            gpsPacketNums = [gpsPacketNums gpsPacketNum];

        end
        % GPS Data
        if contains(tline, '$GNRMC,')
            Gline = strsplit(tline,',','CollapseDelimiters',false);
            if (length(Gline) == 13 && strcmp(Gline{1}, '$GNRMC') && contains(Gline{13}, '*') && length(Gline{2}) == 9 && length(Gline{10}) == 6) && length(Gline{13}) == 4 && strcmp(Gline{3}, 'A')
                timeData = Gline{2};
                dateData = Gline{10};
                gpsdatetime = strcat(dateData, timeData);
                
                timeFormat = 'hhMMss.fff';
                dateFormat = 'DDmmYY';
                datetimeFormat = strcat(dateFormat, timeFormat);

                gpsdatenum = datenum(gpsdatetime,datetimeFormat);

                gpsTime = gpsdatenum;
                gpsLat = str2double(Gline{4}(1:2))+str2double(Gline{4}(4:end))/60;
                gpsLong = -str2double(Gline{6}(1:3))-str2double(Gline{6}(4:end))/60;
                
                gpsPacketNum = PacketNum(length(PacketNum));
            end
        end
        tline = fgetl(fid);
    end
    fclose(fid);

    PayloadEnvData{payload} = table(PacketNum, Pitch, Roll, Yaw, AccX, AccY, AccZ, GyroX, GyroY, GyroZ, MagX, MagY, MagZ, IMUTemp, HPSTemp, EXTTemp, BATTemp, PMTTemp, gpsTimes, gpsLats, gpsLongs, gpsPacketNums);

    fprintf('Done with %s\n', PayloadPrefixes{payload});
end
end