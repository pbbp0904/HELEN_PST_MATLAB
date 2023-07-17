



binSize = 0.1;

r = histcounts(FlightData.time(FlightData.PayloadNumber==1),1:binSize:ceil(max(FlightData.time)));
g = histcounts(FlightData.time(FlightData.PayloadNumber==2),1:binSize:ceil(max(FlightData.time)));
y = histcounts(FlightData.time(FlightData.PayloadNumber==3),1:binSize:ceil(max(FlightData.time)));
b = histcounts(FlightData.time(FlightData.PayloadNumber==4),1:binSize:ceil(max(FlightData.time)));
figure
hold on
plot(r,'Color','red')
plot(g,'Color','green')
plot(y,'Color','yellow')
plot(b,'Color','blue')


%%
% binSize = 0.001;
% thresholdRate = 8000;
% 
% b = histcounts(FlightData.time(FlightData.PayloadNumber==4),1:binSize:ceil(max(FlightData.time)));
% b(b<binSize*thresholdRate) = 0;
% y = histcounts(FlightData.time(FlightData.PayloadNumber==3),1:binSize:ceil(max(FlightData.time)));
% y(y<binSize*thresholdRate) = 0;
% figure
% plot(y.*b)

%%
binSize = 0.001;

b = histcounts(FlightData.time(FlightData.PayloadNumber==4),1:binSize:ceil(max(FlightData.time)));
bSTD = std(b);
bSTDs = (b-smooth(b,3)')/bSTD;
bSTDs(bSTDs<3) = 0;
y = histcounts(FlightData.time(FlightData.PayloadNumber==3),1:binSize:ceil(max(FlightData.time)));
ySTD = std(y);
ySTDs = (y-smooth(y,3)')/ySTD;
ySTDs(ySTDs<3) = 0;
g = histcounts(FlightData.time(FlightData.PayloadNumber==2),1:binSize:ceil(max(FlightData.time)));
gSTD = std(g);
gSTDs = (g-smooth(g,3)')/gSTD;
gSTDs(gSTDs<3) = 0;
r = histcounts(FlightData.time(FlightData.PayloadNumber==1),1:binSize:ceil(max(FlightData.time)));
rSTD = std(r);
rSTDs = (r-smooth(r,3)')/rSTD;
rSTDs(rSTDs<3) = 0;
figure
hold on
plot(gSTDs.*rSTDs)
