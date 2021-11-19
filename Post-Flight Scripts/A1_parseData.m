%% A1 Todo


% Make a run file - Sean - Create a text file with the data directory in it, have
% MATLAB load file, and set FlightFolder variable to the data directory 

%%
clear; clc; close all;

FlightFolder = runFile();

if isfolder(FlightFolder + '3-Processed Data') == 0
mkdir(FlightFolder, '3-Processed Data');
end

DirectoryLocation = strcat(FlightFolder,"2-Data to Process");
tic

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


%%
% Add missing environmental data and save

maxPayload = max([length(PayloadEnvData), length(PayloadRadData), length(PayloadEfmData), length(PayloadCamData)]);
if (parseEnv)
    PayloadEnvData = addMissingEnvData(PayloadEnvData, maxPayload);
    fprintf('Saving Environmental Data...\n');
    save(strcat(FlightFolder,"3-Processed Data\PayloadEnvData.mat"),'PayloadEnvData','-v7.3');
    fprintf('Done Saving Environmental Data!\n');
end

% Add missing Radiation data and save
if (parseRad)
    PayloadRadData = addMissingRadData(PayloadRadData, maxPayload);
    fprintf('Saving Radiation Data...\n');
    save(strcat(FlightFolder,"3-Processed Data\PayloadRadData.mat"),'PayloadRadData','-v7.3');
    fprintf('Done Saving Radiation Data!\n');
end


datetime(now,'ConvertFrom','datenum')
toc