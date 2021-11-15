function [PayloadRadData] = parseRadData(DirectoryLocation, PayloadPrefixes, RadDetectorTypes)

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

fprintf('Radiation Data Parsing Complete!\n');
end

