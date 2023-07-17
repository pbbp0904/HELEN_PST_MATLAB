payload = 2;
figure();
F = FlightData(FlightData.PayloadNumber==payload,:);
b = F.EPeakB;

b = b(boolean(~F.isTail),:);
bp = b;
b = b(b<8192,:);
b = b(1:end,:);


d = F.gpsAlts;
d = d(boolean(~F.isTail),:);
d = d(bp<8192,:);
d = d(1:end,:);
b = b(d>=300,:);
d = d(d>=300,:);

try
    h=hist3([b,d],[round((max(b)-min(b))/20),round((max(d)-min(d))/20)],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
    imagesc(min(d):max(d),min(b):max(b),h,'AlphaData',h)
    colormap('jet')
    set(gca, 'ColorScale', 'log')
    set(gca,'YDir','normal')

    caxis([1, max(max(h))])
catch
end
colorbar;
view(2)

title(sprintf('Channel B Energy Waterfall for Payload %i',payload))
xlabel('Altitude (m)')
ylabel('Energy (bin)')
ylabel(h, 'Counts/bin') % Colorbar label