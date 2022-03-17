payload = 1;
figure();
F = FlightData(FlightData.PayloadNumber==payload,:);
b = F.EPeakA;

b = b(boolean(~F.isTail),:);
bp = b;
%b = b(b<8192,:);
b = b(1:end,:);


d = F.EPeakB;
d = d(boolean(~F.isTail),:);
%d = d(bp<8192,:);
d = d(1:end,:);
b = b(d~=0,:);
d = d(d~=0,:);

try
    h=hist3([b,d],[round((max(b)-min(b))/5),round((max(d)-min(d))/5)],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
    imagesc(0:max(d),min(b):max(b),h,'AlphaData',h)
    colormap('jet')
    set(gca, 'ColorScale', 'log')
    set(gca,'YDir','normal')

    caxis([1, max(max(h))])
catch
end
h = colorbar;
view(2)

title(sprintf('Channel A/B Linearity Histogram Payload %i',payload))
xlabel('Channel B (bin)')
ylabel('Channel A (bin)')
ylabel(h, 'Counts/bin') % Colorbar label