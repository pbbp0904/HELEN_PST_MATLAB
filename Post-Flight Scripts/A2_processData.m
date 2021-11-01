clear; clc; close all;
tic
DirectoryLocation = "D:\Flight Data\Testing\Startup Test\Blue Test 1";
PayloadPrefixes = {"1RED", "2GREEN", "3YELLOW", "4BLUE"};
PayloadColors = {"Red", "Green", "Yellow", "Blue"};
RadDetectorTypes = {"LYSO", "CLYC", "LYSO", "LYSO"};
EnvPrefix = "ENV";
EfmPrefix = "EFM";
CamPrefix = "CAM";
CamThreshold = 1;

%% Todo
%A2 Env
%Convert resistances into temperatures
%%

parseEnv = 0; parseRad = 1; parseEfm = 0; parseCam = 0; sumData = 0;

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
    PayloadRadData = parseRadData(DirectoryLocation, PayloadPrefixes, RadDetectorTypes);
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