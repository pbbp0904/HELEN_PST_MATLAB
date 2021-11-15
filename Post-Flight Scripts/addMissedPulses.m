function [PayloadRadDatai] = addMissedPulses(PayloadRadDatai)
%ADDMISSEDPULSES Summary of this function goes here
%   Detailed explanation goes here

if length(PayloadRadDatai.pulse_num)>1
    missingPulses = setdiff(1:max(PayloadRadDatai.pulse_num),PayloadRadDatai.pulse_num);
    NaNs1 = NaN(length(missingPulses),1);
    NaNs2 = NaN(length(missingPulses),32);
    missingPulseTable = table(NaNs1, NaNs1, NaNs1, missingPulses', NaNs1, NaNs2, NaNs2, NaNs1, NaNs1, 'VariableNames', PayloadRadDatai.Properties.VariableNames);
    PayloadRadDatai = [PayloadRadDatai;missingPulseTable];
    PayloadRadDatai = sortrows(PayloadRadDatai, "pulse_num");
end

end

