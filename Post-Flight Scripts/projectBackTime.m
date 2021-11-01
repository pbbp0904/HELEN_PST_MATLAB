function [PayloadEnvData] = projectBackTime(PayloadEnvData)


for i = 1:length(PayloadEnvData)
    if ~isempty(PayloadEnvData{i})
        a = find(abs(diff(PayloadEnvData{i}.gpsTimes*24*3600)-1) < 10^(-3));
        timeStart = a(1);
        timeAtStart = PayloadEnvData{i}.gpsTimes(timeStart);

        for j = 1:timeStart-1
            PayloadEnvData{i}.gpsTimes(timeStart-j) = timeAtStart - j/(24*3600);
        end
    end
end
end

