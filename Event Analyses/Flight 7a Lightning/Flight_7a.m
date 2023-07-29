%%
% parseRawData()

%% Load Data
% HELEN
load('E:\Flight Data\Flight 7a\3-Processed Data\PayloadEnvData.mat')
load('E:\Flight Data\Flight 7a\3-Processed Data\PayloadRadData.mat')
load('E:\Flight Data\Flight 7a\3-Processed Data\PayloadCamData.mat')
load('E:\Flight Data\Flight 7a\3-Processed Data\LMA\LMAData.mat');

%LMA
load('E:\Flight Data\Flight 7a\3-Processed Data\LMA\LMAData.mat')

% GLM
load('E:\Flight Data\Flight 7a\3-Processed Data\GLM\GLMData.mat');

%% Plot Environmental Data
% Plotting environmental data
% for i = 1:width(PayloadEnvData{1})
%     figure()
%     t = tiledlayout(1,1);
%     t.Padding = 'compact';
%     t.TileSpacing = 'compact';
%     payload = 4;
%     nexttile
%     plot(table2array(PayloadEnvData{payload}(:,i)))
%     title(sprintf("Payload %i: %s",payload, PayloadEnvData{payload}.Properties.VariableNames{i}))
% end

%% Plotting radiation data
% for i = [8,9,14,15]
% figure()
% t = tiledlayout(1,1);
% t.Padding = 'compact';
% t.TileSpacing = 'compact';
% for payload = 4
% nexttile
% plot(table2array(PayloadRadData{payload}(:,i)))
% title(sprintf("Payload %i: %s",payload, PayloadRadData{payload}.Properties.VariableNames{i}))
% end
% end

%% Whole flight
figure('Color','white')
dt = 0.001;
lc = histcounts(PayloadRadData{4}.timeInterp,"NumBins",(dt)^(-1)*ceil(PayloadRadData{4}.timeInterp(end)),"BinLimits",[0 ceil(PayloadRadData{4}.timeInterp(end))]);
plot(0:dt:(length(lc)*dt)-dt,smooth(lc,1),'k')
hold on
%plot(PayloadEnvData{4}.PacketNum,PayloadEnvData{4}.gpsAlts*20)
%plot(PayloadEnvData{4}.PacketNum,(smooth(sqrt(PayloadEnvData{4}.AccX.^2+PayloadEnvData{4}.AccY.^2+PayloadEnvData{4}.AccZ.^2),1)-10)*10^4)


%% Whole flight correlation with lightning
origin = [34.6816045 -88.351260167 11913];
lat_bounds = [34.5 34.72];
long_bounds = [-88.63 -88.15];

% GLM
GLM_Data_Filtered = GLM_Data(GLM_Data.GLM_event_lat > lat_bounds(1) & GLM_Data.GLM_event_lat < lat_bounds(2) & GLM_Data.GLM_event_long > long_bounds(1) & GLM_Data.GLM_event_long < long_bounds(2),:);

% LMA
LMA_Data_Filtered = LMA_Data(LMA_Data.Latitude > lat_bounds(1) & LMA_Data.Latitude < lat_bounds(2) & LMA_Data.Longitude > long_bounds(1) & LMA_Data.Longitude < long_bounds(2),:);

[xEast,yNorth,zUp] = latlon2local(LMA_Data_Filtered.Latitude,LMA_Data_Filtered.Longitude,LMA_Data_Filtered.Altitude,origin);
LMA_Data_Filtered.Distance = 1./sqrt((xEast.^2+yNorth.^2+zUp.^2));

% HELEN Light Curve
figure('Color','white')
plot(18428-2397:dt:18428-2397+(length(lc)*dt)-dt,lc,'k')
ylabel('Counts per Millisecond')

yyaxis right
hold on
scatter(LMA_Data_Filtered.Time,LMA_Data_Filtered.Power.*LMA_Data_Filtered.Distance*100000,'b','LineWidth',1)
scatter(GLM_Data_Filtered.GLM_event_time,GLM_Data_Filtered.GLM_event_energy*3*10^15,'r','LineWidth',1)
xlabel('Time (UTC Second of Day)')
ylabel('LMA Lightning Power (dBW)')
ylim([0 10^3])
xlim([16000 19600])

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'b';

camOffset = 98.34+18428-2397;
camTime = camOffset:1/30:(length(PayloadCamData{4}.meanGrayLevels)/30-1/30+camOffset);
for i = 1:length(camTime)
    camTime(i) = camTime(i) + 0.413*floor(i/9000);
end

plot(camTime, PayloadCamData{4}.meanGrayLevels,'Color',[0 1 0],'LineStyle','-','LineWidth',1)

ax = gca;
ax.XAxis.Exponent=0;

%% First lightning strike
figure('Color','white')
dt = 0.0001;
lc = histcounts(PayloadRadData{4}.timeInterp,"NumBins",round((dt)^(-1)*2),"BinLimits",[782 784]);
plot(0:dt:(length(lc)*dt)-dt,lc,'k')

%% THE lightning strike
figure('Color','white')
dt = 0.0000001;
lc = histcounts(PayloadRadData{4}.timeInterp,"NumBins",round((dt)^(-1)*2),"BinLimits",[2396 2398]);
plot(0:dt:(length(lc)*dt)-dt,smooth(lc,100),'k')

%% THE lightning strike
figure('Color','white') % Sets the background color to white

% Define time vector
start_utc_time = datetime(2023,6,19,5,7,7, 'TimeZone', 'UTC');
end_utc_time = datetime(2023,6,19,5,7,9, 'TimeZone', 'UTC');
duration_sec = seconds(end_utc_time - start_utc_time); % calculate the duration in seconds

% Calculate the time vector in milliseconds from the start time
time_vector_sec = 0 : dt : duration_sec-dt; % subtract dt to avoid off-by-one error
time_vector_ms = time_vector_sec * 1000; % convert to milliseconds

% Create histogram
lc = histcounts(PayloadRadData{4}.timeInterp,"NumBins",(dt)^(-1)*2,"BinLimits",[2396 2398]);

% Create the plot
plot(time_vector_ms-1000, lc, 'k', 'LineWidth', 1.5) % Make the line thicker

% Set title and axis labels
title('Lightning Strike Radiation', 'FontSize', 16) % Larger font for the title
xlabel('Time (ms from June 19, 2023 05:07:08 UTC)', 'FontSize', 14) % Time on x-axis
ylabel('Radiation Counts per Millisecond', 'FontSize', 14) % Radiation count on y-axis

% Make the grid on
grid on

% Use a larger font size for the axes
ax = gca;
ax.FontSize = 12;

% Set axis limits
xlim([-600 600])


%% Pulse shape histogram of pulses
radData = PayloadRadData{4};
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1(radData1.timeInterp > 2396.5,:);
radData1 = radData1(radData1.timeInterp < 2397.5,:);

b = radData1.pulsedata_b;
b = b(1:end,:);
[~,I] = max(-b');
m = max(-b')-min(-b');
h=hist3([reshape(-b',[1,length(b)*32])',reshape(repmat((1:32)',length(b),1),[1,length(b)*32])'],[round((max(max(-b))-min(min(-b)))/1),32],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
imagesc(1:32,min(min(-b)):max(max(-b)),h,'AlphaData',h)
colormap('jet')
set(gca, 'ColorScale', 'log')
set(gca,'YDir','normal')
caxis([1, max(max(h))])
colorbar
view(2)


%% Pulses
radData = PayloadRadData{4};
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1(radData1.timeInterp > 2396,:);
radData1 = radData1(radData1.timeInterp < 2398,:);
radData1 = radData1(var(radData1.pulsedata_b(:,4:end),0,2) > 2000,:);
radData1 = radData1(max(-radData1.pulsedata_b(:,4:end),[],2) > 500,:);
radData1 = radData1(mean(-radData1.pulsedata_b(:,4:end),2) < 1200,:);
radData1 = radData1(max(abs(diff(radData1.pulsedata_b(:,4:end),1,2)),[],2) < 1000,:);
radData1 = radData1(~radData1.isTail,:);
figure()
hold on
for pulse = 1:height(radData1)
    pulseColor = pulse/height(radData1);
    if ~isnan(radData1.pulsedata_b(pulse,1))
        plot(-radData1.pulsedata_b(pulse,4:end),'Color',[1-pulseColor,0,pulseColor])
        ylim([0 3000])
        title(radData1.time(pulse))
        drawnow
        %pause
    end
end

%% Pulses
radData = PayloadRadData{4};
radData1 = radData(~isnan(radData.time),:);
startTime = 2396;
endTime = 2398;
radData1 = radData1(radData1.timeInterp > startTime,:);
radData1 = radData1(radData1.timeInterp < endTime,:);
radData1 = radData1(var(radData1.pulsedata_b(:,4:end),0,2) > 1000,:);
radData1 = radData1(max(-radData1.pulsedata_b(:,4:end),[],2) > 400,:);
radData1 = radData1(mean(-radData1.pulsedata_b(:,4:end),2) > 100,:);
radData1 = radData1(mean(-radData1.pulsedata_b(:,4:end),2) < 1200,:);
radData1 = radData1(max(abs(diff(radData1.pulsedata_b(:,4:end),1,2)),[],2) < 1000,:);
radData1 = radData1(max(-radData1.pulsedata_b(:,4:9),[],2) > 1.2*max(abs(-radData1.pulsedata_b(:,20:end)),[],2),:);
radData1 = radData1(mean(-radData1.pulsedata_b(:,4:5),2) < 800,:);
radData1 = radData1(-radData1.pulsedata_b(:,4) < -radData1.pulsedata_b(:,5) & -radData1.pulsedata_b(:,5) < -radData1.pulsedata_b(:,6),:);
radData1 = radData1(~radData1.isTail,:);
figure('Color','white')
hold off
timeWindow = 0.01;

% Specify the filename for the gif
filename = 'pulse_animation_cleaned.gif';

for pulseTime = startTime:timeWindow:endTime
    pulseColor = (pulseTime-startTime)/(endTime-startTime);
    cla
    plot(-radData1.pulsedata_b(radData1.timeInterp >= pulseTime & radData1.timeInterp < pulseTime+timeWindow,4:end)','Color',[1-pulseColor,0,pulseColor])
    xlim([0 30])
    ylim([0 2500])
    title("05:07:0" + num2str(pulseTime-2396+7))
    drawnow

    % Capture the plot as an image 
    frame = getframe(gcf); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256);

    % Write to the GIF File 
    if pulseTime == startTime 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf, 'DelayTime', timeWindow); 
    else 
        imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', timeWindow); 
    end 
end


%% Waterfall

radData = PayloadRadData{4};
radData1 = radData(~isnan(radData.time),:);
startTime = 2396;
endTime = 2398;
radData1 = radData1(radData1.timeInterp > startTime,:);
radData1 = radData1(radData1.timeInterp < endTime,:);
% radData1 = radData1(var(radData1.pulsedata_b(:,4:end),0,2) > 1000,:);
% radData1 = radData1(max(-radData1.pulsedata_b(:,4:end),[],2) > 400,:);
% radData1 = radData1(mean(-radData1.pulsedata_b(:,4:end),2) > 100,:);
% radData1 = radData1(mean(-radData1.pulsedata_b(:,4:end),2) < 1200,:);
% radData1 = radData1(max(abs(diff(radData1.pulsedata_b(:,4:end),1,2)),[],2) < 1000,:);
% radData1 = radData1(max(-radData1.pulsedata_b(:,4:9),[],2) > 1.2*max(abs(-radData1.pulsedata_b(:,20:end)),[],2),:);
% radData1 = radData1(mean(-radData1.pulsedata_b(:,4:5),2) < 800,:);
% radData1 = radData1(-radData1.pulsedata_b(:,4) < -radData1.pulsedata_b(:,5) & -radData1.pulsedata_b(:,5) < -radData1.pulsedata_b(:,6),:);
% radData1 = radData1(~radData1.isTail,:);

payloadNumber = 4;
b = radData1.pulsedata_a;
m = max(-b,[],2);
d = radData1.timeInterp;

figure('Color','white')
h=hist3([m,d],[100,2/0.01],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
imagesc(min(d):max(d)+1,min(m):max(m),h,'AlphaData',h)
colormap('jet')
set(gca,'YDir','normal')
ylim([0 8192])
title('Unfiltered 10ms Bins')
colorbar
view(2)


%% K-Means
radData = PayloadRadData{4};
radData1 = radData(~isnan(radData.time),:);
startTime = 2396;
endTime = 2398;
radData1 = radData1(radData1.timeInterp > startTime,:);
radData1 = radData1(radData1.timeInterp < endTime,:);
% radData1 = radData1(~radData1.isTail,:);

% Convert the table to an array
pulse_data = radData1.pulsedata_b;
pulse_data = -pulse_data(:,4:end)-min(-pulse_data(:,4:end),[],2);
pulse_data = pulse_data./max(pulse_data,[],2);

% Perform K-means clustering
k = 25;  % number of clusters
rng(0, 'twister'); % Set the random seed
[clusters, centroids] = kmeans(pulse_data, k, "MaxIter", 1000, 'Replicates', 5);

% Initialize the arrays for the most representative time series, min and max values
representative_ts = zeros(k, size(pulse_data, 2));
min_values = zeros(k, size(pulse_data, 2));
max_values = zeros(k, size(pulse_data, 2));
population_sizes = zeros(k, 1);

for i = 1:k
    % Get the time series in the current cluster
    ts_in_cluster = pulse_data(clusters == i, :);
    
    % Calculate the Euclidean distance from each time series to the centroid
    distances = sqrt(sum((ts_in_cluster - centroids(i,:)).^2, 2));
    
    % Find the time series with the smallest distance to the centroid
    [~, idx] = min(distances);
    representative_ts(i, :) = ts_in_cluster(idx, :);
    
    % Find the min and max values for each point across all time series in the cluster
    min_values(i, :) = min(ts_in_cluster);
    max_values(i, :) = max(ts_in_cluster);
    mean_values(i, :) = mean(ts_in_cluster);
    std_values(i, :) = std(ts_in_cluster);
    
    % Count the number of data points in the cluster
    population_sizes(i) = sum(clusters == i);
end

% Sort by population size
[population_sizes, idx] = sort(population_sizes, 'descend');
representative_ts = representative_ts(idx, :);
min_values = min_values(idx, :);
max_values = max_values(idx, :);
mean_values = mean_values(idx, :);
std_values = std_values(idx, :);

% Create subplots for each cluster
figure('Color','white');
for i = 1:k
    nexttile
    plot(representative_ts(i, :), 'LineWidth', 2);
    hold on;
    fill([1:size(pulse_data, 2), size(pulse_data, 2):-1:1], ...
         [mean_values(i, :) - std_values(i, :), fliplr(mean_values(i, :) + std_values(i, :))], ...
         'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    hold off;
    title(['Cluster ' num2str(idx(i)) ', Population: ' num2str(population_sizes(i))]);
    xlabel('Feature');
    ylabel('Value');
end

%% Plotting light curve of clusters
% List of clusters to include in the light curve
include_clusters = [22, 12, 7, 6, 1, 3, 15, 17, 19, 25, 8, 18];  % clusters
%include_clusters = [22, 12, 7, 6, 1];  % more limited pulses
% include_clusters = 1:25;

% Create a logical index that is true for data points in the selected clusters
idx = ismember(clusters, include_clusters);

% Select only the data points in the selected clusters
selected_data = pulse_data(idx, :);
selected_times = radData1.timeInterp(idx);

% Now create a light curve with the selected data
figure('Color','white')
dt = 0.001;
lc = histcounts(selected_times,"NumBins",round((dt)^(-1)*2),"BinLimits",[startTime endTime]);
plot(0:dt:(length(lc)*dt)-dt,lc,'k')
title('Light curve of selected clusters')
xlabel('Time (s)')
ylabel('Count')

% Plotting the ratio
figure('Color','white')
dt = 0.001;
lc_energy = histcounts(radData1.timeInterp,"NumBins",round((dt)^(-1)*2),"BinLimits",[2396 2398]);

% Selected clusters
selected_clusters = include_clusters;  % replace with your selected clusters

% Get the pulses in the selected clusters
selected_pulses = ismember(clusters, selected_clusters);
lc_selected = histcounts(radData1.timeInterp(selected_pulses),"NumBins",round((dt)^(-1)*2),"BinLimits",[2396 2398]);

% Calculate the ratio
lc_ratio = lc_selected ./ (lc_energy + 1);

% Plot the ratio
plot(0:dt:(length(lc)*dt)-dt,lc_ratio,'k')
ylim([0 1])  % the ratio is between 0 and 1
xlabel('Time from 05:07:07 UTC (s)')
ylabel('Ratio of selected pulses to total pulses')
title('Pulse ratio in selected clusters')
grid on

% Apply the ratio to the lightcurve data
lc_total = histcounts(PayloadRadData{4}.timeInterp,"NumBins",round((dt)^(-1)*2),"BinLimits",[2396 2398]);
lc_actual = floor(lc_ratio.*lc_total);
plot(0:dt:(length(lc)*dt)-dt,lc_actual,'k')
xlabel('Time from 05:07:07 UTC (s)')
ylabel('Count')
title('Light Curve of Valid Pulses')
grid on


%% Correlation with Lightning
pm_seconds = 1;

LMA_Data_Filtered = LMA_Data(LMA_Data.Time > 18428-pm_seconds & LMA_Data.Time < 18428+pm_seconds,:);
LMA_Data_Filtered = LMA_Data_Filtered(LMA_Data_Filtered.Latitude > 34 & LMA_Data_Filtered.Latitude < 35,:);
LMA_Data_Filtered = LMA_Data_Filtered(LMA_Data_Filtered.Longitude > -89 & LMA_Data_Filtered.Longitude < -88,:);

figure('Color','white')

scatter3(PayloadEnvData{4}.gpsLongs(2397-pm_seconds:2397+pm_seconds),PayloadEnvData{4}.gpsLats(2397-pm_seconds:2397+pm_seconds),PayloadEnvData{4}.gpsAlts(2397-pm_seconds:2397+pm_seconds)./1000,'k','x','SizeData',300,'LineWidth',2)
hold on
colorTime = (LMA_Data_Filtered.Time-min(LMA_Data_Filtered.Time));
colorTime = colorTime./max(colorTime);
scatter3(LMA_Data_Filtered.Longitude,LMA_Data_Filtered.Latitude,LMA_Data_Filtered.Altitude./1000,'b','o','SizeData',5*(abs(LMA_Data_Filtered.Power)+0.0001),'LineWidth',2)

colormap(fliplr(jet))
patch(LMA_Data_Filtered.Longitude,LMA_Data_Filtered.Latitude,LMA_Data_Filtered.Altitude./1000,colorTime,'FaceColor','none','EdgeColor','interp','LineWidth',2)


xlim([-89 -88])
ylim([34 35])
zlim([0 20])

xlabel('Longitude')
ylabel('Latitude')
zlabel('Altitude (km)')
legend('Payload Location','LMA Lightning','Location','northeast')
set(gca,'FontSize',12)

% Light Curves
figure('Color','white')
plot(18428-1:dt:18428-1+(length(lc)*dt)-dt,lc_actual,'k')
ylabel('Counts per Millisecond')
hold on
yyaxis right
scatter(LMA_Data_Filtered.Time,LMA_Data_Filtered.Power,'b','LineWidth',2)
xlabel('Time (UTC Second of Day)')
ylabel('LMA Lightning Power (dBW)')

xlim([18428-pm_seconds 18428+pm_seconds])

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'b';

%% GLM Flashes
filename = 'E:\Flight Data\Flight 7a\3-Processed Data\GLM\GLMData.nc';
GLM_flash_time_first = ncread(filename,'flash_time_offset_of_first_event');
GLM_flash_time_last = ncread(filename,'flash_time_offset_of_last_event');
GLM_flash_lat = ncread(filename,'flash_lat');
GLM_flash_long = ncread(filename,'flash_lon');
GLM_flash_energy = ncread(filename, 'flash_energy');

GLM_flash_time_first = double(typecast(int16(round((GLM_flash_time_first+5)/0.00038148)),'uint16'))*0.00038148-5 + 18420; % Convert properly and add 'seconds since 2023-06-19 05:07:00.000' offset
GLM_flash_time_last = double(typecast(int16(round((GLM_flash_time_last+5)/0.00038148)),'uint16'))*0.00038148-5 + 18420; % Convert properly and add 'seconds since 2023-06-19 05:07:00.000' offset

figure('Color', 'white')
plot(18428-1:dt:18428-1+(length(lc)*dt)-dt,lc_actual,'k')
ylabel('Counts per Millisecond')
hold on
yyaxis right
histogram(GLM_flash_time_first(GLM_flash_lat > 34 & GLM_flash_lat < 35 & GLM_flash_long > -89 & GLM_flash_long < -88),1000,'FaceColor','b')
hold on
histogram(GLM_flash_time_last(GLM_flash_lat > 34 & GLM_flash_lat < 35 & GLM_flash_long > -89 & GLM_flash_long < -88),1000,'FaceColor','r')


xlim([18428-pm_seconds 18428+pm_seconds])

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'b';

GLM_flash_lat_filtered = GLM_flash_lat(GLM_flash_time_first > 18428-pm_seconds & GLM_flash_time_first < 18428+pm_seconds);
GLM_flash_long_filtered = GLM_flash_long(GLM_flash_time_first > 18428-pm_seconds & GLM_flash_time_first < 18428+pm_seconds);
GLM_flash_energy_filtered = GLM_flash_energy(GLM_flash_time_first > 18428-pm_seconds & GLM_flash_time_first < 18428+pm_seconds);
GLM_flash_energy_filtered2 = GLM_flash_energy(GLM_flash_lat > 34 & GLM_flash_lat < 35 & GLM_flash_long > -89 & GLM_flash_long < -88 & GLM_flash_time_first > 18428-1 & GLM_flash_time_first < 18428+1);

figure('Color', 'white')
scatter(GLM_flash_long_filtered,GLM_flash_lat_filtered)
ylim([34 35])
xlim([-89 -88])
hold on
scatter(-88.3519,34.6812,'x')

figure('Color','white')
histogram(GLM_flash_energy_filtered,100)
xline(GLM_flash_energy_filtered2)


%% GLM events
filename = 'E:\Flight Data\Flight 7a\3-Processed Data\GLM\GLMData.nc';
GLM_event_time = ncread(filename,'event_time_offset');
GLM_event_lat = ncread(filename,'event_lat');
GLM_event_long = ncread(filename,'event_lon');
GLM_event_energy = ncread(filename, 'event_energy');

GLM_event_time = double(typecast(int16(round((GLM_event_time+5)/0.00038148)),'uint16'))*0.00038148-5 + 18420; % Convert properly and add 'seconds since 2023-06-19 05:07:00.000' offset
GLM_event_lat = double(typecast(int16(round((GLM_event_lat+66.56)/0.0020313)),'uint16'))*0.0020313-66.56; % Convert properly
GLM_event_long = double(typecast(int16(round((GLM_event_long+141.56)/0.0020313)),'uint16'))*0.0020313-141.56; % Convert properly
GLM_event_energy = double(typecast(int16(round((GLM_event_energy-2.8515e-16)/(1.9024e-17))),'uint16'))*(1.9024e-17)+2.8515e-16; % Convert properly


figure('Color', 'white')
plot(18428-1:dt:18428-1+(length(lc)*dt)-dt,lc_actual,'k')
ylabel('Counts per Millisecond')
hold on
yyaxis right
scatter(GLM_event_time(GLM_event_lat > 34 & GLM_event_lat < 35 & GLM_event_long > -89 & GLM_event_long < -88),GLM_event_energy(GLM_event_lat > 34 & GLM_event_lat < 35 & GLM_event_long > -89 & GLM_event_long < -88))


xlim([18428-pm_seconds 18428+pm_seconds])

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'b';

GLM_event_lat_filtered = GLM_event_lat(GLM_event_time > 18428-pm_seconds & GLM_event_time < 18428+pm_seconds);
GLM_event_long_filtered = GLM_event_long(GLM_event_time > 18428-pm_seconds & GLM_event_time < 18428+pm_seconds);
GLM_event_energy_filtered = GLM_event_energy(GLM_event_time > 18428-pm_seconds & GLM_event_time < 18428+pm_seconds);
GLM_event_energy_filtered2 = GLM_event_energy(GLM_event_lat > 34 & GLM_event_lat < 35 & GLM_event_long > -89 & GLM_event_long < -88 & GLM_event_time > 18428-1 & GLM_event_time < 18428+1);

figure('Color', 'white')
scatter(GLM_event_long_filtered,GLM_event_lat_filtered)
ylim([34 35])
xlim([-89 -88])
hold on
scatter(-88.3519,34.6812,'x')

figure('Color','white')
histogram(GLM_event_energy_filtered,100)
xline(GLM_event_energy_filtered2)


%% Everything on One Plot
figure('Color', 'white')
plot(18428-1:dt:18428-1+(length(lc)*dt)-dt,lc_actual,'k')
%plot(18428-1:dt:18428-1+(length(lc)*dt)-dt,lc_total,'k')
ylabel('Counts per Millisecond')
hold on
yyaxis right
scatter(LMA_Data_Filtered.Time,LMA_Data_Filtered.Power,'b', 'LineWidth',2)
scatter(GLM_event_time(GLM_event_lat > 34 & GLM_event_lat < 35 & GLM_event_long > -89 & GLM_event_long < -88),2*10^14*GLM_event_energy(GLM_event_lat > 34 & GLM_event_lat < 35 & GLM_event_long > -89 & GLM_event_long < -88), 'r', 'LineWidth',2)
xlim([18428-pm_seconds 18428+pm_seconds])
xlabel('Time (UTC Second of Day)')
ylabel('Lightning Energy (arb.)')
legend('HELEN Radiation','LMA Events','GLM Events','Location','northeast')

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = [1 0 1];
ax.XAxis.Exponent = 0;
xtickformat('%.1f')


%% Waterfall/Spectrum
pulse_data_water = radData1.pulsedata_b;
pulse_data_water = pulse_data_water(idx,4:end);
b = pulse_data_water;
m_lightning = max(-b,[],2);
kev_c = 1400/700;
kev_off = 150;
m_lightning = abs(m_lightning*kev_c-kev_off); % convert to kev
d = selected_times;

figure('Color','white')
h=hist3([m_lightning,d],[100,2/0.01],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
imagesc(min(d):max(d)+1,min(m_lightning):max(m_lightning),h,'AlphaData',h)
colormap('jet')
set(gca,'YDir','normal')
ylim([0 6000])
title('10ms Bins')
colorbar
view(2)


kev_perbin = 8;
binNum = 8192/kev_perbin*kev_c;

figure('Color','white')
plotxlim = [0 2500];

subplot(2,2,2)
normal_spectrum = histcounts(m_lightning(selected_times < 2396.5 | selected_times > 2397.5),"NumBins",binNum,"BinLimits",[0 8192*kev_c]);
lightning_spectrum = histcounts(m_lightning(selected_times > 2396.5 & selected_times < 2397.5),"NumBins",binNum,"BinLimits",[0 8192*kev_c]);
%plot((0:binNum-1)*kev_c*8192/binNum,smooth(lightning_spectrum,1)/(8192/binNum),'k','LineWidth',1)
scatter((0:binNum-1)*kev_c*8192/binNum,smooth(lightning_spectrum,1)/(8192/binNum),'k','+','LineWidth',0.75,'SizeData',20)
xlim(plotxlim)
%set(gca,'Xscale','log')
%set(gca,'Yscale','log')
grid on
title("Spectrum During Lightning Strike")
xlabel("Energy (keV)")
ylabel("Counts per keV per Second")

subplot(2,2,1)
radData_spectrum = radData(~isnan(radData.time),:);
m = abs(max(-radData_spectrum.pulsedata_b(radData_spectrum.timeInterp > 0 & radData_spectrum.timeInterp < 2340,4:end),[],2)*kev_c-kev_off);
normal_spectrum_full = histcounts(m,"NumBins",binNum,"BinLimits",[0 8192*kev_c]);
plot((0:binNum-1)*kev_c*8192/binNum,smooth(normal_spectrum_full,1)/2340/(8192/binNum),'k','LineWidth',1)
xlim(plotxlim)
grid on
title("Nominal LYSO Spectrum")
xlabel("Energy (keV)")
ylabel("Counts per keV per Second")

subplot(2,2,[3,4])
lightning_spectrum_binned = histcounts(m_lightning(selected_times > 2396.5 & selected_times < 2397.5),"NumBins",binNum,"BinLimits",[0 8192*kev_c]);
%plot((0:binNum-1)*kev_c*8192/binNum,smooth(lightning_spectrum_binned,1)/(8192/binNum)-smooth(normal_spectrum_full,1)/2340/(8192/binNum),'k','LineWidth',1)
scatter((0:binNum-1)*kev_c*8192/binNum,smooth(lightning_spectrum_binned,1)/(8192/binNum)-smooth(normal_spectrum_full,1)/2340/(8192/binNum)/2,'k','+','LineWidth',0.75,'SizeData',20)
xlim(plotxlim)
ylim([0 15])
%set(gca,'Xscale','log')
%set(gca,'Yscale','log')
grid on
title("Lightning Spectrum with LYSO Background Subtracted")
xlabel("Energy (keV)")
ylabel("Counts per keV per Second")

% creating the zoom-in inset
% ax=axes;
% set(ax,'units','normalized','position',[0.5,0.2,0.2,0.2])
% box(ax,'on')
% scatter((0:binNum-1)*kev_c*8192/binNum,smooth(lightning_spectrum_binned,1)/(8192/binNum)-smooth(normal_spectrum_full,1)/2340/(8192/binNum),'k','+','LineWidth',0.75,'SizeData',25)
% set(ax,'xlim',[400 600],'ylim',[0 10])
% grid on


%%
radData = PayloadRadData{4};
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1(radData1.timeInterp > 0,:);
radData1 = radData1(radData1.timeInterp < 30000,:);
% radData1 = radData1(var(radData1.pulsedata_b(:,4:end),0,2) > 1000,:);
% radData1 = radData1(max(-radData1.pulsedata_b(:,4:end),[],2) > 400,:);
% radData1 = radData1(mean(-radData1.pulsedata_b(:,4:end),2) > 100,:);
% radData1 = radData1(mean(-radData1.pulsedata_b(:,4:end),2) < 1200,:);
% radData1 = radData1(max(abs(diff(radData1.pulsedata_b(:,4:end),1,2)),[],2) < 1000,:);
% radData1 = radData1(max(-radData1.pulsedata_b(:,4:9),[],2) > 1.2*max(abs(-radData1.pulsedata_b(:,20:end)),[],2),:);
% radData1 = radData1(mean(-radData1.pulsedata_b(:,4:5),2) < 800,:);
% radData1 = radData1(-radData1.pulsedata_b(:,4) < -radData1.pulsedata_b(:,5) & -radData1.pulsedata_b(:,5) < -radData1.pulsedata_b(:,6),:);
% radData1 = radData1(~radData1.isTail,:);

figure('Color','white')
scatter(radData1.timeInterp,max(-radData1.pulsedata_b,[],2),'filled','SizeData',10,'CData',[zeros(length(radData1.isTail),1)  zeros(length(radData1.isTail),1) mean(-radData1.pulsedata_b(:,20:end),2)./max(-radData1.pulsedata_b,[],2)])
ylim([0 3500])

%% PSD Plot

channel = 'B';
removeTails = 1;
tailCutoff = 14;
binSize = 5;

figure('Color','white') % Sets the background color to white
t = tiledlayout(3,2);
t.Padding = 'compact';
t.TileSpacing = 'compact';

nexttile
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1(radData1.timeInterp < 550,:);
makePSD(radData1,channel,removeTails,tailCutoff,binSize);
title('On the Ground PSD')

nexttile
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1(radData1.timeInterp > 650,:);
makePSD(radData1,channel,removeTails,tailCutoff,binSize);
title('Whole Flight PSD')

nexttile
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1(radData1.timeInterp > 782.5,:);
radData1 = radData1(radData1.timeInterp < 782.6,:);
makePSD(radData1,channel,removeTails,tailCutoff,binSize);
title('First Lightning Strike PSD')

nexttile
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1(radData1.timeInterp > 2396.5,:);
radData1 = radData1(radData1.timeInterp < 2397.5,:);
makePSD(radData1,channel,removeTails,tailCutoff,binSize);
title('Main Lightning Strike PSD')

nexttile
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1(radData1.timeInterp > 2340,:);
radData1 = radData1(radData1.timeInterp < 2540,:);
makePSD(radData1,channel,removeTails,tailCutoff,binSize);
title('Storm PSD')

nexttile
radData1 = radData(~isnan(radData.time),:);
radData1 = radData1((radData1.timeInterp < 2340 | radData1.timeInterp > 2540),:);
makePSD(radData1,channel,removeTails,tailCutoff,binSize);
title('Non-Storm PSD')



function makePSD(radData1,channel,removeTails,tailCutoff,binSize)
if channel == 'A'
    peak_data = max(-radData1.pulsedata_a(:,4:tailCutoff)')';
    %peak_data = max(-radData1.pulsedata_a(:,4:tailCutoff)')' - min(-radData1.pulsedata_a(:,tailCutoff+1:end)')';
    tail_data = mean(-radData1.pulsedata_a(:,tailCutoff+1:end)')';

    peak_data = peak_data(max(-radData1.pulsedata_a(:,:)')<8192);
    tail_data = tail_data(max(-radData1.pulsedata_a(:,:)')<8192);

    tails = radData1.isTail(max(-radData1.pulsedata_a(:,:)')<8192);
else
    peak_data = max(-radData1.pulsedata_b(:,4:tailCutoff)')' ;
    %peak_data = max(-radData1.pulsedata_b(:,4:tailCutoff)')' - min(-radData1.pulsedata_b(:,tailCutoff+1:end)')';
    tail_data = mean(-radData1.pulsedata_b(:,tailCutoff+1:end)')';

    peak_data = peak_data(max(-radData1.pulsedata_b(:,:)')<8192);
    tail_data = tail_data(max(-radData1.pulsedata_b(:,:)')<8192);

    tails = radData1.isTail(max(-radData1.pulsedata_b(:,:)')<8192);
end


if removeTails
    peak_data = peak_data(tails==0);
    tail_data = tail_data(tails==0);
end

h=hist3([peak_data,tail_data],[round((max(peak_data)-min(peak_data))/binSize),round((max(tail_data)-min(tail_data))/binSize)],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
imagesc(min(peak_data):max(peak_data),flip(min(tail_data):max(tail_data),1),h','AlphaData',h')
colormap('jet')
set(gca, 'ColorScale', 'log')
set(gca,'YDir','normal')
caxis([1, max(max(h))])
colorbar
view(2)
sgtitle({"Pulse Shape Discrimination Scatter Plot","ADC " + channel + " " + num2str((tailCutoff-4)*20) + " ns Trigger to Tail Start"})
xlabel('Max Peak Height')
ylabel('Mean Tail Height')
%hold on
%plot(0:8000,0:8000)
if channel == 'A'
    xlim([0 8000])
    ylim([0 8000])
else
    xlim([0 2400])
    ylim([0 1000]) 
end

end

