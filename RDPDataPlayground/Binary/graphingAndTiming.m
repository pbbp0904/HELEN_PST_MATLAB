
%% Plotting environmental data
for i = 1:width(PayloadEnvData{1})
figure()
t = tiledlayout(2,2);
t.Padding = 'compact';
t.TileSpacing = 'compact';
for payload = 1:4
nexttile
plot(table2array(PayloadEnvData{payload}(:,i)))
title(sprintf("Payload %i: %s",payload, PayloadEnvData{payload}.Properties.VariableNames{i}))
end
end

%% Plotting radiation data
for i = [1:5,8]
figure()
%t = tiledlayout(2,2);
%t.Padding = 'compact';
%t.TileSpacing = 'compact';
for payload = 3
%nexttile
plot(table2array(PayloadRadData{payload}(:,i)))
title(sprintf("Payload %i: %s",payload, PayloadRadData{payload}.Properties.VariableNames{i}))
end
end

%% Plotting timing data
for i = 3
    figure()
    hold on
    payload = i;
    %plot((PayloadRadData{payload}.pps_time-min(PayloadRadData{payload}.pps_time))./max((PayloadRadData{payload}.pps_time-min(PayloadRadData{payload}.pps_time))))
    plot((PayloadRadData{payload}.dcc_time-min(PayloadRadData{payload}.dcc_time))./max((PayloadRadData{payload}.dcc_time-min(PayloadRadData{payload}.dcc_time))))
    %plot((PayloadRadData{payload}.subSecond-min(PayloadRadData{payload}.subSecond))./max((PayloadRadData{payload}.subSecond-min(PayloadRadData{payload}.subSecond))))
end

%% Pulses
figure()
payload = 3;
for pulse = 3028400:3030000
    if ~isnan(PayloadRadData{payload}.pulsedata_b(pulse,1))
        if ~PayloadRadData{payloadNumber}.isTail(pulse)
            plot(-PayloadRadData{payload}.pulsedata_b(pulse,:))
            ylim([0 3000])
            title(num2str(pulse))
            drawnow
            pause
        end
    end
end


%% Light curves
for i = 3
    [lightCurve,lightCurveReal] = makeLightCurveEnergyTailFiltered(PayloadRadData,i,0.01,0,8000);
    figure()
    plot(lightCurve)
end
