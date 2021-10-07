function [] = makePSDGraph(PayloadRadData,payloadNumber)
figure()
b_peak_data = max(-PayloadRadData{payloadNumber}.pulsedata_b(:,:)')';
b_peak_data = b_peak_data(PayloadRadData{payloadNumber}.isTail==0);
b_tail_data = mean(-PayloadRadData{payloadNumber}.pulsedata_b(:,7:end)')';
b_tail_data = b_tail_data(PayloadRadData{payloadNumber}.isTail==0);
h=hist3([b_peak_data,b_tail_data],[round((max(b_peak_data)-min(b_peak_data))/4),round((max(b_tail_data)-min(b_tail_data))/4)],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
imagesc(min(b_peak_data):max(b_peak_data),flip(min(b_tail_data):max(b_tail_data),1),h','AlphaData',h')
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

