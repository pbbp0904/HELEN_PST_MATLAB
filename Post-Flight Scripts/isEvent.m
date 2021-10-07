function [PayloadRadData] = isEvent(PayloadRadData)
clockHz = 50000000;
halfWindow = 100;

for i = 1:length(PayloadRadData)
   isEvent=[];
   if ~isempty(PayloadRadData{i}.dcc_time)
       d = mod(diff(PayloadRadData{i}.dcc_time),clockHz);
       h = max(-PayloadRadData{i}.pulsedata_b');

       isEvent(2:length(PayloadRadData{i}.dcc_time))=(d<100000);
       isEvent(1:halfWindow)=0;
       isEvent(end-halfWindow-1:end)=0;
       eventIndicies=find(isEvent);
       for j=1:length(eventIndicies)
           if sum(d(eventIndicies(j)-halfWindow:eventIndicies(j)+halfWindow)<100000)~=halfWindow*2+1
               isEvent(eventIndicies(j))=0;
           end
       end
   end
   PayloadRadData{i}.isEvent=isEvent';
end
end