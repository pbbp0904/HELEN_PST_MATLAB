function [peakHistA,peakHistB] = makePeakHists(pulsedata_a,pulsedata_b)

peakHistA = histcounts(max(-pulsedata_a'));
peakHistB = histcounts(max(-pulsedata_b'));

end

