function [binaryTimeline] = makeFullTimeline(dcc_time,pulsedata,startI,endI)
currentSecond = 0;
totalSeconds = sum(dcc_time(2:end)<dcc_time(1:end-1));
indicies = [];
oneDData = [];
for i = startI:endI
    if dcc_time(i)<dcc_time(i-1)
        currentSecond = currentSecond + 1;
    end
    
    for j = -4:27
        indicies((i-startI)*32 + j + 4 + 1) = currentSecond*50000000 + dcc_time(i) + j;
        oneDData((i-startI)*32 + j + 4 + 1) = pulsedata(j + 4 + 1,i);
    end
end

binaryTimeline = sparse((totalSeconds+1)*50000000,1);
binaryTimeline(indicies) = -oneDData';
end

