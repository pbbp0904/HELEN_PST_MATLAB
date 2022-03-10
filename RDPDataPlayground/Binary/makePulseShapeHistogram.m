payloadNumber = 3;
b = PayloadRadData{payloadNumber}.pulsedata_a;
b = b(boolean(~PayloadRadData{payloadNumber}.isTail),:);
%b = b(max(abs(b'))<40000,:);
%b = b(max(abs(b'))>2000,:);
b = b(1:end,:);
[~,I] = max(-b');
m = max(-b')-min(-b');
h=hist3([reshape(-b',[1,length(b)*32])',reshape(repmat((1:32)',length(b),1),[1,length(b)*32])'],[max(max(-b))-min(min(-b)),32],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
imagesc(1:32,min(min(-b)):max(max(-b)),h,'AlphaData',h)
colormap('jet')
set(gca, 'ColorScale', 'log')
set(gca,'YDir','normal')
caxis([1, max(max(h))])
colorbar
view(2)