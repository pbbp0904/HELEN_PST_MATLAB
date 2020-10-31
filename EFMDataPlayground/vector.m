clear; clc; close all;

load('EFMData')


AccX = PayloadEfmData{1}.AccX-100;
ADC = PayloadEfmData{1}.ADC;
eField = PayloadEfmData{1}.eField/1000; % Convert to kV/m


WindowStart = 60000;
WindowEnd = 160000;



EFieldDirection = zeros(1,WindowEnd-WindowStart+1)+100;
for i = WindowStart:WindowEnd
   for j = -200:-50
       if(abs(AccX(i)-j)<2)
           if(ADC(i)==max(ADC(i-5:i+5)))
               EFieldDirection(i-WindowStart+1) = -AccX(i)/(max(abs(AccX(max(1,i-100):min(length(AccX),i+100)))));
           end
       end
   end
   if(EFieldDirection(i-WindowStart+1)==100&&i>WindowStart)
       EFieldDirection(i-WindowStart+1) = EFieldDirection(i-WindowStart);
   end
end
EFieldDirection = EFieldDirection - min(EFieldDirection(100:WindowEnd-WindowStart-100));
EFieldDirection = 2*real(asind(EFieldDirection/max(EFieldDirection(100:WindowEnd-WindowStart-100))));


figure()
hold on

sampleSpeed = 25; % Hz

imagesc((1:length(EFieldDirection))/sampleSpeed,[min(eField(WindowStart:WindowEnd))/2 max(eField(WindowStart:WindowEnd))/2],EFieldDirection);
colormap('gray')
caxis([0, 180])
c = colorbar;
plot((1:length(EFieldDirection))/sampleSpeed,smooth(abs(eField(WindowStart:WindowEnd)),1),'blue')
xlim([1 length(EFieldDirection)/sampleSpeed])
ylim([0 max(eField(WindowStart:WindowEnd))])
xlabel('Seconds After Storm Start')
ylabel('Electric Field Magnitude (kV/m)')
ylabel(c, {'Electric Field Direction','(Degrees from Nadir)'})
set(gca,'YColor',[0 0 1]);
title('Electric Field Magnitude and Direction')


