function [PayloadRadData] = findSubseconds(PayloadRadData)
%findSubseconds Summary of this function goes here
%   Detailed explanation goes here

clockHz = 50000000;

for i = 1:length(PayloadRadData)
    PayloadRadData{i}.subSecond = mod(PayloadRadData{i}.dcc_time - PayloadRadData{i}.pps_time,clockHz)./clockHz;
end

end
