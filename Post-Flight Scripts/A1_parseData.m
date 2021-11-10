%% A1 Todo

% Convert resistances into temperatures

%%
clear; clc; close all;
tic
%FlightFolder = "D:\MATLAB\HELEN Data\Flight 2\";
FlightFolder = "D:\MATLAB\HELEN Data\Flight 2\";
DirectoryLocation = strcat(FlightFolder,"2-Data to Process");
PayloadPrefixes = {"1RED", "2GREEN", "3YELLOW", "4BLUE"};
PayloadColors = {"Red", "Green", "Yellow", "Blue"};
RadDetectorTypes = {"LYSO", "CLYC", "LYSO", "LYSO"};
EnvPrefix = "ENV";
EfmPrefix = "EFM";
CamPrefix = "CAM";
CamThreshold = 1;


%%

parseEnv = 1; parseRad = 1; parseEfm = 0; parseCam = 0;

PayloadEnvData = {};
PayloadRadData = {};
PayloadEfmData = {};
PayloadCamData = {};

% Load and Parse Environmental Data
if (parseEnv)
   PayloadEnvData = parseEnvData(DirectoryLocation, PayloadPrefixes, EnvPrefix);
   fprintf('Saving Environmental Data...\n');
   save(strcat(FlightFolder,"3-Processed Data\PayloadEnvData.mat"),'PayloadEnvData','-v7.3');
   fprintf('Done Saving Environmental Data!\n');
end

% Load and Parse Radiation Data
if (parseRad)
    PayloadRadData = parseRadData(DirectoryLocation, PayloadPrefixes, RadDetectorTypes);
    fprintf('Saving Radiation Data...\n');
    save(strcat(FlightFolder,"3-Processed Data\PayloadRadData.mat"),'PayloadRadData','-v7.3');
    fprintf('Done Saving Radiation Data!\n');
end

% Load and Parse EFM Data
if(parseEfm)
    PayloadEfmData = parseEfmData(DirectoryLocation, PayloadPrefixes, EfmPrefix);
end

% Load and Parse Camera Data
if(parseCam)
    PayloadCamData = parseCamData(DirectoryLocation, PayloadPrefixes, CamPrefix, CamThreshold);
end

datetime(now,'ConvertFrom','datenum')
toc