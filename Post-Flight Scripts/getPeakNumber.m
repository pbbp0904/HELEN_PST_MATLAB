function [peakNumber] = getPeakNumber(pulsedata)

peakNumber = NaN(1,length(pulsedata));

if height(pulsedata) > 1
    for i = 1:length(pulsedata)
        if ~isnana(pulsedata(i,1))
            m = findpeaks(-pulsedata(i,:),'MinPeakProminence',100,'MinPeakDistance',3);
            peakNumber(i) = length(m);
        end
    end
end

end