payloadNumber = 2;
numOfPeaks = [];
for i = 1500000:1600000
    [pks] = findpeaks(-PayloadRadData{payloadNumber}.pulsedata_b(i,:),'MinPeakProminence',(max(-PayloadRadData{payloadNumber}.pulsedata_b(i,:))-min(-PayloadRadData{payloadNumber}.pulsedata_b(i,10:end)))/2,'MinPeakDistance',6);
    numOfPeaks(i) = length(pks);
    if numOfPeaks(i) ~= -1 && ~PayloadRadData{payloadNumber}.isTail(i) && max(-PayloadRadData{payloadNumber}.pulsedata_b(i,:)) > 1000
        findpeaks(-PayloadRadData{payloadNumber}.pulsedata_b(i,:),'MinPeakProminence',(max(-PayloadRadData{payloadNumber}.pulsedata_b(i,:))-min(-PayloadRadData{payloadNumber}.pulsedata_b(i,10:end)))/2,'MinPeakDistance',6,'Annotate','extents')
        ylim([-3000 3000])
        title(num2str(std(PayloadRadData{payloadNumber}.pulsedata_b(i,10:end))))
        drawnow
        pause
    end
end

histogram(numOfPeaks(1500000:1600000))





%%%%% LYSO
% peakNumber = zeros(1,length(pulsedata));
% for i = 1:length(pulsedata)
%     m = findpeaks(-pulsedata(i,:),'MinPeakProminence',100,'MinPeakDistance',3);
%     peakNumber(i) = length(m);
% end