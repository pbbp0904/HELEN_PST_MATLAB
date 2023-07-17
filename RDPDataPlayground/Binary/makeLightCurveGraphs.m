minHeight = 0;
maxHeight = 10000;
t = 1;
s = 1;
figure()
[lightCurve1,lightCurveReal1] = makeLightCurveEnergyFiltered(PayloadRadData{1}.dcc_time,PayloadRadData{1}.pulsedata_b,t,minHeight,maxHeight);
plot(smooth(lightCurve1,s))
xlim([0 6000/t])
title(PayloadPrefixes{1})

figure()
[lightCurve2,lightCurveReal2] = makeLightCurveEnergyFiltered(PayloadRadData{2}.dcc_time,PayloadRadData{2}.pulsedata_b,t,0,maxHeight);
plot(smooth(lightCurve2,s))
xlim([0 6000/t])
title(PayloadPrefixes{2})

figure()
[lightCurve3,lightCurveReal3] = makeLightCurveEnergyFiltered(PayloadRadData{3}.dcc_time,PayloadRadData{3}.pulsedata_b,t,minHeight,maxHeight);
plot(smooth(lightCurve3,s))
xlim([0 6000/t])
title(PayloadPrefixes{3})

figure()
[lightCurve4,lightCurveReal4] = makeLightCurveEnergyFiltered(PayloadRadData{4}.dcc_time,PayloadRadData{4}.pulsedata_b,t,minHeight,maxHeight);
plot(smooth(lightCurve4,s))
xlim([0 6000/t])
title(PayloadPrefixes{4})


%%
figure()
maxLength = max([length(lightCurve1), length(lightCurve2), length(lightCurve3), length(lightCurve4)]);
lightCurveSum = [lightCurve1 zeros(1,maxLength-length(lightCurve1))]+[lightCurve2 zeros(1,maxLength-length(lightCurve2))]+[lightCurve3 zeros(1,maxLength-length(lightCurve3))]+[lightCurve4 zeros(1,maxLength-length(lightCurve4))];
plot(smooth(lightCurveSum,s))
xlim([0 15000/t])








%%

conv_power = 1;
figure()
conv_12 = conv(lightCurve1.^conv_power,lightCurve2.^conv_power);
plot(conv_12)

figure()
conv_13 = conv(lightCurve1.^conv_power,lightCurve3.^conv_power);
plot(conv_13)

figure()
conv_14 = conv(lightCurve1.^conv_power,lightCurve4.^conv_power);
plot(conv_14)

figure()
conv_23 = conv(lightCurve2.^conv_power,lightCurve3.^conv_power);
plot(conv_23)

figure()
conv_24 = conv(lightCurve2.^conv_power,lightCurve4.^conv_power);
plot(conv_24)

figure()
conv_34 = conv(lightCurve3.^conv_power,lightCurve4.^conv_power);
plot(conv_34)



