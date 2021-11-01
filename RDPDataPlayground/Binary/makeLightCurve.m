function [lightCurve] = makeLightCurve(PayloadRadData,payloadNumber,timeBinSize,minHeight,maxHeight,filterTails)

subSecondTimes = PayloadRadData{payloadNumber}.subSecond;
pulsedata_b = PayloadRadData{payloadNumber}.pulsedata_b;
isTail = PayloadRadData{payloadNumber}.isTail;

% Windowed Counts

tempCounts = 0;
lightCurve = [];
bin = 1;
binStart = 0;
binEnd = timeBinSize;
i = 1;
c = 0;
while i <= length(subSecondTimes)
    % Bin change
    if subSecondTimes(i) > binEnd && binEnd > binStart
        
        if tempCounts < 1
            disp(i)
            disp(bin)
        end
        
        lightCurve(bin) = tempCounts;
        tempCounts = 0;
        binStart = binEnd;
        binEnd = round(mod(binEnd + timeBinSize,1),8);
        bin = bin + 1;
        
        continue
    elseif subSecondTimes(i) > binEnd && subSecondTimes(i) < binStart && binEnd < binStart
        lightCurve(bin) = tempCounts;
        tempCounts = 0;
        binStart = binEnd;
        binEnd = round(mod(binEnd + timeBinSize,1),8);
        bin = bin + 1;
        continue
    elseif subSecondTimes(i) < binEnd && subSecondTimes(i) < binStart
        lightCurve(bin) = tempCounts;
        tempCounts = 0;
        binStart = binEnd;
        binEnd = round(mod(binEnd + timeBinSize,1),8);
        bin = bin + 1;
        continue
    end
    
    % Add count
    if max(abs(pulsedata_b(i,:))) > minHeight && max(abs(pulsedata_b(i,:))) < maxHeight
        if ~isTail(i) && filterTails
            tempCounts = tempCounts + 1;
        end
    end
    i = i + 1;
    

end


end