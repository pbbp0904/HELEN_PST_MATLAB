function [PayloadRadData] = isTailEvent(PayloadRadData)
clockHz=50000000;
for i = 1:length(PayloadRadData)
   isTail=[];
   isEvent=[];
   if ~isempty(PayloadRadData{i}.dcc_time)
       d = mod(diff(PayloadRadData{i}.dcc_time),clockHz);
       h = max(-PayloadRadData{i}.pulsedata_b');
       isTail(2:length(PayloadRadData{i}.dcc_time))=(d<500);
       isTail(1)=0;
       isEvent(2:length(PayloadRadData{i}.dcc_time))=(d<100000);
       halfWindow=100;
       isEvent(1:halfWindow)=0;
       isEvent(end-halfWindow-1:end)=0;
       eventIndicies=find(isEvent);
       for j=1:length(eventIndicies)
           if sum(d(eventIndicies(j)-halfWindow:eventIndicies(j)+halfWindow)<100000)~=halfWindow*2+1
               isEvent(eventIndicies(j))=0;
           end
       end
   end
   PayloadRadData{i}.isTail=isTail';
   PayloadRadData{i}.isEvent=isEvent';
end
end

