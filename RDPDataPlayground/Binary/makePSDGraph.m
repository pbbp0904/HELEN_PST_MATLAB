function [] = makePSDGraph(PayloadRadData,payloadNumber,channel,removeTails)
figure()
if channel == 'a'
    peak_data = mean(-PayloadRadData{payloadNumber}.pulsedata_a(:,4:14)')';
    tail_data = mean(-PayloadRadData{payloadNumber}.pulsedata_a(:,14:end)')';
else
    peak_data = mean(-PayloadRadData{payloadNumber}.pulsedata_b(:,4:14)')';
    tail_data = mean(-PayloadRadData{payloadNumber}.pulsedata_b(:,14:end)')';
end

if removeTails
    peak_data = peak_data(PayloadRadData{payloadNumber}.isTail==0);
    tail_data = tail_data(PayloadRadData{payloadNumber}.isTail==0);
end

h=hist3([peak_data,tail_data],[round((max(peak_data)-min(peak_data))/4),round((max(tail_data)-min(tail_data))/4)],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
imagesc(min(peak_data):max(peak_data),flip(min(tail_data):max(tail_data),1),h','AlphaData',h')
colormap('jet')
set(gca, 'ColorScale', 'log')
set(gca,'YDir','normal')
caxis([1, max(max(h))])
colorbar
view(2)
title({'Pulse Shape Discrimination Scatter Plot','ADC B 60ns Peak to Tail Delay'})
xlabel('Peak Sample Height')
ylabel('Tail Sample Height')
ylim([-300,2500])
xlim([-200,1800])


end

