function [peakNumber] = getPeakNumber(pulsedata)

peakNumber = zeros(1,length(pulsedata));
for i = 1:length(pulsedata)
    m = findpeaks(-pulsedata(i,:),'MinPeakProminence',100,'MinPeakDistance',3);
    peakNumber(i) = length(m);
end

end

