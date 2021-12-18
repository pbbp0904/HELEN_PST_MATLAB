stopNumber = 10;
simNumber = 100000;


clear detection
for actualChancePerFlight = 0:0.01:1
    for sim = 1:simNumber
        detection(sim,round(actualChancePerFlight*100+1)) = 0;
        for obs = 1:stopNumber
           if rand() <= actualChancePerFlight
               detection(sim,round(actualChancePerFlight*100+1)) = obs;
               break;
           end
        end
    end
end

clear p
for i = 1:101
   p(:,i) = histcounts(detection(:,i),0:stopNumber+1)./simNumber;
end
plot(p',0:0.01:1)
y = 0:stopNumber;
legend(arrayfun(@(mode) sprintf('%d', mode), 0:size(y, 2)-1, 'UniformOutput', false))