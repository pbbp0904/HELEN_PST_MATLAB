function [eField] = calculateEField1Ax(v, Ks)
%CALCULATEEFIELD Calculates the electric field based on measured voltage,
%acceleration, and magnetic field.

% Import values
cac = Ks.chargeAmpCapacitance;
e0 = Ks.e0;
g = Ks.g;
sa = Ks.sphereArea;
sp = Ks.samplePeriod;
gain = Ks.ampGain;

Ez = max(smooth(v,5))*cac/(e0*sa*gain);

Ex= 0;
Ey= 0;

% Combine components into eField vector
eField = [Ex, Ey, Ez];

end

