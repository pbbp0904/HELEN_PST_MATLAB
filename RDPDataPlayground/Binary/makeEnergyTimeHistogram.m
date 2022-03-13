payloadNumber = 2;
b = PayloadRadData{payloadNumber}.pulsedata_a;
b = b(boolean(~PayloadRadData{payloadNumber}.isTail),:);
%b = b(max(abs(b'))<3000,:);
b = b(1:end,:);


d = PayloadRadData{payloadNumber}.pps_count;
d = d(boolean(~PayloadRadData{payloadNumber}.isTail),:);
%d = d(max(abs(b'))<3000,:);
d = d(1:end,:);
b = b(d~=0,:);
d = d(d~=0,:);


m = max(-b');
h=hist3([m',d],[round((max(m)-min(m))/5),round((max(d)-min(d))/6)],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
imagesc(0:max(d),min(m):max(m),h,'AlphaData',h)
colormap('jet')
set(gca, 'ColorScale', 'log')
set(gca,'YDir','normal')
caxis([1, max(max(h))])
colorbar
view(2)