payloadNumber = 1;
b = PayloadRadData{payloadNumber}.pulsedata_b;
b = b(boolean(~PayloadRadData{payloadNumber}.isTail),:);
bp = b;
b = b(boolean(max(abs(b'))<8100),:);
b = b(1:end,:);

d = zeros(length(PayloadRadData{payloadNumber}.pulsedata_b),1);
for i = 2:length(PayloadRadData{payloadNumber}.pulsedata_b)/2
    if PayloadRadData{payloadNumber}.dcc_time(i) + 4.5*10^7 < PayloadRadData{payloadNumber}.dcc_time(i-1)
        d(i) = d(i-1) + 1;
    else
        d(i) = d(i-1);
    end
end


d = d(boolean(~PayloadRadData{payloadNumber}.isTail),:);
d = d(boolean(max(abs(bp'))<8100),:);
d = d(1:end,:);
b = b(d~=0,:);
d = d(d~=0,:);


m = max(-b');
h=hist3([m',d],[round((max(m)-min(m))/20),round((max(d)-min(d))/1)],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
h(h<2) = 0;
imagesc(min(d):max(d),min(m):max(m),h,'AlphaData',h)
colormap('jet')
set(gca, 'ColorScale', 'log')
set(gca,'YDir','normal')
ylim([0 max(m)])
caxis([1, max(max(h))])

han = colorbar;
view(2)

title(sprintf('Channel A Energy Waterfall for Payload %i',payload))
xlabel('Time (s)')
ylabel('Energy (bin)')
ylabel(han, 'Counts/bin') % Colorbar label