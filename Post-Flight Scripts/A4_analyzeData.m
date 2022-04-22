%% A4

% (todo) Get number of counts for each time bin throughout the flight
% (todo) Look for cross corelations of events between payloads
% (todo) Add radiation Graphs
%% TODO
% Add more graphs to data report

%% Environmental graphs
% Altitude Errors - gpsAltErrs
% Longitude Errors - gpsLongErrs
% Latitude Errors - gpsLatErrs
% 
% Sat Number - gpsSatNums
% GPS Speed - gpsSpeeds


%% Radiation graphs
% Diff of pulse num
% ppstime
% ppscount


%% More radiation graphs
% Energy altitude graphs
% PSD graph
% Pulse shape histograms

%%
%

FlightFolder = runFile();

PayloadPrefixes = {"1RED", "2GREEN", "3YELLOW", "4BLUE"};
PayloadColors = {"Red", "Green", "Yellow", "Blue"};
RadDetectorTypes = {"LYSO", "CLYC", "LYSO", "LYSO"};

if isfolder(FlightFolder + '6-Graphs') == 0
    mkdir(FlightFolder, '6-Graphs');
end

DirectoryLocation = strcat(FlightFolder,"3-Processed Data/");
DataLocation = strcat(FlightFolder,"5-FlightData/");
imagePath = strcat(FlightFolder,"6-Graphs/");
reportPath = strcat(FlightFolder,"7-Reports/");
tic

if ~exist('PayloadEnvData','var')
    fprintf('Loading Environmental Data...\n');
    load(strcat(DirectoryLocation,"PayloadEnvData.mat"))
end

if ~exist('PayloadRadData','var')
    fprintf('Loading Radiation Data...\n');
    load(strcat(DirectoryLocation,"PayloadRadData.mat"))
    for payloadNumber = 1:length(PayloadRadData)
        % Pulse Tail
        fprintf('Finding Tails for payload %i...\n',payloadNumber);
        PayloadRadData{payloadNumber}.isTail = isTail(PayloadRadData{payloadNumber}.dcc_time,PayloadRadData{payloadNumber}.pulsedata_b);
    end
end

if ~exist('FlightData','var')
    fprintf('Loading Flight Data...\n');
    load(strcat(DataLocation,"FlightData.mat"))
end


Stats = getStats(FlightData, PayloadEnvData, PayloadRadData, PayloadPrefixes);
makeGraphs(FlightData, PayloadEnvData, PayloadRadData, PayloadPrefixes, PayloadColors, Stats, imagePath);


createReport(Stats,imagePath,reportPath)

toc