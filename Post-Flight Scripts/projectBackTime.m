function [gpsTimes] = projectBackTime(gpsTimes)

% Check emptiness
if length(gpsTimes) > 1
    % Find all of the locations where gpsTime changes by one second
    a = find(abs(diff(gpsTimes*24*3600)-1) < 10^(-3));
    timeStart = a(1);
    % Set the timeAtStart equal to the first instance when this happens
    timeAtStart = gpsTimes(timeStart);
    % Project back the time to the start of the data
    for j = 1:timeStart-1
        gpsTimes(timeStart-j) = timeAtStart - j/(24*3600);
    end
end

end

