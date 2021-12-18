clc; close all;

if (~exist('PayloadEfmData','var'))
	load('EFMData')
end


windowStart = 70000;
windowEnd = 120000;

subwindowStart = 110000;
subwindowEnd = 112500;

sampleSpeed = 20;
t = (0:(windowEnd-windowStart))/sampleSpeed;


figure()
plot(t,PayloadEfmData{1}.ADC(windowStart:windowEnd))
title('Raw ADC Readings from EFM on the Ground During Alabama Storm')
xlabel('Time (s)')
ylabel('ADC Channel')

figure()
plot(t(subwindowStart-windowStart:subwindowEnd-windowStart),PayloadEfmData{1}.ADC(subwindowStart:subwindowEnd))
title('Raw ADC Readings from EFM on the Ground During Alabama Storm')
xlabel('Time (s)')
ylabel('ADC Channel')

figure()
plot(t(subwindowStart-windowStart:subwindowEnd-windowStart),PayloadEfmData{1}.eField_RAW(subwindowStart:subwindowEnd)/1000)
title('Radial Electric Field from EFM on the Ground During Alabama Storm')
xlabel('Time (s)')
ylabel('Electric Field (kV/m)')

[eField,~] = envelope(PayloadEfmData{1}.eField_RAW,round(sampleSpeed*3/4),'peak');

figure()
hold on
plot(t(subwindowStart-windowStart:subwindowEnd-windowStart),PayloadEfmData{1}.eField_RAW(subwindowStart:subwindowEnd)/1000)
plot(t(subwindowStart-windowStart:subwindowEnd-windowStart),eField(subwindowStart:subwindowEnd)/1000,'k')
title('Envelope for EFM on the Ground During Alabama Storm')
xlabel('Time (s)')
ylabel('Electric Field (kV/m)')
legend('Radial Electric Field','Electric Field Envelope')

figure()
hold on
plot(t(subwindowStart-windowStart:subwindowEnd-windowStart),eField(subwindowStart:subwindowEnd)/1000)
title('Electric Field Magnitude from EFM on the Ground During Alabama Storm')
xlabel('Time (s)')
ylabel('Electric Field (kV/m)')


