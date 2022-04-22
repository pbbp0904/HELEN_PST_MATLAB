function [] = makePSDGraph(PayloadRadData,payloadNumber,channel,removeTails,start,finish,binSize,tailCutoff)

%start = max(round(start*length(PayloadRadData{payloadNumber}.pulsedata_a)),1);
%finish = min(round(finish*length(PayloadRadData{payloadNumber}.pulsedata_a)),length(PayloadRadData{payloadNumber}.pulsedata_a));


if channel == 'A'
    peak_data = mean(-PayloadRadData{payloadNumber}.pulsedata_a(start:finish,4:tailCutoff)')';
    tail_data = mean(-PayloadRadData{payloadNumber}.pulsedata_a(start:finish,tailCutoff+1:end)')';

    peak_data = peak_data(max(-PayloadRadData{payloadNumber}.pulsedata_a(start:finish,:)')<8192);
    tail_data = tail_data(max(-PayloadRadData{payloadNumber}.pulsedata_a(start:finish,:)')<8192);

    tails = PayloadRadData{payloadNumber}.isTail(start:finish);
    tails = tails(max(-PayloadRadData{payloadNumber}.pulsedata_a(start:finish,:)')<8192);
else
    peak_data = mean(-PayloadRadData{payloadNumber}.pulsedata_b(start:finish,4:tailCutoff)')';
    tail_data = mean(-PayloadRadData{payloadNumber}.pulsedata_b(start:finish,tailCutoff+1:end)')';

    peak_data = peak_data(max(-PayloadRadData{payloadNumber}.pulsedata_b(start:finish,:)')<8192);
    tail_data = tail_data(max(-PayloadRadData{payloadNumber}.pulsedata_b(start:finish,:)')<8192);

    tails = PayloadRadData{payloadNumber}.isTail(start:finish);
    tails = tails(max(-PayloadRadData{payloadNumber}.pulsedata_b(start:finish,:)')<8192);
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
title({"Pulse Shape Discrimination Scatter Plot","ADC " + channel + " " + num2str((tailCutoff-4)*20) + " ns Trigger to Tail Start"})
xlabel('Mean Peak Height')
ylabel('Mean Tail Height')
%ylim([-300,8192])
%xlim([-300,8192])


end

