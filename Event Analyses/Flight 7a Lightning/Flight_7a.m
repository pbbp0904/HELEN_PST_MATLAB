%%
parseRawData()

%%

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
plot(0:dt:(length(lc)*dt)-dt,lc,'k')
hold on
%plot(PayloadEnvData{4}.PacketNum,PayloadEnvData{4}.gpsAlts*20)
%plot(PayloadEnvData{4}.PacketNum,(smooth(sqrt(PayloadEnvData{4}.AccX.^2+PayloadEnvData{4}.AccY.^2+PayloadEnvData{4}.AccZ.^2),1)-10)*10^4)
camOffset = 99.2;
plot(camOffset:1/30:(length(PayloadCamData{4}.meanGrayLevels)/30-1/30+camOffset), PayloadCamData{4}.meanGrayLevels,'b')


%% First lightning strike
figure('Color','white')
dt = 0.0001;
lc = histcounts(PayloadRadData{4}.timeInterp,"NumBins",round((dt)^(-1)*2),"BinLimits",[782 783]);
plot(0:dt:(length(lc)*dt)-dt,lc,'k')

%% THE lightning strike
figure('Color','white')
dt = 0.001;
lc = histcounts(PayloadRadData{4}.timeInterp,"NumBins",round((dt)^(-1)*2),"BinLimits",[2396 2398]);
plot(0:dt:(length(lc)*dt)-dt,lc,'k')

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
b = radData1.pulsedata_b;
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
figure();
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

%% PLotting light curve of clusters
% List of clusters to include in the light curve
include_clusters = [22, 12, 7, 6, 1, 3, 15, 17, 19, 25, 8, 18];  % replace with your own list of clusters
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
xlabel('Time from 05:07:08 UTC (s)')
ylabel('Ratio of selected pulses to total pulses')
title('Pulse ratio in selected clusters')
grid on

% Apply the ratio to the lightcurve data
lc_total = histcounts(PayloadRadData{4}.timeInterp,"NumBins",round((dt)^(-1)*2),"BinLimits",[2396 2398]);
plot(0:dt:(length(lc)*dt)-dt,lc_ratio.*lc_total,'k')
xlabel('Time from 05:07:08 UTC (s)')
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
plot(18428-pm_seconds:dt:18428-pm_seconds+(length(lc)*dt)-dt,lc_ratio.*lc_total,'k')
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

%% Load GLM Data
filename = 'E:\Flight Data\Flight 7a\3-Processed Data\GLMData.nc';
GLM_time_first = ncread(filename,'flash_time_offset_of_first_event');
GLM_time_last = ncread(filename,'flash_time_offset_of_last_event');
GLM_lat = ncread(filename,'flash_lat');
GLM_long = ncread(filename,'flash_lon');

GLM_time_first = double(typecast(int16(round((GLM_time_first+5)/0.00038148)),'uint16'))*0.00038148-5 + 18420 - 0.119369247108; % Convert properly and add 'seconds since 2023-06-19 05:07:00.000' offset, light travel time offset
GLM_time_last = double(typecast(int16(round((GLM_time_last+5)/0.00038148)),'uint16'))*0.00038148-5 + 18420 - 0.119369247108; % Convert properly and add 'seconds since 2023-06-19 05:07:00.000' offset, light travel time offset

figure('Color', 'white')
plot(18428-pm_seconds:dt:18428-pm_seconds+(length(lc)*dt)-dt,lc_ratio.*lc_total,'k')
ylabel('Counts per Millisecond')
hold on
yyaxis right
histogram(GLM_time_first(GLM_lat > 34 & GLM_lat < 35 & GLM_long > -89 & GLM_long < -88),1000,'FaceColor','b')
hold on
histogram(GLM_time_last(GLM_lat > 34 & GLM_lat < 35 & GLM_long > -89 & GLM_long < -88),1000,'FaceColor','r')


xlim([18428-pm_seconds 18428+pm_seconds])

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'b';

GLM_lat = GLM_lat(GLM_time > 18426 & GLM_time < 18430);
GLM_long = GLM_long(GLM_time > 18426 & GLM_time < 18430);

figure('Color', 'white')
scatter(GLM_long,GLM_lat)
ylim([34 35])
xlim([-89 -88])
hold on
scatter(-88.3519,34.6812,'x')


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

