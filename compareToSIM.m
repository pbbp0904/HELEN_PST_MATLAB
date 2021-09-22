close all
max = 300;
offset = 7;
hold on
plot(time(1:max+1),vSim(offset:max+offset)/Ks.sphereArea/Ks.e0/Ks.ampGain*Ks.chargeAmpCapacitance,'LineWidth',2)
plot(time(1:max),v(1:max)/Ks.sphereArea/Ks.e0/Ks.ampGain*Ks.chargeAmpCapacitance,'LineWidth',2)
title('Electric Field Over Time')
xlabel('Time (s)')
ylabel('Electric Field (V/m)')
legend('Simulated', 'Measured')