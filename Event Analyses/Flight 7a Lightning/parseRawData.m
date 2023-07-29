%function parseRawData()

%clear; clc; close all;
FlightFolder = "E:\Flight Data\Flight 7a\";

if isfolder(FlightFolder + '3-Processed Data') == 0
    mkdir(FlightFolder, '3-Processed Data');
end

DirectoryLocation = strcat(FlightFolder,"2-Data to Process");
tic

PayloadPrefixes = {"1RED", "2GREEN", "3YELLOW", "4BLUE"};
PayloadColors = {"Red", "Green", "Yellow", "Blue"};
RadDetectorTypes = {"LYSO", "CLYC", "CLYC", "LYSO"};
EnvPrefix = "ENV";
CamPrefix = "CAM";
CamThreshold = 1;


%%

parseEnv = 0; parseRad = 1; parseCam = 0;

PayloadEnvData = {};
PayloadRadData = {};
PayloadCamData = {};

% Load and Parse Environmental Data
if (parseEnv)
    PayloadEnvData = parseEnvData7a(DirectoryLocation, PayloadPrefixes, EnvPrefix);
end

% Load and Parse Radiation Data
if (parseRad)
    PayloadRadData = parseRadData7a(DirectoryLocation, PayloadPrefixes, RadDetectorTypes);
end

% Load and Parse Camera Data
if(parseCam)
    PayloadCamData = parseCamData7a(DirectoryLocation, PayloadPrefixes, CamPrefix, CamThreshold);
end


%%
% Save environmental data
if (parseEnv)
    fprintf('Saving Environmental Data...\n');
    save(strcat(FlightFolder,"3-Processed Data\PayloadEnvData.mat"),'PayloadEnvData','-v7.3');
    fprintf('Done Saving Environmental Data!\n');
end

% Save radiation data
if (parseRad)
    fprintf('Saving Radiation Data...\n');
    save(strcat(FlightFolder,"3-Processed Data\PayloadRadData.mat"),'PayloadRadData','-v7.3');
    fprintf('Done Saving Radiation Data!\n');
end

% Save camera data
if (parseCam)
    fprintf('Saving Camera Data...\n');
    save(strcat(FlightFolder,"3-Processed Data\PayloadCamData.mat"),'PayloadCamData','-v7.3');
    fprintf('Done Saving Camera Data!\n');
end


datetime(now,'ConvertFrom','datenum')
toc
%end

