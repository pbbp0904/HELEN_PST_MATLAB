function [firstPulseEvent,firstPulseSecond_FPGA,firstPulseSecond_ENV] = getTimingStart(PayloadRadData,PayloadEnvData)

clockHz = 50000000;

for i = 1:length(PayloadRadData)
    try
    pps_time = PayloadRadData{i}.pps_time;
    dcc_time = PayloadRadData{i}.dcc_time;
    gps_time = PayloadEnvData{i}.gpsTimes;
    
    % Finding the first event with a subsecond time
    firstPulseEvent(i) = length(pps_time);
    for j = 1:length(pps_time)
        if pps_time(j) == 0 && pps_time(j+1) ~= 0
            firstPulseEvent(i) = j+1;
            break;
        end
    end

    % Finding the number of FPGA seconds that have passed
    firstPulseSecond_FPGA(i) = 0;
    for j = 1:firstPulseEvent(i)-1
        if dcc_time(j) > dcc_time(j+1)
            firstPulseSecond_FPGA(i) = firstPulseSecond_FPGA(i) + 1;
        end
    end

    % Finding the number of ENV seconds that have passed
    for j = 1:length(gps_time)
        if ~isnan(gps_time(j))
            firstPulseSecond_ENV(i) = j;
            break;
        end
    end
    catch
    end

end

end

