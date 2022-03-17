function [EPeakA,EIntA,EPeakB,EIntB] = getEnergies(pulsedata_a,pulsedata_b,DectectorType)
%getEnergies - Created by Sean Hassler.
% Finding Energies.

DataStart = 4;
Mult = 32 - DataStart + 1;

if strcmp(DectectorType,"NONE")

    EPeakA = max(-pulsedata_a(:,DataStart:end),[],2) - min(-pulsedata_a(:,DataStart:end),[],2);
    EIntA = sum(-pulsedata_a(:,DataStart:end),2) - Mult * min(-pulsedata_a(:,DataStart:end),[],2);
    EPeakB = max(-pulsedata_b(:,DataStart:end),[],2) - min(-pulsedata_b(:,DataStart:end),[],2);
    EIntB = sum(-pulsedata_b(:,DataStart:end),2) - Mult * min(-pulsedata_b(:,DataStart:end),[],2);
else
    
    EPeakA = max(-pulsedata_a(:,DataStart:end),[],2);
    EIntA = sum(-pulsedata_a(:,DataStart:end),2);
    EPeakB = max(-pulsedata_b(:,DataStart:end),[],2);
    EIntB = sum(-pulsedata_b(:,DataStart:end),2);
    
end

end

