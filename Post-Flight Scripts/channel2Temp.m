function [T] = channel2Temp(channel)
A = 3.354*10^(-3);
B = 2.5698*10^(-4);
C = 2.62*10^(-6);
D = 6.383*10^(-8);
R0 = 24000; % Resistance of fixed resistor
ADCGain = 3.3/1.6; % Gain of ADC
ADCRes = 2^12; % Resolution of ADC

V = ADCGain./ADCRes.*channel;
R = R0.*V./(3.3-V);

T = real((A + B.*log(R./10000) + C.*(log(R./10000)).^2 + D.*(log(R./10000)).^3).^(-1) - 273);

end

