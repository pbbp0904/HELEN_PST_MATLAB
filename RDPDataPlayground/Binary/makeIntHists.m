function [intHistA,intHistB] = makeIntHists(pulsedata_a,pulsedata_b)

intHistA = histcounts(sum(-pulsedata_a));
intHistB = histcounts(sum(-pulsedata_b));

end

