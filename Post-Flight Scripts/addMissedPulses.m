function [PayloadRadData] = addMissedPulses(PayloadRadData)
%ADDMISSEDPULSES Summary of this function goes here
%   Detailed explanation goes here
parfor i = 1:length(PayloadRadData)
   missingPulses = setdiff(1:max(PayloadRadData{i}.pulse_num),PayloadRadData{i}.pulse_num);
   if ~isempty(missingPulses)
       NaNs1 = NaN(length(missingPulses),1);
       NaNs2 = NaN(length(missingPulses),32);
       missingPulseTable = table(NaNs1, NaNs1, NaNs1, missingPulses', NaNs1, NaNs2, NaNs2, NaNs1, NaNs1, 'VariableNames', PayloadRadData{i}.Properties.VariableNames);
       PayloadRadData{i} = [PayloadRadData{i};missingPulseTable];
       PayloadRadData{i} = sortrows(PayloadRadData{i}, "pulse_num");
   end
end
end

