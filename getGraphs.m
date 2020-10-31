function [Graphs] = getGraphs(PayloadEnvData, PayloadRadData, PayloadPrefixes, PayloadColors, Stats)

Graphs = [];

disp('Generating Graphs...')

set(groot, 'DefaultFigureVisible', 'off')

% Generate Induvidual Graphs
for payload = 1:length(PayloadEnvData)
    
    % Environmental Graphs
    
    envTime = PayloadEnvData{payload}.PacketNum/Stats.NUMBEROFPACKETS_PERSECOND{payload}/60/60;
    
    % GPS Plot (Induvidual)
    figure();
    plot(PayloadEnvData{payload}.gpsLongs, PayloadEnvData{payload}.gpsLats);
    title(sprintf('GPS Plot of %s', PayloadPrefixes{payload}));
    xlabel('Longitude (degrees)');
    ylabel('Latitude (degrees)');
    axis square
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.GPS_PLOT{payload} = gcf;
    
    % Internal Temperatures vs. Time
    figure();
    plot(envTime, PayloadEnvData{payload}.IMUTemp/100);
    title(sprintf('Internal Temperatures vs. Time of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('Temperature (C)');
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.TEMP_INTERNAL{payload} = gcf;
    
    % External Temperature vs. Time
    
    
    % Total Acceleration vs. Time
    figure();
    plot(envTime, sqrt((PayloadEnvData{payload}.AccX/100/9.81).^2+(PayloadEnvData{payload}.AccY/100/9.81).^2+(PayloadEnvData{payload}.AccZ/100/9.81).^2));
    title(sprintf('Total Acceleration vs. Time of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('|Acceleration| (g)');
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.ACCELERATION_TOTAL{payload} = gcf;
    
    % Vertical Acceleration vs. Time
    figure();
    plot(envTime, PayloadEnvData{payload}.AccZ/100/9.81);
    title(sprintf('Vertical Acceleration vs. Time of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('Acceleration (g)');
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.ACCELERATION_VERTICAL{payload} = gcf;
    
    % Horizontal Acceleration vs. Time
    figure();
    plot(envTime, sqrt((PayloadEnvData{payload}.AccX/100/9.81).^2+(PayloadEnvData{payload}.AccY/100/9.81).^2));
    title(sprintf('Horizontal Acceleration vs. Time of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('|Acceleration| (g)');
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.ACCELERATION_HORIZONTAL{payload} = gcf;
    
    % GPS Altitude vs. Time
    
end
    
for payload = 1:length(PayloadRadData)
    % Radiation Graphs
    
    radTime = (1:Stats.TIME_FPGACOUNTER_RESETS{payload})/60/60;
    
    t = PayloadRadData{payload}.time_data;
    bp = PayloadRadData{payload}.b_peak_data;
    countsPerSecond = [];
    countsPerSecond1500 = [];
    startTimes = [];
    countNumber = 0;
    countNumber1500 = 0;
    s = 1;
    for j = 2:length(t)
        if t(j)-t(j-1) >= 0
            countNumber = countNumber + 1;
            if bp(j) > 1500
                countNumber1500 = countNumber1500 + 1;
            end
        else
            countsPerSecond(s) = countNumber;
            countsPerSecond1500(s) = countNumber1500;
            startTimes(s) = t(j);
            s = s + 1;
            countNumber = 0;
            countNumber1500 = 0;
        end
    end
    
    
    % A-Channel Spectrum
    figure();
    histogram(PayloadRadData{payload}.a_peak_data);
    title(sprintf('A Channel Histogram of %s', PayloadPrefixes{payload}));
    xlabel('Channels');
    ylabel('Counts');
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.SPECTRUM_CHANNEL_A{payload} = gcf;
    
    % B-Channel Spectrum
    figure();
    histogram(PayloadRadData{payload}.b_peak_data);
    title(sprintf('B Channel Histogram of %s', PayloadPrefixes{payload}));
    xlabel('Channels');
    ylabel('Counts');
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.SPECTRUM_CHANNEL_B{payload} = gcf;
    
    % B-Channel Spectrum greater than 1500
    figure();
    histogram(PayloadRadData{payload}.b_peak_data);
    title(sprintf('B Channel Histogram > 1500 of %s', PayloadPrefixes{payload}));
    xlabel('Channels');
    ylabel('Counts');
    xlim([1500, max(PayloadRadData{payload}.b_peak_data)])
    ylim auto
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.SPECTRUM_CHANNEL_B_1500{payload} = gcf;
    
    % Counts per second vs. Time
    figure();
    plot(radTime, countsPerSecond);
    title(sprintf('Counts/Second vs. Time of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('Counts/Second (#/s)');
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.COUNTSPERSECOND{payload} = gcf;
    
    % Counts per second greater than 1500 vs. Time
    figure();
    plot(radTime, countsPerSecond1500);
    title(sprintf('Counts/Second > 1500 vs. Time of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('Counts/Second (#/s)');
    set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
    Graphs.COUNTSPERSECOND_1500{payload} = gcf;
    
    % Deadtime vs. Time
    
    
    fprintf('Done with %s\n', PayloadPrefixes{payload});
end


%try
% Generating Combined Graphs
% GPS Plot (Combined)
figure();
hold on
for payload = 1:length(PayloadEnvData)
    plot(PayloadEnvData{payload}.gpsLongs, PayloadEnvData{payload}.gpsLats, 'Color', PayloadColors{payload});
end
hold off
title('Combined GPS Plot');
xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');
axis square
set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
Graphs.GPS_PLOT_COMBINED = gcf;

% Time Window Multipayload Plot
minTimeOn = 10000000;
maxTimeOff = 0;
for payload = 1:length(PayloadEnvData)
    if Stats.TIME_ON_SERIAL{payload} < minTimeOn
        minTimeOn = Stats.TIME_ON_SERIAL{payload};
    end
    if Stats.TIME_OFF_SERIAL{payload} > maxTimeOff
        maxTimeOff = Stats.TIME_OFF_SERIAL{payload};
    end
end


dnv = floor(minTimeOn*24)/24:1/24:ceil(maxTimeOff*24)/24;       % X-Axis Dates
figure();
hold on
for payload = 1:length(PayloadEnvData)
    plot([Stats.TIME_ON_SERIAL{payload} Stats.TIME_OFF_SERIAL{payload}], (length(PayloadEnvData)-payload+1)*[1 1], 'LineWidth', 10, 'Color', PayloadColors{payload});
end
hold off
grid
set(gca, 'XTick', dnv);
datetick('x', 'hh', 'keepticks');
axis([xlim    0  length(PayloadEnvData)+1]);
ytlblstr = sprintf('Payload %d\n', length(PayloadEnvData):-1:1);
ytlbls = regexp(ytlblstr, '\n', 'split');
set(gca, 'YTick',1:length(ytlbls), 'YTickLabel',ytlbls);
title('Payload Operation Windows');
xlabel('UTC Time (hours)');
set(gcf, 'CloseRequestFcn', "set(gcf,'visible','off')")
Graphs.OPERATION_WINDOWS = gcf;

set(groot, 'DefaultFigureVisible', 'on')

fprintf('Done with Combined\n');
%catch
    %fprintf('Failed to make combined graphs\n');
%end

end



