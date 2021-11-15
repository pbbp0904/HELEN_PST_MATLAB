function [pps_timeCorrected, subSecond] = findSubSeconds(pps_time, dcc_time)
%findSubseconds Summary of this function goes here
%   Detailed explanation goes here

clockHz = 50000000;

if length(pps_time)>1 && length(dcc_time)>1
    % Make new corrected pps_time
    pps_timeCorrected = pps_time;

    % Find clock drifts
    dpps = diff(pps_time);
    clockChangeMedian = median(dpps(dpps~=0));
    clockChangeIndicies = find(abs(dpps-clockChangeMedian)<1000&dpps~=0);

    if(length(clockChangeIndicies) > 10 )

        % Find clock drift at start
        slopeFound = 0;
        j = 1;
        while(~slopeFound)
            runningArray = dpps(clockChangeIndicies(j:j+5));
            if max(runningArray)-min(runningArray) < 5
                startingDrift = mean(runningArray);
                GPSLockIndex = clockChangeIndicies(j)+1;
                slopeFound = 1;
            else
                j = j + 1;
            end
        end



        % Project initial clock drift back to start
        s = 1;
        startSubSecTime = clockHz - pps_time(GPSLockIndex);
        for j = fliplr(1:GPSLockIndex-1)
            if dcc_time(j) > dcc_time(j+1)
                s = s + 1;
            end
            pps_timeCorrected(j) = round(pps_time(GPSLockIndex) - (s*clockHz - dcc_time(j) - startSubSecTime)*startingDrift/clockHz);
        end


        % Interpolate times inbetween pps pulses
        k = 1;
        while k < length(clockChangeIndicies)

            interpStartIndex = clockChangeIndicies(k)+1;
            interpEndIndex = clockChangeIndicies(k)+1;

            % Find next valid pps pulse time (interpEndIndex)
            m = k + 1;
            ppsChangeValid = 0;
            while(~ppsChangeValid && m<=length(clockChangeIndicies))
                if abs(dpps(clockChangeIndicies(m)) - dpps(clockChangeIndicies(k))) < round(5+(m-k)/5)

                    interpEndIndex = clockChangeIndicies(m)+1;
                    ppsChangeValid = 1;
                else
                    m = m + 1;
                end
            end
            k = m;

            % Find number of clock cycles and total drift between start and end indicies
            sTot = sum(diff(dcc_time(interpStartIndex:interpEndIndex-1))<-100000);
            numOfClockCycles = (sTot-1)*clockHz + pps_time(interpEndIndex) + (clockHz-pps_time(interpStartIndex));
            driftInClockCycles = (pps_time(interpStartIndex)-pps_time(interpEndIndex))/numOfClockCycles;

            % Interpolate between indicies
            s = 0;
            for j = interpStartIndex:interpEndIndex-1
                if dcc_time(j) - dcc_time(j-1) < -100000
                    s = s + 1;
                end
                pps_timeCorrected(j) = round(pps_time(interpStartIndex) - (s*clockHz + dcc_time(j) - pps_time(interpStartIndex))*driftInClockCycles);
            end
        end


        % Project last second of data using last driftInClockCycles
        interpStartIndex = clockChangeIndicies(end)+1;
        interpEndIndex = length(pps_timeCorrected)+1;
        % Interpolate between indicies
        s = 0;
        for j = interpStartIndex:interpEndIndex-1
            if dcc_time(j) - dcc_time(j-1) < -100000
                s = s + 1;
            end
            pps_timeCorrected(j) = round(pps_time(interpStartIndex) - (s*clockHz + dcc_time(j) - pps_time(interpStartIndex))*driftInClockCycles);
        end
    end

    subSecond = mod(dcc_time - pps_timeCorrected,clockHz)./clockHz;
else
    pps_timeCorrected = missing;
    subSecond = missing;
end


end
