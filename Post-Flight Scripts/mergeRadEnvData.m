function [f] = mergeRadEnvData(PayloadRadData, PayloadEnvData)
%mergedDataTables
for i = 2:2:4
   subSeconds = PayloadRadData{i}.subSecond;
   dcc_time = PayloadRadData{i}.dcc_time;
   pps_time = PayloadRadData{i}.pps_time;
   
   radSeconds = zeros(1,length(subSeconds));
   radSeconds(1) = 9;
   lastj = -100;
   for j = 2:length(subSeconds)
       if (dcc_time(j-1) < pps_time(j-1) && dcc_time(j) >= pps_time(j) && dcc_time(j) >= pps_time(j-1)) || (pps_time(j-1) == 0 && dcc_time(j)+100000<dcc_time(j-1))
           radSeconds(j) = radSeconds(j-1)+1;
           lastj = j;
       else
           radSeconds(j) = radSeconds(j-1);
       end
   end
   PayloadRadData{i}.radSeconds = radSeconds';
   fprintf("Max Radiation Second:%i\n",max(PayloadRadData{i}.radSeconds))
   fprintf("Max Environmental Second:%i\n",max(PayloadEnvData{i}.PacketNum))
   f{i}=join(PayloadRadData{i},PayloadEnvData{i},'LeftKeys','radSeconds','RightKeys','PacketNum');
end


end