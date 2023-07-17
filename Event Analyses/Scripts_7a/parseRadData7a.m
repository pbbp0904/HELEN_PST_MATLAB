function [PayloadRadData] = parseRadData7a(DirectoryLocation, PayloadPrefixes, RadDetectorTypes)

PayloadRadData = {};

disp('Parsing Radiation Data...')
% Load and Parse Radiation Data
parfor payload = 1:length(PayloadPrefixes)
    dataFolder = strcat(DirectoryLocation, "/", PayloadPrefixes{payload}, "_RAD");
    dataFiles = dir(dataFolder);
    
    % Resort list so the data is actually in order
    [~, reindex] = sort( str2double( regexp( {dataFiles.name}, '\d+', 'match', 'once' )));
    dataFiles = dataFiles(reindex);
    dataFiles = dataFiles(1:end-2);
    
    j = 1;
    lineLength = 0;
    
    pps_count = [];
    pps_time  = [];
    dcc_time  = [];
    pulse_num  = [];
    buff_diff  = [];
    pulsedata_a = [];
    pulsedata_b = [];
    
    for dataFile = 1:length(dataFiles)
        fileID = fopen(strcat(dataFolder,"/",dataFiles(dataFile).name));
        data = fread(fileID,24903681,'uint32');
        fclose(fileID);

        tracker = 38;
        j = j - 1;

        fprintf(repmat('\b',1,lineLength));
        lineLength = fprintf("Parsing %s (%s) %i/%i",PayloadPrefixes{payload},RadDetectorTypes{payload},dataFile,length(dataFiles));
        
        for i=1:length(data)
            if data(i) == 2^32-1 && tracker >= 38
                tracker = 0;
                j = j + 1;
            end
            if tracker == 1
                pps_count(j) = data(i);
            elseif tracker == 2
                pps_time(j) = data(i);
            elseif tracker == 3
                dcc_time(j) = data(i);
            elseif tracker == 4
                pulse_num(j) = data(i);
            elseif tracker == 5
                buff_diff(j) = typecast(uint32(data(i)),'int32');
            elseif tracker < 38 && tracker > 0
                pulsedata_a(tracker-5,j) = typecast(uint16(mod(data(i),2^16))*4,'int16')/4;
                pulsedata_b(tracker-5,j) = typecast(uint16(data(i)/2^16)*4,'int16')/4;
            end
            tracker = tracker + 1;
        end

        
    end
    fprintf(repmat('\b',1,lineLength));

    PayloadRadData{payload} = table(pps_count',pps_time',dcc_time',pulse_num',buff_diff',pulsedata_a',pulsedata_b','VariableNames',{'pps_count','pps_time','dcc_time','pulse_num','buff_diff','pulsedata_a','pulsedata_b'});
    if ~isempty(PayloadRadData{payload})
        fprintf('Done with %s\n', PayloadPrefixes{payload});
    else
        fprintf('Failed to load %s\n', PayloadPrefixes{payload});
    end
end

% Add missing payloads
PayloadRadData = addMissingRadData(PayloadRadData, 4);

for payloadNumber = 4
    % Calculate subsecond values for pulses
    fprintf('Finding Subsecond Values for payload %i...\n',payloadNumber);
    [PayloadRadData{payloadNumber}.ppsTimeCorrected, PayloadRadData{payloadNumber}.subSecond] = findSubSeconds7a(PayloadRadData{payloadNumber}.pps_time, PayloadRadData{payloadNumber}.dcc_time);

    % Add missing pulses to the data table
    fprintf('Adding in Missed Pulses for payload %i...\n',payloadNumber);
    PayloadRadData{payloadNumber} = addMissedPulses(PayloadRadData{payloadNumber});
    
    % Pulse Pile Up
    %fprintf('Finding Pulse Pile Ups for payload %i...\n',payloadNumber);
    %PayloadRadData{payloadNumber}.PeakNumber = getPeakNumber(PayloadRadData{payloadNumber}.pulsedata_b);
    
    % Particle Type
    %fprintf('Finding Particle Type for payload %i...\n',payloadNumber);
    %PayloadRadData{payloadNumber} = particleType(PayloadRadData{payloadNumber});
    
    % Energy
    fprintf('Finding Energies for payload %i...\n',payloadNumber);
    [PayloadRadData{payloadNumber}.EPeakA, PayloadRadData{payloadNumber}.EIntA, PayloadRadData{payloadNumber}.EPeakB, PayloadRadData{payloadNumber}.EIntB] = getEnergies(PayloadRadData{payloadNumber}.pulsedata_a, PayloadRadData{payloadNumber}.pulsedata_b, RadDetectorTypes{payloadNumber});
    
    % Pulse Tail
    fprintf('Finding Tails for payload %i...\n',payloadNumber);
    PayloadRadData{payloadNumber}.isTail = isTail(PayloadRadData{payloadNumber}.dcc_time,PayloadRadData{payloadNumber}.pulsedata_b);

    % Overall time
    % Starting RAD Second 
    secondOffset = 7;

    i = 2;
    t(1) = 0;
    lastSubSecond = 1;
    second = -1;
    
    subSecs = PayloadRadData{payloadNumber}.subSecond;
    t = [];
    nanmask = isnan(subSecs);
    while i <= length(subSecs)
        if ~nanmask(i)
            if subSecs(i) < lastSubSecond
                second = second + 1;
            end
            lastSubSecond = subSecs(i);
            t(i) = second + secondOffset + subSecs(i);
        else
            t(i) = NaN;
        end
        i = i + 1;
    end
    t(1) = 0;
    PayloadRadData{payloadNumber}.time = t';
    PayloadRadData{payloadNumber}.timeInterp = fillmissing(t','linear');
end

fprintf('Radiation Data Parsing Complete!\n');
end

