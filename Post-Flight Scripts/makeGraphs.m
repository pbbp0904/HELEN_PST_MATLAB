function makeGraphs(FlightData, PayloadEnvData, PayloadRadData, PayloadPrefixes, PayloadColors, Stats, imagePath)
%% Setup

disp('Generating Graphs...')
set(groot, 'DefaultFigureVisible', 'off')




%% Environmental Graphs
% Generate Induvidual Graphs

for payload = 1:length(PayloadEnvData)
    envTime{payload} = PayloadEnvData{payload}.PacketNum/Stats.NUMBEROFPACKETS_PERSECOND(payload)/60/60;
end

% GPS Plot (Induvidual)
figure();
sgtitle("GPS Plots")
for payload = 1:length(PayloadEnvData)
    subplot(2,2,payload);
    plot(PayloadEnvData{payload}.gpsLongs, PayloadEnvData{payload}.gpsLats);
    title(sprintf('GPS Plot of %s', PayloadPrefixes{payload}));
    xlabel('Longitude (degrees)');
    ylabel('Latitude (degrees)');
    axis equal
end
saveas(gcf, imagePath + "LATLONG" + ".png");


% Internal Temperatures vs. Time
figure();
sgtitle("Internal Temperatures")
for payload = 1:length(PayloadEnvData)
    subplot(2,2,payload);
    plot(envTime{payload}, PayloadEnvData{payload}.IMUTemp);
    title(sprintf('Internal Temperatures of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('Temperature (C)');
end
saveas(gcf, imagePath + "TEMP_INTERNAL" + ".png");


% External Temperature vs. Time
figure();
sgtitle("External Temperatures")
for payload = 1:length(PayloadEnvData)
    subplot(2,2,payload);
    plot(envTime{payload}, PayloadEnvData{payload}.EXTTemp);
    title(sprintf('External Temperatures of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('Temperature (C)');
end
saveas(gcf, imagePath + "TEMP_EXTERNAL" + ".png");


% Total Acceleration vs. Time
figure();
sgtitle("Total Acceleration")
for payload = 1:length(PayloadEnvData)
    subplot(2,2,payload);
    plot(envTime{payload}, sqrt((PayloadEnvData{payload}.AccX/9.81).^2+(PayloadEnvData{payload}.AccY/9.81).^2+(PayloadEnvData{payload}.AccZ/9.81).^2));
    title(sprintf('Total Acceleration of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('|Acceleration| (g)');
end
saveas(gcf, imagePath + "ACCELERATION_TOTAL" + ".png");


% Vertical Acceleration vs. Time
figure();
sgtitle("Vertical Acceleration")
for payload = 1:length(PayloadEnvData)
    subplot(2,2,payload);
    plot(envTime{payload}, PayloadEnvData{payload}.AccZ/9.81);
    title(sprintf('Vertical Acceleration of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('Acceleration (g)');
end
saveas(gcf, imagePath + "ACCELERATION_VERTICAL" + ".png");


% Horizontal Acceleration vs. Time
figure();
sgtitle("Horizontal Acceleration")
for payload = 1:length(PayloadEnvData)
    subplot(2,2,payload);
    plot(envTime{payload}, sqrt((PayloadEnvData{payload}.AccX/9.81).^2+(PayloadEnvData{payload}.AccY/9.81).^2));
    title(sprintf('Horizontal Acceleration of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('|Acceleration| (g)');
end
saveas(gcf, imagePath + "ACCELERATION_HORIZONTAL" + ".png");


% GPS Altitude vs. Time
figure();
sgtitle("GPS Altitude")
for payload = 1:length(PayloadEnvData)
    subplot(2,2,payload);
    plot(envTime{payload}, PayloadEnvData{payload}.gpsAlts./1000)
    title(sprintf('GPS Altitude of %s', PayloadPrefixes{payload}));
    xlabel('Time (hours)');
    ylabel('Altitude (km)');
end
saveas(gcf, imagePath + "GPS_ALTITUDE" + ".png");




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
axis equal
saveas(gcf, imagePath + "GPS_PLOT_COMBINED" + ".png");


% Time Window Multipayload Plot
minTimeOn = 10000000;
maxTimeOff = 0;
for payload = 1:length(PayloadEnvData)
    if Stats.TIME_ON_SERIAL(payload) < minTimeOn
        minTimeOn = Stats.TIME_ON_SERIAL(payload);
    end
    if Stats.TIME_OFF_SERIAL(payload) > maxTimeOff
        maxTimeOff = Stats.TIME_OFF_SERIAL(payload);
    end
end
dnv = floor(minTimeOn*24)/24:1/24:ceil(maxTimeOff*24)/24; % X-Axis Dates
figure();
hold on
for payload = 1:length(PayloadEnvData)
    try
        plot([Stats.TIME_ON_SERIAL(payload) Stats.TIME_OFF_SERIAL(payload)], (length(PayloadEnvData)-payload+1)*[1 1], 'LineWidth', 10, 'Color', PayloadColors{payload});
    catch
    end
end
try
    hold off
    grid
    set(gca, 'XTick', dnv);
    datetick('x', 'hh', 'keepticks');
    axis([xlim    0  length(PayloadEnvData)+1]);
    ytlblstr = sprintf('Payload %d\n', length(PayloadEnvData):-1:1);
    ytlbls = regexp(ytlblstr, '\n', 'split');
    set(gca, 'YTick',1:length(ytlbls), 'YTickLabel',ytlbls);
catch
end
title('Payload Operation Windows');
xlabel('UTC Time (hours)');
saveas(gcf, imagePath + "OPERATION_WINDOWS" + ".png");

fprintf('Done with environmental plots.\n');
    

%% Radiation Plots

% Channel A
for payload = 1:length(PayloadRadData)
    figure();
    F = FlightData(FlightData.PayloadNumber==payload,:);
    b = F.EPeakA;
    b = b(boolean(~F.isTail),:);
    %b = b(b<7000,:);
    b = b(1:end,:);
    
    
    d = F.time;
    d = d(boolean(~F.isTail),:);
    %d = d(b<7000,:);
    d = d(1:end,:);
    b = b(d~=0,:);
    d = d(d~=0,:);
    
    try
        h=hist3([b,d],[round((max(b)-min(b))/5),round((max(d)-min(d)))],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
        imagesc(0:max(d),min(b):max(b),h,'AlphaData',h)
        colormap('jet')
        set(gca, 'ColorScale', 'log')
        set(gca,'YDir','normal')
    
        caxis([1, max(max(h))])
    catch
    end
    h = colorbar;
    view(2)

    title(sprintf('Channel A Energy Waterfall for Payload %i',payload))
    xlabel('Time (s)')
    ylabel('Energy (bin)')
    ylabel(h, 'Counts/bin') % Colorbar label

    saveas(gcf, imagePath + "ENERGY_TIME_WATERFALL_A_" + num2str(payload) + ".png");
end


% Channel B
for payload = 1:length(PayloadRadData)
    figure();
    F = FlightData(FlightData.PayloadNumber==payload,:);
    b = F.EPeakB;
    b = b(boolean(~F.isTail),:);
    %b = b(b<3000,:);
    b = b(1:end,:);
    
    
    d = F.time;
    d = d(boolean(~F.isTail),:);
    %d = d(b<3000,:);
    d = d(1:end,:);
    b = b(d~=0,:);
    d = d(d~=0,:);
    
    try
        h=hist3([b,d],[round((max(b)-min(b))/5),round((max(d)-min(d)))],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
        imagesc(0:max(d),min(b):max(b),h,'AlphaData',h)
        colormap('jet')
        set(gca, 'ColorScale', 'log')
        set(gca,'YDir','normal')

        caxis([1, max(max(h))])
    catch
    end
    h = colorbar;
    view(2)

    title(sprintf('Channel B Energy Waterfall for Payload %i',payload))
    xlabel('Time (s)')
    ylabel('Energy (bin)')
    ylabel(h, 'Counts/bin') % Colorbar label

    saveas(gcf, imagePath + "ENERGY_TIME_WATERFALL_B_" + num2str(payload) + ".png");
end









% 
% for payload = 1:length(PayloadRadData)
%     % Radiation Graphs
%     
%     if length(PayloadRadData{payload}.dcc_time)>1
%     
%         radTime = (1:Stats.TIME_FPGACOUNTER_RESETS(payload))/60/60;
%         
%         t = PayloadRadData{payload}.dcc_time;
%         bp = max(-PayloadRadData{payload}.pulsedata_b,[],2);
%         countsPerSecond = [];
%         countsPerSecond1500 = [];
%         startTimes = [];
%         countNumber = 0;
%         countNumber1500 = 0;
%         s = 1;
%         for j = 2:length(t)
%             if t(j)-t(j-1) >= 0
%                 countNumber = countNumber + 1;
%                 if bp(j) > 1500
%                     countNumber1500 = countNumber1500 + 1;
%                 end
%             else
%                 countsPerSecond(s) = countNumber;
%                 countsPerSecond1500(s) = countNumber1500;
%                 startTimes(s) = t(j);
%                 s = s + 1;
%                 countNumber = 0;
%                 countNumber1500 = 0;
%             end
%         end
%         
%         
%         % A-Channel Spectrum
%         figure();
%         histogram(max(-PayloadRadData{payload}.pulsedata_a,[],2));
%         title(sprintf('A Channel Histogram of %s', PayloadPrefixes{payload}));
%         xlabel('Channels');
%         ylabel('Counts');
%         saveas(gcf, imagePath + num2str(payload) + "_SPECTRUM_CHANNEL_A" + ".png");
%         
%         % B-Channel Spectrum
%         figure();
%         histogram(max(-PayloadRadData{payload}.pulsedata_b,[],2));
%         title(sprintf('B Channel Histogram of %s', PayloadPrefixes{payload}));
%         xlabel('Channels');
%         ylabel('Counts');
%         saveas(gcf, imagePath + num2str(payload) + "_SPECTRUM_CHANNEL_B" + ".png");
%         
%         % B-Channel Spectrum greater than 1500
%         figure();
%         histogram(max(-PayloadRadData{payload}.pulsedata_b,[],2));
%         title(sprintf('B Channel Histogram > 1500 of %s', PayloadPrefixes{payload}));
%         xlabel('Channels');
%         ylabel('Counts');
%         xlim([1500, max(-PayloadRadData{payload}.pulsedata_b,[],'all')])
%         ylim auto
%         saveas(gcf, imagePath + num2str(payload) + "_SPECTRUM_CHANNEL_B_1500" + ".png");
%         
%         % Counts per second vs. Time
%         figure();
%         plot(radTime, countsPerSecond);
%         title(sprintf('Counts/Second vs. Time of %s', PayloadPrefixes{payload}));
%         xlabel('Time (hours)');
%         ylabel('Counts/Second (#/s)');
%         saveas(gcf, imagePath + num2str(payload) + "_COUNTSPERSECOND" + ".png");
%         
%         % Counts per second greater than 1500 vs. Time
%         figure();
%         plot(radTime, countsPerSecond1500);
%         title(sprintf('Counts/Second > 1500 vs. Time of %s', PayloadPrefixes{payload}));
%         xlabel('Time (hours)');
%         ylabel('Counts/Second (#/s)');
%         saveas(gcf, imagePath + num2str(payload) + "_COUNTSPERSECOND_1500" + ".png");
%     else
%         fprintf('Not Enough Data For %s\n', PayloadPrefixes{payload});
% 
%     end
%     % Deadtime vs. Time
%     
%     
%     fprintf('Done with %s\n', PayloadPrefixes{payload});
% end







% Closeout
fprintf('Done with making graphs!\n');
close all
delete(findall(groot, 'Type', 'figure', 'FileName', []));
set(groot, 'DefaultFigureVisible', 'on')

end



