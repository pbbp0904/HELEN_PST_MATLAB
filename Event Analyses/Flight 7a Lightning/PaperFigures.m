%% Load Data
% HELEN
load('E:\Flight Data\Flight 7a\3-Processed Data\PayloadEnvData.mat')
load('E:\Flight Data\Flight 7a\3-Processed Data\PayloadRadData.mat')
load('E:\Flight Data\Flight 7a\3-Processed Data\PayloadCamData.mat')
load('E:\Flight Data\Flight 7a\3-Processed Data\LMA\LMAData.mat');

% LMA
load('E:\Flight Data\Flight 7a\3-Processed Data\LMA\LMAData.mat')

% GLM
load('E:\Flight Data\Flight 7a\3-Processed Data\GLM\GLMData.mat');


%% Whole flight 

% Set filters
origin = [34.6816045 -88.351260167 11913];
lat_bounds = [34.5 34.72];
long_bounds = [-88.63 -88.15];

% GLM
GLM_Data_Filtered = GLM_Data(GLM_Data.GLM_event_lat > lat_bounds(1) & GLM_Data.GLM_event_lat < lat_bounds(2) & GLM_Data.GLM_event_long > long_bounds(1) & GLM_Data.GLM_event_long < long_bounds(2) & GLM_Data.GLM_event_time > 16420 & GLM_Data.GLM_event_time < 19620 ,:);

% LMA
LMA_Data_Filtered = LMA_Data(LMA_Data.Latitude > lat_bounds(1) & LMA_Data.Latitude < lat_bounds(2) & LMA_Data.Longitude > long_bounds(1) & LMA_Data.Longitude < long_bounds(2) & LMA_Data.Time > 16420 & LMA_Data.Time < 19620,:);

% HELEN camera
camOffset = 98.34+18428-2397;
HELEN_Camera_Time = camOffset:1/30:(length(PayloadCamData{4}.meanGrayLevels)/30-1/30+camOffset);
for i = 1:length(HELEN_Camera_Time)
    HELEN_Camera_Time(i) = HELEN_Camera_Time(i) + 0.413*floor(i/9000);
end
HELEN_Camera = PayloadCamData{4}.meanGrayLevels;

% HELEN radiation
dt = 0.1;
HELEN_Radiation = histcounts(PayloadRadData{4}.timeInterp,"NumBins",(dt)^(-1)*ceil(PayloadRadData{4}.timeInterp(end)-1),"BinLimits",[0 ceil(PayloadRadData{4}.timeInterp(end)-1)]);
HELEN_Radiation_Time = 18428-2397:dt:18428-2397+(length(HELEN_Radiation)*dt)-dt;

% HELEN altitude
HELEN_Altitude = PayloadEnvData{4}.gpsAlts(1:3600);
HELEN_Altitude_Time = PayloadEnvData{4}.PacketNum(1:3600)+18428-2397;


% Make figure
hFig = figure('Color','white');

% Set figure size
figWidth = 850; % width in pixels
figHeight = 1100; % height in pixels
set(hFig, 'Position', [0 0 figWidth figHeight])
figureFontSize = 11;
plotXLim = [16200 19800];

% Plot timeline
h1 = subplot(6,1,1);
% Launch label
xline(16616,"Label",'Launch - 4:36:56','LabelHorizontalAlignment','left','FontSize',9)
% TGF label
xline(16813,"Label",'TGF - 4:40:13.566','LabelHorizontalAlignment','left','Color','r','FontSize',9)

% Gamma ray glow 1 label
glowStart = 17526;
glowDuration = 2.5 * 60; % 2.5 minutes in seconds
patch([glowStart, glowStart, glowStart + glowDuration, glowStart + glowDuration], ...
      [0, 1, 1, 0], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none')
text(glowStart + glowDuration/2, 0.26, 'Glow - 2.5 min', 'Color', 'r','Rotation',90,'FontSize',9)

% Enhanced activity
glowStart = 18310;
glowDuration = 240;
patch([glowStart, glowStart, glowStart + glowDuration, glowStart + glowDuration], ...
      [0, 1, 1, 0], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none')
text(glowStart + glowDuration-50, 0.31, 'Active - 4 min', 'Color', 'r','Rotation',90,'FontSize',9)

% Lightning strike label
xline(18428,"Label",'Strike - 5:07:08','LabelHorizontalAlignment','left','Color','b','FontSize',9)

% TGF label
xline(18957,"Label",'TGF - 5:15:57.533','LabelHorizontalAlignment','left','Color','r','FontSize',9)
% TGF label
xline(19364,"Label",'TGF - 5:22:44.066','LabelHorizontalAlignment','left','Color','r','FontSize',9)
% Landing label
xline(19585,"Label",'Landing - 5:26:35','LabelHorizontalAlignment','left','Color','k','FontSize',9)

xlim(plotXLim)
p1 = get(h1, 'Position');
set(gca,'XTickLabel',[]);
set(gca,'FontSize',figureFontSize);
set(gca,'YTick',[]);
ylabel({'Timeline','of Events'})


% Plot altitude
h2 = subplot(6,1,2);
plot(HELEN_Altitude_Time,HELEN_Altitude/1000,'k','LineWidth',2)
xlim(plotXLim)
ylim([0 15])
box on
p2 = get(h2, 'Position');
set(gca,'XTickLabel',[]);
set(gca,'FontSize',figureFontSize);
set(gca,'XTick',[]);
ylabel({'Altitude','[km]'})
grid on

% Plot radiation
h3 = subplot(6,1,3);
plot(HELEN_Radiation_Time,log10(HELEN_Radiation),'k','LineWidth',0.5)
xlim(plotXLim)
box on
p3 = get(h3, 'Position');
set(gca,'FontSize',figureFontSize);
set(gca,'XTickLabel',[]);
set(gca,'XTick',[]);
ylabel({'Radiation','[log10(#/0.1s)]'})
grid on

% Plot camera
h4 = subplot(6,1,4);
plot(HELEN_Camera_Time,HELEN_Camera/256,'g')
xlim(plotXLim)
box on
p4 = get(h4, 'Position');
set(gca,'FontSize',figureFontSize);
set(gca,'XTickLabel',[]);
ylabel({'Camera', 'Brightness'})

% Enhanced activity
cutoutStart = 18428;
cutoutDuration = 1200;
patch([cutoutStart, cutoutStart, cutoutStart + cutoutDuration, cutoutStart + cutoutDuration], ...
      [0, 1, 1, 0], 'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none')
text(cutoutStart + cutoutDuration/2, 0.5, {'Camera Inactive','After Strike'}, 'FontSize', 10, 'Color', 'k','HorizontalAlignment','center')

% Plot GLM
h5 = subplot(6,1,5);
scatter(GLM_Data_Filtered.GLM_event_time,GLM_Data_Filtered.GLM_event_energy,'r','LineWidth',0.1)
xlim(plotXLim)
box on
p5 = get(h5, 'Position');
set(gca,'FontSize',figureFontSize);
set(gca,'XTickLabel',[]);
ylabel({'GLM Energy','[J]'})

% Plot LMA
h6 = subplot(6,1,6);
scatter(LMA_Data_Filtered.Time,LMA_Data_Filtered.Power,'b','LineWidth',0.1)
xlim(plotXLim)
box on
p6 = get(h6, 'Position');
set(gca,'FontSize',figureFontSize);
ylabel({'NALMA Power','[dBW]'})
ax = gca;
ax.XAxis.Exponent=0;
xlabel('UTC Time','FontSize',figureFontSize)

plot_offset = 0.035;
p5(2) = p6(2)+p6(4)+plot_offset;
p4(2) = p5(2)+p5(4)+plot_offset;
p3(2) = p4(2)+p4(4)+plot_offset;
p2(2) = p3(2)+p3(4)+plot_offset;
p1(2) = p2(2)+p2(4)+plot_offset;

set(h1, 'pos', p1);
set(h2, 'pos', p2);
set(h3, 'pos', p3);
set(h4, 'pos', p4);
set(h5, 'pos', p5);

sgtitle('Flight Overview - June 19th 2023','FontSize',20)

% Get all ylabels
hYLabels = get(findobj(gcf, 'Type', 'axes'), 'YLabel');

% Get the maximum extent of all ylabels
maxExtent = max(cellfun(@(h) h.Extent(1), hYLabels));

% Adjust each ylabel position
for i = 1:numel(hYLabels)
    hYLabels{i}.Position(1) = maxExtent+100;
end

% Create datetime array for xticks
startOfDay = datetime(2023, 6, 19);
stepSize = 600;
xticksInDatetime = startOfDay + seconds(plotXLim(1):stepSize:plotXLim(2)); % adjust the step size (100 here) as needed

% Convert xticks to strings in 'HH:MM:SS' format
xticksInString = cellstr(datestr(xticksInDatetime,'HH:MM:SS'));

% Set xticks and xticklabels
set(gca, 'XTick', plotXLim(1):stepSize:plotXLim(2)); % adjust the step size (100 here) as needed
set(gca, 'XTickLabel', xticksInString);

% Save figure as 600 dpi png
exportgraphics(hFig, 'E:\HELEN_Code\HELEN_PST_MATLAB\Event Analyses\Flight 7a Lightning\Figures\Flight_Overview.png', 'Resolution', 600)

