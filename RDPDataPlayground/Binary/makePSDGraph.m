function [PSDA,PSDB] = makePSDGraph(pulsedata_a,pulsedata_b)
PSDA = cat(1,max(-pulsedata_a),-pulsedata_a(end,:));
PSDB = cat(1,max(-pulsedata_b),-pulsedata_b(end,:));
end

