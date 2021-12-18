function PayloadEfmData = parseEfmData(DirectoryLocation, PayloadPrefixes, EfmPrefix)

PayloadEfmData = {};

disp('Parsing EFM Data...')
% Load and Parse Environmental Data
for payload = 1:length(PayloadPrefixes)
    try
        filename = strcat(DirectoryLocation, "/", PayloadPrefixes{payload}, "_", EfmPrefix, ".TXT");

        % Parsing EFM Data
        PacketNum = [];
        ADC = [];
        Pitch = []; Roll = []; Yaw = [];
        AccX_RAW = []; AccY_RAW = []; AccZ_RAW = [];
        GyroX_RAW = []; GyroY_RAW = []; GyroZ_RAW = [];
        MagX_RAW = []; MagY_RAW = []; MagZ_RAW = [];
        IMUTemp = [];


        fid = fopen(filename);
        tline = fgetl(fid);
        while ischar(tline)

            % EFM RAW Data
            Gline = strsplit(tline,',','CollapseDelimiters',false);
            if (~contains(tline, '#') && length(Gline)==15)
                PacketNum = [PacketNum str2double(Gline{1})];

                ADC = [ADC str2double(Gline{2})];

                Pitch = [Pitch str2double(Gline{3})];
                Roll = [Roll str2double(Gline{4})];
                Yaw = [Yaw str2double(Gline{5})];

                AccX_RAW = [AccX_RAW str2double(Gline{6})];
                AccY_RAW = [AccY_RAW str2double(Gline{7})];
                AccZ_RAW = [AccZ_RAW str2double(Gline{8})];

                GyroX_RAW = [GyroX_RAW str2double(Gline{9})];
                GyroY_RAW = [GyroY_RAW str2double(Gline{10})];
                GyroZ_RAW = [GyroZ_RAW str2double(Gline{11})];

                MagX_RAW = [MagX_RAW str2double(Gline{12})];
                MagY_RAW = [MagY_RAW str2double(Gline{13})];
                MagZ_RAW = [MagZ_RAW str2double(Gline{14})];

                IMUTemp = [IMUTemp str2double(Gline{15})];
            end
            tline = fgetl(fid);

        end
        fclose(fid);




        % Converting EFM Data
        % Conversions and constants
        Ks.e0 = 8.854*10^(-12); %F/m
        Ks.g = 9.81; %m/s^2

        % Known EFM physical properties
        Ks.sphereRadius = .0762; %m
        Ks.sphereArea = 2*4*pi*(Ks.sphereRadius)^2*.75; %Area of both spheres in m^2
        Ks.IMURadius = .05; %m
        Ks.IMUXDir = -1; % Direction relative to radial acceleration - inverted
        Ks.IMUYDir = 1; % Direction along the axis of sphere rotation
        Ks.IMUZDir = -1; % Direction relative to tangential acceleration - inverted

        % Known EFM electrical properties
        Ks.chargeAmpResistance = 1000000; %Ohms
        Ks.chargeAmpCapacitance = 0.000001; %F
        Ks.ampGain = -9.3;
        Ks.samplePeriod = .02; %s

        Ks.ADCRange = 3.2/1.6; %V
        Ks.ADCResolution = 2^11; %bit
        Ks.GyroRange = 2000/360; %rev/s
        Ks.GyroResolution = 2^15; %bit

        dataStart = 1;
        dataFinish = length(PacketNum);

        time = [];
        if dataFinish>=dataStart
            time = Ks.samplePeriod:Ks.samplePeriod:(dataFinish-dataStart)*Ks.samplePeriod;
        end

        voltage = ((ADC)*Ks.ADCRange/Ks.ADCResolution); % Converts to volts
        AccX = AccX_RAW/1000*9.81; % Converts to m/s^2
        AccY = AccY_RAW/1000*9.81; % Converts to m/s^2
        AccZ = AccZ_RAW/1000*9.81; % Converts to m/s^2
        MagX = MagX_RAW*10; % Converts to nT
        MagY = MagY_RAW*10; % Converts to nT
        MagZ = MagZ_RAW*10; % Converts to nT
        GyroX = GyroX_RAW*Ks.GyroRange/Ks.GyroResolution; % Converts to rev/s
        GyroY = GyroY_RAW*Ks.GyroRange/Ks.GyroResolution; % Converts to rev/s
        GyroZ = GyroZ_RAW*Ks.GyroRange/Ks.GyroResolution; % Converts to rev/s

        eField_RAW = [];
        if dataFinish>30000
            eField_RAW = -(voltage-mean(voltage(20000:30000)))/Ks.sphereArea/Ks.e0/Ks.ampGain*Ks.chargeAmpCapacitance; % Converts to V/m
        end

        % 1D eField
        eField = [];
        for i = 1:length(eField_RAW)
            eField(i) = max(smooth(eField_RAW(max(1,i-2/Ks.samplePeriod):min(length(eField_RAW),i+2/Ks.samplePeriod)),5));
        end

        PayloadEfmData{payload} = table(PacketNum, ADC, Pitch, Roll, Yaw, AccX_RAW, AccY_RAW, AccZ_RAW, GyroX_RAW, GyroY_RAW, GyroZ_RAW, MagX_RAW, MagY_RAW, MagZ_RAW, IMUTemp, time, AccX, AccY, AccZ, MagX, MagY, MagZ, GyroX, GyroY, GyroZ, eField_RAW, eField);

        fprintf('Done with %s\n', PayloadPrefixes{payload});
    catch
        PayloadEnvData{payload} = [];
        fprintf('Failed to load %s\n', PayloadPrefixes{payload});
    end
end
end

