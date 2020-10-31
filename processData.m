clear; clc; close all;
tic
DirectoryLocation = "D:/Flight Data/GroundTest4Data";
PayloadPrefixes = {"1RED", "2GREEN", "3YELLOW", "4BLUE"};
PayloadColors = {"Red", "Green", "Yellow", "Blue"};
RadPrefixes = {"RAD_PEAK", "RAD_TAIL", "RAD_TIME"};
EnvPrefix = "ENV";
EfmPrefix = "EFM";
CamPrefix = "CAM";
CamThreshold = 1;

parseEnv = 1; parseRad = 0; parseEfm = 1; parseCam = 1; sumData = 1;

PayloadEnvData = {};
PayloadRadData = {};
PayloadEfmData = {};
PayloadCamData = {};

% Load and Parse Environmental Data
if (parseEnv)
   PayloadEnvData = parseEnvData(DirectoryLocation, PayloadPrefixes, EnvPrefix);
end

% Load and Parse Radiation Data
if (parseRad)
    PayloadRadData = parseRadData(DirectoryLocation, PayloadPrefixes, RadPrefixes);
end

% Load and Parse EFM Data
if(parseEfm)
    PayloadEfmData = parseEfmData(DirectoryLocation, PayloadPrefixes, EfmPrefix);
end

% Load and Parse Camera Data
if(parseCam)
    PayloadCamData = parseCamData(DirectoryLocation, PayloadPrefixes, CamPrefix, CamThreshold);
end


% Summarize Data
if(sumData)
    [Stats, Graphs] = summarizeData(PayloadEnvData, PayloadRadData, PayloadPrefixes, PayloadColors);
end
datetime(now,'ConvertFrom','datenum')
toc