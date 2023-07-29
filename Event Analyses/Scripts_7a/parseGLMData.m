function [all_data] = parseGLMData(dir_path)
% Get all .nc files in directory
files = dir(fullfile(dir_path, '*.nc'));

% Initialize an empty table to store all data
all_data = table();

% Loop over each file
for i = 1:length(files)
    % Full file path
    file_path = fullfile(files(i).folder, files(i).name);

    % Read in the data
    GLM_event_lat = ncread(file_path,'event_lat');
    GLM_event_long = ncread(file_path,'event_lon');
    GLM_event_energy = ncread(file_path, 'event_energy');

    % Add proper corrections
    GLM_event_lat = double(typecast(int16(round((GLM_event_lat+66.56)/0.0020313)),'uint16'))*0.0020313-66.56; % Convert properly
    GLM_event_long = double(typecast(int16(round((GLM_event_long+141.56)/0.0020313)),'uint16'))*0.0020313-141.56; % Convert properly
    GLM_event_energy = double(typecast(int16(round((GLM_event_energy-2.8515e-16)/(1.9024e-17))),'uint16'))*(1.9024e-17)+2.8515e-16; % Convert properly

    % Read time data
    GLM_event_time = ncread(file_path,'event_time_offset');

    % Add proper correction except for file offset
    GLM_event_time = double(typecast(int16(round((GLM_event_time+5)/0.00038148)),'uint16'))*0.00038148-5; % Convert properly

    % Get offset for the time
    base_time_str = ncreadatt(file_path, 'event_time_offset', 'units');
    
    % Extract the base time from the units string
    base_time = datetime(base_time_str(14:end), 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
    day_start_time = datetime(base_time_str(14:end-13), 'InputFormat', 'yyyy-MM-dd');
    seconds_offset = seconds(base_time-day_start_time);
    
    % Adjust the time offset
    GLM_event_time = GLM_event_time + seconds_offset;
    
    % Create a table with the data
    file_data = table(GLM_event_time, GLM_event_lat, GLM_event_long, GLM_event_energy);
    
    % Append the data to the all_data table
    all_data = [all_data; file_data];  %#ok<AGROW>
end
end

