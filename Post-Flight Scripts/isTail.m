function [isPulseTail] = isTail(dcc_time, pulsedata_b)
clockHz = 50000000;
likelyTailThreshold = 650; % Estimated
likelyPeakThreshold = 2;

isPulseTail=[];
if ~isempty(dcc_time)
   d = mod(diff(dcc_time),clockHz);
   h = max(-pulsedata_b')-min(-pulsedata_b');

   insideThresholdTime = d < likelyTailThreshold;
   isPeak = h(2:end) > likelyPeakThreshold*h(1:end-1);

   isPulseTail(2:length(dcc_time)) = insideThresholdTime & ~isPeak';
   isPulseTail(1)=0;
end
isPulseTail = isPulseTail';
end

