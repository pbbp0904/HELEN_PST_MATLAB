function timeHistogram(pulsedata,dcc_time)
secondsStart = 0;
secondEnd = 10^10;
second = 0;

mmpulse = max(sum(-pulsedata));

tempPulseData = [];
out = [];
temp_time = 0;
j = 1;
for i = 2:length(dcc_time)
    if dcc_time(i)<dcc_time(i-1) || dcc_time(i) > 50000000/80 + temp_time
        secondsStart = i;
        j = 1;
        histogram(sum(-tempPulseData),100)
        title(second)
        xlim([0 mmpulse])
        ylim([0 200])
        drawnow
        pause
        
        second = second + 1;
        tempPulseData = [];
        temp_time = dcc_time(i);
    end
    tempPulseData(:,j) = pulsedata(:,i);
    j = j + 1;
end

end

