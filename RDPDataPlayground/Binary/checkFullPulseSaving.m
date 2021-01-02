clear; clc; close all; format long;

importPath = "E:\Flight Data\FullPulseTestData\Test54\data_0";

tic

fileID = fopen(importPath);
data = fread(fileID,10000000000000000,'uint32');

pps_count = [];
pps_time  = [];
dcc_time  = [];
pulse_num  = [];
buff_diff  = [];
pulsedata_a = [];
pulsedata_b = [];

tracker = 38;
j = 0;
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