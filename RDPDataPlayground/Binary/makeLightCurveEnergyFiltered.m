function [lightCurve,lightCurveReal] = makeLightCurveEnergyFiltered(dcc_time,pulsedata_b,timeBinSize,minHeight,maxHeight)

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
    if max(abs(pulsedata_b(i,:))) > minHeight && max(abs(pulsedata_b(i,:))) < maxHeight
        tempPulseData(:,j) = 1;
        j = j + 1;
    end
end


end

