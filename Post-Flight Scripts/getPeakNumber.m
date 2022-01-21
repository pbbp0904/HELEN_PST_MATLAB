function [peakNumber] = getPeakNumber(pulsedata)

peakNumber = NaN(length(pulsedata),1);

if height(pulsedata) > 1
    for i = 1:length(pulsedata)
        if ~isnan(pulsedata(i,1))
            m = findpeaks(-pulsedata(i,:),'MinPeakProminence',100,'MinPeakDistance',3);
            peakNumber(i,1) = length(m);
        end
    end
end

end