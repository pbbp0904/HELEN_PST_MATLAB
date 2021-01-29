function [lightCurve,lightCurveReal] = makeLightCurve(dcc_time,timeBinSize)

clockHz = 50000000;

%Inverse Time Difference
lightCurveReal = clockHz./mod(dcc_time(2:end)-dcc_time(1:end-1),clockHz);

% Windowed Counts
second = 0;
tempPulseData = [];
lightCurve = [];
temp_time = 0;
j = 1;
for i = 2:length(dcc_time)
    if dcc_time(i)<dcc_time(i-1) || dcc_time(i) > clockHz*timeBinSize + temp_time
        j = 1;
        lightCurve(second+1) = sum(sum(tempPulseData));
        
        second = second + 1;
        tempPulseData = [];
        temp_time = dcc_time(i);
    end
    tempPulseData(:,j) = 1;
    j = j + 1;
end


end

