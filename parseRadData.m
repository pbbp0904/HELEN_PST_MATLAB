function [PayloadRadData] = parseRadData(DirectoryLocation, PayloadPrefixes, RadPrefixes)

PayloadRadData = {};

disp('Parsing Radiation Data...')
% Load and Parse Radiation Data
for payload = 1:length(PayloadPrefixes)
    peak_filename = strcat(DirectoryLocation, "/", PayloadPrefixes{payload}, "_", RadPrefixes{1}, ".binary");
    tail_filename = strcat(DirectoryLocation, "/", PayloadPrefixes{payload}, "_", RadPrefixes{2}, ".binary");
    time_filename = strcat(DirectoryLocation, "/", PayloadPrefixes{payload}, "_", RadPrefixes{3}, ".binary");

    fileID = fopen(peak_filename);
    peak_data = fread(fileID,10000000000000000,'uint16');
    fileID = fopen(tail_filename);
    tail_data = fread(fileID,10000000000000000,'uint16');
    fileID = fopen(time_filename);
    time_data = fread(fileID,10000000000000000,'uint32');

    a_peak_data = peak_data(1:2:2*length(time_data));
    b_peak_data = peak_data(2:2:2*length(time_data));
    a_tail_data = tail_data(1:2:2*length(time_data));
    b_tail_data = tail_data(2:2:2*length(time_data));

    a_peak_data = a_peak_data(a_peak_data~=65535);
    b_peak_data = b_peak_data(b_peak_data~=65535);
    a_tail_data = a_tail_data(a_tail_data~=65535);
    b_tail_data = b_tail_data(b_tail_data~=65535);
    time_data = time_data(time_data~=2^32-1);

    PayloadRadData{payload} = table(time_data,a_peak_data,a_tail_data,b_peak_data,b_tail_data);
    fprintf('Done with %s\n', PayloadPrefixes{payload});
end
end

