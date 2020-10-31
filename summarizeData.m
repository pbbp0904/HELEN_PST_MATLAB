function [Stats, Graphs] = summarizeData(PayloadEnvData, PayloadRadData, PayloadPrefixes, PayloadColors)

Stats = getStats(PayloadEnvData, PayloadRadData, PayloadPrefixes);
Graphs = getGraphs(PayloadEnvData, PayloadRadData, PayloadPrefixes, PayloadColors, Stats);
createReport(Stats, Graphs, PayloadPrefixes, PayloadColors);
end

