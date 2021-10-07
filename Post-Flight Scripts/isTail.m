function [PayloadRadData] = isTail(PayloadRadData)
clockHz = 50000000;
likelyTailThreshold = 650;
likelyPeakThreshold = 2;

for i = 1:length(PayloadRadData)
   isPulseTail=[];
   if ~isempty(PayloadRadData{i}.dcc_time)
       d = mod(diff(PayloadRadData{i}.dcc_time),clockHz);
       h = max(-PayloadRadData{i}.pulsedata_b')-min(-PayloadRadData{i}.pulsedata_b');
       
       insideThresholdTime = d < likelyTailThreshold;
       isPeak = h(2:end) > likelyPeakThreshold*h(1:end-1);
       
       isPulseTail(2:length(PayloadRadData{i}.dcc_time)) = insideThresholdTime & ~isPeak';
       isPulseTail(1)=0;
   end
   PayloadRadData{i}.isTail=isPulseTail';
end
end

