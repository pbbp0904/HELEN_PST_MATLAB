function [eventCapturePercentage] = getEventCapturePercentage(PayloadRadData)

eventCapturePercentage = zeros(1,length(PayloadRadData));

for i = 1:length(PayloadRadData)
    pulse_num = PayloadRadData{i}.pulse_num;
    eventCapturePercentage(i) = 100*(sum(diff(pulse_num)==1) - sum(diff(pulse_num)~=1)) / (sum(diff(pulse_num)==1) + sum(diff(pulse_num)~=1));
end

end

