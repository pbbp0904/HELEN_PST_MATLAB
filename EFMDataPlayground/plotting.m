clc; close all;

if (~exist('PayloadEfmData','var'))
	load('EFMData')
end


windowStart1 = 70000;
windowEnd1 = 120000;

windowStart2 = 60000;
windowEnd2 = 160000;

sampleSpeed = 25;
t = (0:(windowEnd1-windowStart1))/sampleSpeed;


figure()
plot(t,PayloadEfmData{1}.ADC(windowStart1:windowEnd1))
title('Raw ADC Readings from EFM on the Ground During Alabama Storm')
xlabel('Seconds')
ylabel('ADC Channel')

